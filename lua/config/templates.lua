local M = {}

local function templates_root()
  return vim.fn.stdpath("config") .. "/templates"
end

local function file_exists(path)
  return (vim.uv or vim.loop).fs_stat(path) ~= nil
end

local function read_lines(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  return lines
end

local function list_files_recursive(root, opts)
  opts = opts or {}
  local exclude = opts.exclude or function(_) return false end

  local out = {}
  local function walk(dir, prefix)
    for name, kind in vim.fs.dir(dir) do
      local full = dir .. "/" .. name
      local rel = (prefix ~= "" and (prefix .. "/" .. name) or name)
      if not exclude(rel) then
        if kind == "file" then
          table.insert(out, rel)
        elseif kind == "directory" then
          walk(full, rel)
        end
      end
    end
  end

  if file_exists(root) then
    walk(root, "")
  end

  table.sort(out)
  return out
end

local function apply_placeholders(lines, ctx)
  local replaced = {}
  for _, line in ipairs(lines) do
    local s = line
    s = s:gsub("{{date}}", ctx.date)
    s = s:gsub("{{datetime}}", ctx.datetime)
    s = s:gsub("{{title}}", ctx.title)
    s = s:gsub("{{file}}", ctx.file)
    s = s:gsub("{{path}}", ctx.path)
    table.insert(replaced, s)
  end
  return replaced
end

local function insert_lines(lines)
  vim.api.nvim_put(lines, "c", true, true)
end

local function pick_and_insert(opts)
  local fzf = require("fzf-lua")
  local root = opts.root
  local prompt = opts.prompt
  local exclude = opts.exclude

  if not file_exists(root) then
    vim.notify("Templates dir not found: " .. root, vim.log.levels.WARN)
    return
  end

  local candidates = list_files_recursive(root, { exclude = exclude })
  if vim.tbl_isempty(candidates) then
    vim.notify("No templates found in: " .. root, vim.log.levels.INFO)
    return
  end

  local ctx = {
    date = os.date("%Y-%m-%d"),
    datetime = os.date("%Y-%m-%d %H:%M"),
    path = vim.fn.expand("%:p"),
    file = vim.fn.expand("%:t"),
    title = vim.fn.expand("%:t:r"),
  }

  fzf.fzf_exec(candidates, {
    prompt = prompt,
    actions = {
      ["default"] = function(selected)
        local rel = selected[1]
        if not rel or rel == "" then
          return
        end
        local full = root .. "/" .. rel
        local lines = read_lines(full)
        if not lines then
          vim.notify("Failed to read template: " .. full, vim.log.levels.ERROR)
          return
        end
        insert_lines(apply_placeholders(lines, ctx))
      end,
    },
  })
end

function M.insert_template()
  local root = templates_root()
  local ft = vim.bo.filetype

  if ft == "markdown" or ft == "markdown_inline" then
    pick_and_insert({
      root = root .. "/notes",
      prompt = "Notes templates> ",
    })
    return
  end

  local by_ft = root .. "/code/" .. (ft ~= "" and ft or "_unknown")
  local common = root .. "/code/_common"
  local target = file_exists(by_ft) and by_ft or common
  pick_and_insert({
    root = target,
    prompt = ("Templates(%s)> "):format(ft ~= "" and ft or "unknown"),
  })
end

function M.insert_callout()
  local ft = vim.bo.filetype
  if ft ~= "markdown" and ft ~= "markdown_inline" then
    vim.notify("Callouts are for Markdown buffers", vim.log.levels.INFO)
    return
  end
  pick_and_insert({
    root = templates_root() .. "/callouts",
    prompt = "Callouts> ",
  })
end

return M
