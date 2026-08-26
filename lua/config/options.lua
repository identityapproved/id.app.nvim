require("config.clipboard").setup()

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.maplocalleader = " "

-- Use basedpyright (installs via pip, bundles its own Node) for the LazyVim
-- python extra. Default is "pyright", an npm package that fails to install on
-- this host (no system node/npm). See lua/plugins/python.lua.
vim.g.lazyvim_python_lsp = "basedpyright"

vim.opt.conceallevel = 0
vim.opt.inccommand = "split"

-- Open manpages with :Man (K over a word, :Man <name> from inside nvim)
vim.opt.keywordprg = ":Man"


vim.env.ZK_NOTEBOOK_DIR = vim.env.HOME .. "/zettelnotes"

-- Ensure Mason's bin dir is on PATH so vim.lsp can resolve Mason-only servers
-- (basedpyright, lua_ls, ...). Appended so it can't shadow system binaries.
do
  local mason_bin = vim.fn.expand("$HOME/.local/share/nvim/mason/bin")
  if not (":" .. vim.env.PATH .. ":"):find(":" .. mason_bin .. ":", 1, true) then
    vim.env.PATH = vim.env.PATH .. ":" .. mason_bin
  end
end

-- Disable automatic signature popups; use a manual keymap instead
vim.lsp.handlers["textDocument/signatureHelp"] = function() end

-- Disable swapfiles
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Keep LazyVim autoformat enabled by default
vim.g.autoformat = true
