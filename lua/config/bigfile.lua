-- Shared "is this buffer too big to work on" test, ported from NormalNvim
-- (lua/base/utils/init.lua). Thresholds live in `vim.g.big_file`, set in
-- lua/config/options.lua.
--
-- This is deliberately separate from snacks.bigfile, which keeps its own much
-- larger threshold and handles treesitter/LSP for genuinely huge files. This one
-- gates our own per-buffer work: the markdown save normalizer and colorizer.

local M = {}

--- @param bufnr? number buffer to test, defaults to the current one.
--- @return boolean
function M.is_big_file(bufnr)
  bufnr = bufnr or 0
  local limits = vim.g.big_file
  if not limits then
    return false
  end
  local filesize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  return (filesize > limits.size) or (nlines > limits.lines)
end

return M
