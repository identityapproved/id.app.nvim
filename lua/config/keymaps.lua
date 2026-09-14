-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set
local task = require("config.taskwarrior")

map({ "n", "x" }, "j", "j", { desc = "Down" })
map({ "n", "x" }, "k", "k", { desc = "Up" })
map({ "n", "x" }, "<Down>", "j", { desc = "Down" })
map({ "n", "x" }, "<Up>", "k", { desc = "Up" })

map("n", "<leader>twa", task.add_task, { desc = "Add Taskwarrior task" })

map("n", "<leader>t-", function()
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (horizontal split)" })

map("n", "<leader>t|", function()
  vim.cmd("vsplit | terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (vertical split)" })

map("n", "<leader>tmp", function()
  local ts = os.date("%Y%m%d-%H%M%S")
  local path = "/tmp/nvim-note-" .. ts .. ".md"
  vim.cmd("vsplit " .. vim.fn.fnameescape(path))
  vim.bo.filetype = "markdown"
end, { desc = "Temporary markdown note (vertical split)" })

-- Terminal window navigation (avoid shell handling ctrl-h/j/k/l). fzf-lua runs
-- fzf in a terminal buffer (filetype "fzf"), where the keys belong to fzf --
-- ctrl-j / ctrl-k move its list, as in the tmux picker -- so they pass through
-- there. expr maps are noremap, so the returned key reaches the job as is.
local function term_nav(key)
  return function()
    if vim.bo.filetype == "fzf" then
      return "<C-" .. key .. ">"
    end
    return "<C-\\><C-n><C-w>" .. key
  end
end
map("t", "<C-h>", term_nav("h"), { expr = true, desc = "Focus left window" })
map("t", "<C-j>", term_nav("j"), { expr = true, desc = "Focus lower window" })
map("t", "<C-k>", term_nav("k"), { expr = true, desc = "Focus upper window" })
map("t", "<C-l>", term_nav("l"), { expr = true, desc = "Focus right window" })

map("n", "<leader>zn", "<cmd>ZkNewPrompt<cr>", { desc = "Zk new note (prompt/date)" })

-- Block comments (built-in gc/gcc is line-only). gb wraps a selection, gbc the current line.
map("x", "gb", ":<C-u>lua require('config.blockcomment').toggle()<cr>", { silent = true, desc = "Toggle block comment (selection)" })
map("n", "gbc", "<cmd>lua require('config.blockcomment').toggle(true)<cr>", { silent = true, desc = "Toggle block comment (line)" })
