local function normalize_path(path)
  if not path or path == "" then
    return nil
  end
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function path_in_root(path, root)
  path = normalize_path(path)
  root = normalize_path(root)
  if not path or not root then
    return false
  end
  return path == root or vim.startswith(path, root .. "/")
end

local function mark_name(mark)
  return tostring(mark or ""):gsub("^'", "")
end

local function mark_file(item, bufnr)
  if item.file and item.file ~= "" then
    return normalize_path(item.file)
  end
  local pos = item.pos or {}
  local item_buf = pos[1] and pos[1] > 0 and pos[1] or bufnr
  if item_buf and item_buf > 0 then
    return normalize_path(vim.api.nvim_buf_get_name(item_buf))
  end
end

local function line_text(path, lnum)
  if not path or not lnum or lnum < 1 then
    return ""
  end

  local bufnr = vim.fn.bufnr(path)
  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) then
    return vim.trim(vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or "")
  end

  local ok, lines = pcall(vim.fn.readfile, path, "", lnum)
  if not ok or not lines[lnum] then
    return ""
  end
  return vim.trim(lines[lnum])
end

local function collect_buffer_marks(bufnr, entries, seen, root)
  local ok, marks = pcall(vim.fn.getmarklist, bufnr)
  if not ok then
    return
  end

  for _, item in ipairs(marks) do
    local pos = item.pos or {}
    local lnum = pos[2] or 0
    local col = pos[3] or 0
    local file = mark_file(item, bufnr)
    local mark = mark_name(item.mark)
    if file and lnum > 0 and mark:match("^[%a]$") and (not root or path_in_root(file, root)) then
      local key = table.concat({ mark, file, lnum, col }, "\t")
      if not seen[key] then
        seen[key] = true
        table.insert(entries, {
          mark = mark,
          file = file,
          lnum = lnum,
          col = col,
          text = line_text(file, lnum),
        })
      end
    end
  end
end

local function collect_global_marks(entries, seen, root)
  local ok, marks = pcall(vim.fn.getmarklist)
  if not ok then
    return
  end

  for _, item in ipairs(marks) do
    local pos = item.pos or {}
    local lnum = pos[2] or 0
    local col = pos[3] or 0
    local file = mark_file(item)
    local mark = mark_name(item.mark)
    if file and lnum > 0 and mark:match("^[%a]$") and (not root or path_in_root(file, root)) then
      local key = table.concat({ mark, file, lnum, col }, "\t")
      if not seen[key] then
        seen[key] = true
        table.insert(entries, {
          mark = mark,
          file = file,
          lnum = lnum,
          col = col,
          text = line_text(file, lnum),
        })
      end
    end
  end
end

local function collect_open_buffer_marks(root)
  local entries = {}
  local seen = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr) then
      collect_buffer_marks(bufnr, entries, seen, root)
    end
  end
  collect_global_marks(entries, seen, root)

  table.sort(entries, function(a, b)
    if a.file == b.file then
      if a.lnum == b.lnum then
        return a.mark < b.mark
      end
      return a.lnum < b.lnum
    end
    return a.file < b.file
  end)

  return entries
end

local function project_root()
  local ok, root = pcall(function()
    return LazyVim.root({ buf = 0, normalize = true })
  end)
  return ok and root or vim.uv.cwd()
end

