local M = {}

local function normalize_size(direction, size)
  if not size or size <= 0 then
    return nil
  end
  if size > 0 and size < 1 then
    local win = vim.api.nvim_get_current_win()
    if direction == "vertical" then
      return math.max(1, math.floor(vim.api.nvim_win_get_width(win) * size))
    end
    return math.max(1, math.floor(vim.api.nvim_win_get_height(win) * size))
  end
  return size
end

local function open_split(direction, size, position)
  local final_size = normalize_size(direction, size)
  local prefix = ""

  if position == "left" then
    prefix = "leftabove "
  elseif position == "right" then
    prefix = "rightbelow "
  elseif position == "top" then
    prefix = "aboveleft "
  elseif position == "bottom" then
    prefix = "belowright "
  end

  if direction == "vertical" then
    vim.cmd(prefix .. "vsplit")
    local win = vim.api.nvim_get_current_win()
    if final_size and final_size > 0 then
      local ok = pcall(vim.api.nvim_win_set_width, win, final_size)
      if not ok then
        vim.cmd(("vertical resize %d"):format(final_size))
      end
    end
    return win
  end

  vim.cmd(prefix .. "split")
  local win = vim.api.nvim_get_current_win()
  if final_size and final_size > 0 then
    local ok = pcall(vim.api.nvim_win_set_height, win, final_size)
    if not ok then
      vim.cmd(("resize %d"):format(final_size))
    end
  end
  return win
end

local function patch_terminal_toggle()
  local term = require("codex.terminal")

  term.ensure_visible = function()
    term.get_active_terminal_bufnr()

    if term.state.winid and vim.api.nvim_win_is_valid(term.state.winid) then
      return true
    end

    if term.state.snacks_term and term.state.bufnr and vim.api.nvim_buf_is_valid(term.state.bufnr) then
      local ok = pcall(function()
        if term.state.snacks_term.show then
          term.state.snacks_term:show()
        end
      end)
      if ok then
        local wid = vim.fn.bufwinid(term.state.bufnr)
        if wid ~= -1 then
          term.state.winid = wid
          return true
        end
      end
    end

    if term.state.bufnr and vim.api.nvim_buf_is_valid(term.state.bufnr) then
      local cfg = require("codex").state.opts.terminal or {}
      local win = open_split(cfg.direction or "horizontal", cfg.size or 15, cfg.position)
      if win then
        vim.api.nvim_win_set_buf(win, term.state.bufnr)
        term.state.winid = win
      end
      return true
    end

    return false
  end
end

function M.setup(opts)
  require("codex").setup(opts)
  patch_terminal_toggle()
end

return M
