-- Collect local links/references from a Markdown buffer and pick one with Snacks.
--
-- Handles inline links, images, wiki links, reference usages and reference
-- definitions. External targets (http, mailto, ...) are skipped on purpose:
-- this is for navigating the local note tree.

local M = {}

local uv = vim.uv or vim.loop

local KIND_LABEL = {
  link = "link",
  image = "image",
  wiki = "wiki",
  ref = "ref",
  refdef = "refdef",
  anchor = "anchor",
}

local function file_exists(path)
  local stat = path and uv.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

local function is_external(target)
  return target:match("^%a[%w+.-]*://") ~= nil
    or target:match("^mailto:") ~= nil
    or target:match("^tel:") ~= nil
    or target:match("^www%.") ~= nil
end

local function clean_target(target)
  local s = vim.trim(target)
  s = s:gsub("^<(.*)>$", "%1")
  -- drop an optional link title: [text](path "title")
  s = s:gsub('%s+".*"$', ""):gsub("%s+'.*'$", ""):gsub("%s+%b()$", "")
  return vim.trim(s)
end

local function project_root()
  local ok, root = pcall(function()
    return LazyVim.root({ buf = 0, normalize = true })
  end)
  return (ok and root) or uv.cwd()
end

local function slugify(text)
  local s = vim.trim(text):lower()
  s = s:gsub("[^%w%s%-_]", "")
  s = s:gsub("%s+", "-")
  return s
end

-- Ranges covered by inline code spans, so `[[foo]]` inside backticks is ignored.
local function code_span_ranges(line)
  local ranges, init = {}, 1
  while true do
    local s, e = line:find("`+", init)
    if not s then
      break
    end
    local ticks = line:sub(s, e)
    local s2, e2 = line:find(ticks, e + 1, true)
    if not s2 then
      break
    end
    table.insert(ranges, { s, e2 })
    init = e2 + 1
  end
  return ranges
end