local function relative_to_root(path, root)
  path = normalize_path(path)
  root = normalize_path(root)
  if not path or not root or not path_in_root(path, root) then
    return path or ""
  end
  return path == root and "." or path:sub(#root + 2)
end

local function show_marks_picker(opts)
  opts = opts or {}
  local root = opts.project and project_root() or nil
  local entries = collect_open_buffer_marks(root)
  if vim.tbl_isempty(entries) then
    vim.notify(opts.project and "No marks found in project" or "No marks found in open buffers", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, entry in ipairs(entries) do
    local file = root and relative_to_root(entry.file, root) or vim.fn.fnamemodify(entry.file, ":~")
    items[#items + 1] = {
      text = table.concat({ entry.mark, file, entry.lnum, entry.col, entry.text }, " "),
      mark = entry.mark,
      file = entry.file,
      pos = { entry.lnum, math.max(entry.col - 1, 0) },
      display_file = file,
      lnum = entry.lnum,
      col = entry.col,
      line = entry.text,
    }
  end

  Snacks.picker({
    title = opts.project and "Project Marks" or "Open Buffer Marks",
    source = opts.project and "marks_project" or "marks_open",
    items = items,
    format = function(item)
      return {
        { item.mark, "Identifier" },
        { "  " },
        { string.format("%s:%d:%d", item.display_file, item.lnum, item.col), "Directory" },
        { "  " },
        { item.line or "", "Comment" },
      }
    end,
    preview = function(ctx)
      Snacks.picker.preview.file(ctx)
    end,
    confirm = "jump",
    layout = {
      preset = "default",
    },
  })
end

return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>m?", function() show_marks_picker() end, desc = "Marks in open buffers" },
    { "<leader>m/", function() show_marks_picker({ project = true }) end, desc = "Marks in project" },
    { "<leader>m'", "<cmd>MarksListAll<cr>", desc = "Marks to location list" },
    { '<leader>m"', "<cmd>MarksQFListAll<cr>", desc = "Marks to quickfix" },
    { "<leader>m|", "<cmd>BookmarksListAll<cr>", desc = "Bookmarks to location list" },
    { "<leader>m\\", "<cmd>BookmarksQFListAll<cr>", desc = "Bookmarks to quickfix" },
    { "<leader>m`", "<cmd>MarksToggleSigns<cr>", desc = "Toggle mark signs" },
  },
  opts = {
    default_mappings = false,
    builtin_marks = { ".", "<", ">", "^" },
    cyclic = true,
    force_write_shada = true,
    refresh_interval = 250,
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    excluded_filetypes = {
      "alpha",
      "dashboard",
      "lazy",
      "mason",
      "noice",
      "snacks_dashboard",
      "snacks_picker_input",
      "snacks_picker_list",
    },
    excluded_buftypes = {
      "help",
      "nofile",
      "prompt",
      "quickfix",
      "terminal",
    },
    bookmark_0 = {
      sign = "!",
      virt_text = "bookmark",
      annotate = true,
    },
  },
  config = function(_, opts)
    require("marks").setup(opts)

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc, remap = true, silent = true })
    end

    map("<leader>m", "<Plug>(Marks-set)", "Set mark")
    map("<leader>m,", "<Plug>(Marks-setnext)", "Set next available mark")
    map("<leader>m;", "<Plug>(Marks-toggle)", "Toggle mark")
    map("<leader>md", "<Plug>(Marks-delete)", "Delete mark")
    map("<leader>md-", "<Plug>(Marks-deleteline)", "Delete marks on line")
    map("<leader>md<space>", "<Plug>(Marks-deletebuf)", "Delete marks in buffer")
    map("<leader>m:", "<Plug>(Marks-preview)", "Preview mark")
    map("<leader>m]", "<Plug>(Marks-next)", "Next mark")
    map("<leader>m[", "<Plug>(Marks-prev)", "Previous mark")

    map("<leader>md=", "<Plug>(Marks-delete-bookmark)", "Delete bookmark under cursor")
    map("<leader>m}", "<Plug>(Marks-next-bookmark)", "Next bookmark")
    map("<leader>m{", "<Plug>(Marks-prev-bookmark)", "Previous bookmark")

    for i = 0, 9 do
      map(("<leader>m%d"):format(i), ("<Plug>(Marks-set-bookmark%d)"):format(i), ("Set bookmark %d"):format(i))
      map(
        ("<leader>md%d"):format(i),
        ("<Plug>(Marks-delete-bookmark%d)"):format(i),
        ("Delete bookmark %d"):format(i)
      )
      map(
        ("<leader>mt%d"):format(i),
        ("<Plug>(Marks-toggle-bookmark%d)"):format(i),
        ("Toggle bookmark %d"):format(i)
      )
      map(
        ("<leader>m]%d"):format(i),
        ("<Plug>(Marks-next-bookmark%d)"):format(i),
        ("Next bookmark %d"):format(i)
      )
      map(
        ("<leader>m[%d"):format(i),
        ("<Plug>(Marks-prev-bookmark%d)"):format(i),
        ("Previous bookmark %d"):format(i)
      )
    end

    vim.api.nvim_create_user_command("MarksSnacksOpen", function()
      show_marks_picker()
    end, { desc = "Pick marks from open buffers with Snacks" })
    vim.api.nvim_create_user_command("MarksSnacksProject", function()
      show_marks_picker({ project = true })
    end, { desc = "Pick marks from the current project with Snacks" })
  end,
}
