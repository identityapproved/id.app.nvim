require("config.clipboard").setup()

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.conceallevel = 0


vim.env.ZK_NOTEBOOK_DIR = vim.env.HOME .. "/drives/kodak/zettelnotes"

-- Disable automatic signature popups; use a manual keymap instead
vim.lsp.handlers["textDocument/signatureHelp"] = function() end

-- Disable swapfiles
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