local function scan_line(line, lnum, entries)
  local occupied = code_span_ranges(line)

  local function add(s, e, kind, label, target)
    for _, r in ipairs(occupied) do
      if s <= r[2] and e >= r[1] then
        return
      end
    end
    table.insert(occupied, { s, e })
    table.insert(entries, {
      lnum = lnum,
      col = s,
      kind = kind,
      label = vim.trim(label or ""),
      raw = target,
    })
  end

  -- reference definition: [id]: ./target.md "title"
  local def_id, def_target = line:match("^%s*%[([^%]]+)%]:%s*(.+)$")
  if def_id then
    add(1, #line, "refdef", def_id, def_target)
    return
  end

  -- wiki links: [[note]], [[note|label]], [[note#anchor]], ![[embed]]
  local init = 1
  while true do
    local s, e, inner = line:find("%[%[([^%]]+)%]%]", init)
    if not s then
      break
    end
    local name, label = inner:match("^([^|]+)|(.*)$")
    name = name or inner
    if s > 1 and line:sub(s - 1, s - 1) == "!" then
      s = s - 1
    end
    add(s, e, "wiki", label or name, name)
    init = e + 1
  end

  -- images before links so ![a](b) is not counted twice
  for _, spec in ipairs({
    { kind = "image", pat = "!%[([^%]]*)%]%(([^)]*)%)" },
    { kind = "link", pat = "%[([^%]]*)%]%(([^)]*)%)" },
    { kind = "ref", pat = "%[([^%]]*)%]%[([^%]]*)%]" },
  }) do
    init = 1
    while true do
      local s, e, label, target = line:find(spec.pat, init)
      if not s then
        break
      end
      add(s, e, spec.kind, label, target)
      init = e + 1
    end
  end
end

local function read_lines(path, cache)
  if cache[path] ~= nil then
    return cache[path]
  end
  local lines = {}
  local bufnr = vim.fn.bufnr(path)
  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) then
    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  else
    local ok, read = pcall(vim.fn.readfile, path)
    lines = (ok and read) or {}
  end
  cache[path] = lines
  return lines
end

local function anchor_lnum(path, anchor, cache)
  if not path or not anchor or anchor == "" then
    return nil
  end
  local want = slugify(anchor)
  for i, line in ipairs(read_lines(path, cache)) do
    local title = line:match("^#+%s+(.+)$")
    if title and slugify(title:gsub("%s*#+%s*$", "")) == want then
      return i
    end
  end
  return nil
end

local function resolve_relative(target, base_dir)
  local p = vim.fs.normalize(target)
  if not p:match("^/") then
    p = vim.fs.normalize(base_dir .. "/" .. p)
  end
  if file_exists(p) then
    return p
  end
  if not p:match("%.[%w]+$") and file_exists(p .. ".md") then
    return p .. ".md"
  end
  return nil, p
end

local function resolve_wiki(name, base_dir)
  local candidates = { name }
  if not name:match("%.[%w]+$") then
    table.insert(candidates, 1, name .. ".md")
  end

  for _, candidate in ipairs(candidates) do
    local found = resolve_relative(candidate, base_dir)
    if found then
      return found
    end
  end

  local wanted = candidates[1]
  local ok, hits = pcall(vim.fs.find, vim.fn.fnamemodify(wanted, ":t"), {
    path = project_root(),
    type = "file",
    limit = 20,
  })
  if ok and hits then
    for _, hit in ipairs(hits) do
      if vim.endswith(vim.fs.normalize(hit), wanted) then
        return vim.fs.normalize(hit)
      end
    end
    if hits[1] then
      return vim.fs.normalize(hits[1])
    end
  end

  return nil, vim.fs.normalize(base_dir .. "/" .. wanted)
end

--- Collect local links in a buffer.
---@param bufnr integer|nil
---@return table[] entries
function M.collect(bufnr)
  bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
  local buf_path = vim.api.nvim_buf_get_name(bufnr)
  local base_dir = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or (uv.cwd() or ".")

  local raw, fence = {}, nil
  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local marker = line:match("^%s*([`~][`~][`~]+)")
    if fence then
      if marker and marker:sub(1, 1) == fence:sub(1, 1) and #marker >= #fence then
        fence = nil
      end
    elseif marker then
      fence = marker
    else
      scan_line(line, lnum, raw)
    end
  end

  -- reference definitions resolve [text][id] usages
  local defs = {}
  for _, entry in ipairs(raw) do
    if entry.kind == "refdef" then
      defs[entry.label:lower()] = clean_target(entry.raw)
    end
  end

  local entries, cache = {}, {}
  for _, entry in ipairs(raw) do
    local target = clean_target(entry.raw)
    if entry.kind == "ref" then
      local id = (target ~= "" and target or entry.label):lower()
      target = defs[id] or ""
    end

    if target ~= "" and not is_external(target) then
      local path, anchor = target:match("^(.-)#(.*)$")
      path = path or target
      anchor = (anchor ~= "" and anchor) or nil

      local resolved, missing
      if path == "" then
        entry.kind = "anchor"
        resolved = buf_path ~= "" and buf_path or nil
      elseif entry.kind == "wiki" then
        resolved, missing = resolve_wiki(path, base_dir)
      else
        resolved, missing = resolve_relative(path, base_dir)
      end

      entry.target = target
      entry.file = resolved
      entry.missing = missing
      entry.anchor = anchor
      entry.tlnum = resolved and (anchor_lnum(resolved, anchor, cache) or 1) or nil
      table.insert(entries, entry)
    end
  end

  table.sort(entries, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end
    return a.lnum < b.lnum
  end)

  return entries
end

local function jump_to_source(bufnr, entry)
  local win = vim.fn.bufwinid(bufnr)
  if win == -1 then
    vim.api.nvim_set_current_buf(bufnr)
    win = vim.api.nvim_get_current_win()
  else
    vim.api.nvim_set_current_win(win)
  end
  vim.api.nvim_win_set_cursor(win, { entry.lnum, math.max(entry.col - 1, 0) })
  vim.cmd("normal! zz")
end

local function open_target(bufnr, entry)
  if not entry.file then
    vim.notify(("Target not found: %s"):format(entry.missing or entry.target), vim.log.levels.WARN)
    jump_to_source(bufnr, entry)
    return
  end

  vim.cmd.edit(vim.fn.fnameescape(entry.file))
  local lnum = math.min(entry.tlnum or 1, vim.api.nvim_buf_line_count(0))
  vim.api.nvim_win_set_cursor(0, { lnum, 0 })
  vim.cmd("normal! zz")
end

--- Pick a local link in the current buffer and follow it.
function M.find_links()
  local bufnr = vim.api.nvim_get_current_buf()
  local entries = M.collect(bufnr)
  if vim.tbl_isempty(entries) then
    vim.notify("No local links found in buffer", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, entry in ipairs(entries) do
    local display = entry.file and vim.fn.fnamemodify(entry.file, ":~:.") or entry.target
    if entry.anchor then
      display = display .. "#" .. entry.anchor
    end
    items[#items + 1] = {
      text = table.concat({ KIND_LABEL[entry.kind], entry.label, entry.target, display }, " "),
      entry = entry,
      kind_label = KIND_LABEL[entry.kind],
      label = entry.label ~= "" and entry.label or entry.target,
      display_target = display,
      -- preview/jump land on the target when it exists, on the link otherwise
      file = entry.file or vim.api.nvim_buf_get_name(bufnr),
      pos = { entry.file and (entry.tlnum or 1) or entry.lnum, 0 },
    }
  end

  Snacks.picker({
    title = "Markdown Links",
    source = "markdown_links",
    items = items,
    format = function(item)
      return {
        { ("%-6s"):format(item.kind_label), "Identifier" },
        { "  " },
        { ("%4d"):format(item.entry.lnum), "LineNr" },
        { "  " },
        { item.label, "Title" },
        { "  ->  " },
        { item.display_target, item.entry.file and "Directory" or "DiagnosticWarn" },
      }
    end,
    preview = function(ctx)
      Snacks.picker.preview.file(ctx)
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        open_target(bufnr, item.entry)
      end
    end,
    actions = {
      goto_link = function(picker, item)
        picker:close()
        if item then
          jump_to_source(bufnr, item.entry)
        end
      end,
      yank_target = function(picker, item)
        picker:close()
        if item then
          vim.fn.setreg("+", item.entry.target)
          vim.notify(("Yanked: %s"):format(item.entry.target), vim.log.levels.INFO)
        end
      end,
    },
    win = {
      input = {
        keys = {
          -- <c-l> is TmuxNavigateRight; alt keys match the snacks action convention
          ["<a-l>"] = { "goto_link", mode = { "n", "i" } },
          ["<c-y>"] = { "yank_target", mode = { "n", "i" } },
        },
      },
    },
    layout = { preset = "default" },
  })
end

return M
