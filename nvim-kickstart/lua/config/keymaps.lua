-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Buffer Navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>') -- Next buffer
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>') -- Prev buffer
vim.keymap.set('n', '<leader>wq', '<cmd>wq<CR>') -- Prev buffer
vim.keymap.set('n', '<leader>wa', '<cmd>wall<CR>') -- Prev buffer
vim.keymap.set('n', '<leader>qa', '<cmd>qall<CR>') -- Prev buffer
-- vim.keymap.set( "n", "<leader>bb", ":e #") -- Switch to Other Buffer
-- vim.keymap.set( "n", "<leader>`", ":e #") -- Switch to Other Buffer

--  See `:help wincmd` for a list of all window commands
--- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
--- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
--- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
--- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Pane and Window Navigation
vim.keymap.set('n', '<C-H>', '<C-w>h', { desc = 'Move focus to the left window' }) -- Navigate Left
vim.keymap.set('n', '<C-J>', '<C-w>j', { desc = 'Move focus to the lower window' }) -- Navigate Down
vim.keymap.set('n', '<C-K>', '<C-w>k', { desc = 'Move focus to the upper window' }) -- Navigate Up
vim.keymap.set('n', '<C-L>', '<C-w>l', { desc = 'Move focus to the right window' }) -- Navigate Right
vim.keymap.set('t', '<C-h>', 'wincmd h') -- Navigate Left
vim.keymap.set('t', '<C-j>', 'wincmd j') -- Navigate Down
vim.keymap.set('t', '<C-k>', 'wincmd k') -- Navigate Up
vim.keymap.set('t', '<C-l>', 'wincmd l') -- Navigate Right
vim.keymap.set('n', '<C-h>', 'TmuxNavigateLeft') -- Navigate Left
vim.keymap.set('n', '<C-j>', 'TmuxNavigateDown') -- Navigate Down
vim.keymap.set('n', '<C-k>', 'TmuxNavigateUp') -- Navigate Up
vim.keymap.set('n', '<C-l>', 'TmuxNavigateRight') -- Navigate Right

-- Window Management
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>') -- Split Vertically
vim.keymap.set('n', '<leader>sx', '<cmd>split<CR>') -- Split Horizontally

-- Indenting
vim.keymap.set('v', '<', '<gv') -- Shift Indentation to Left
vim.keymap.set('v', '>', '>gv') -- Shift Indentation to Right

-- Show Full File-Path
-- vim.keymap.set( "n", "<leader>pwd", "echo expand('%:p')") -- Show Full File Path

-- TIP Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

--  See `:help vim.keymap.set()`
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Zen Mode
-- api.nvim_set_keymap("n", "<leader>zn", ":TZNarrow<CR>", {})
-- api.nvim_set_keymap("v", "<leader>zn", ":'<,'>TZNarrow<CR>", {})
-- api.nvim_set_keymap("n", "<leader>sm", ":TZFocus<CR>", {})
-- api.nvim_set_keymap("n", "<leader>zm", ":TZMinimalist<CR>", {})
-- api.nvim_set_keymap("n", "<leader>za", ":TZAtaraxis<CR>", {})

-- Comments
map('n', '<C-c>', 'gtc', { noremap = false })
vim.api.nvim_set_keymap('v', '<C-c>', 'goc', { noremap = false })
