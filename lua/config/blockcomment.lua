-- Block comment toggler.
-- Neovim's built-in commenting (gc/gcc) is line-only; this wraps a visual
-- selection (or the current line) in the filetype's block delimiters and
-- toggles them back off.

local M = {}

-- open/close delimiters per filetype
local delims = {
  c = { "/*", "*/" },
  cpp = { "/*", "*/" },
  cs = { "/*", "*/" },
  java = { "/*", "*/" },
  javascript = { "/*", "*/" },
  javascriptreact = { "/*", "*/" },
  typescript = { "/*", "*/" },
  typescriptreact = { "/*", "*/" },
  css = { "/*", "*/" },
  scss = { "/*", "*/" },
  less = { "/*", "*/" },
  rust = { "/*", "*/" },
  go = { "/*", "*/" },
  php = { "/*", "*/" },
  json = { "/*", "*/" },
  jsonc = { "/*", "*/" },
  glsl = { "/*", "*/" },
  lua = { "--[[", "]]" },
  python = { '"""', '"""' },
  html = { "<!--", "-->" },
  xml = { "<!--", "-->" },
  svg = { "<!--", "-->" },
  vue = { "<!--", "-->" },
  markdown = { "<!--", "-->" },
}

-- linewise_current = true operates on the current line; otherwise on the
-- last visual selection (marks '< and '>).
function M.toggle(linewise_current)
  local d = delims[vim.bo.filetype]
  if not d then
    vim.notify("block-comment: no delimiters for filetype '" .. vim.bo.filetype .. "'", vim.log.levels.WARN)
    return
  end
  local open, close = d[1], d[2]

  local sl, el
  if linewise_current then
    sl = vim.fn.line(".")
    el = sl
  else
    sl, el = vim.fn.line("'<"), vim.fn.line("'>")
  end
  if sl > el then
    sl, el = el, sl
  end

  local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
  local n = #lines
  if n == 0 then
    return
  end

  local first_trim = lines[1]:match("^%s*(.-)%s*$")
  local last_trim = lines[n]:match("^%s*(.-)%s*$")

  if vim.startswith(first_trim, open) and vim.endswith(last_trim, close) then
    -- already block-commented: strip delimiters
    lines[1] = lines[1]:gsub("^(%s*)" .. vim.pesc(open) .. "%s?", "%1", 1)
    lines[n] = lines[n]:gsub("%s?" .. vim.pesc(close) .. "(%s*)$", "%1", 1)
  else
    -- wrap the selection
    local indent = lines[1]:match("^%s*")
    lines[1] = indent .. open .. " " .. lines[1]:sub(#indent + 1)
    lines[n] = lines[n] .. " " .. close
  end

  vim.api.nvim_buf_set_lines(0, sl - 1, el, false, lines)
end

return M
