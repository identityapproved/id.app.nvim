-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set
local task = require("config.taskwarrior")

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

-- Terminal window navigation (avoid shell handling ctrl-h/j/k/l)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Focus left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Focus lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Focus upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Focus right window" })

map("n", "<leader>zn", "<cmd>ZkNewPrompt<cr>", { desc = "Zk new note (prompt/date)" })
