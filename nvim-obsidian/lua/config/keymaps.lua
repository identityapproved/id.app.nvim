local map = vim.keymap.set
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Buffer Navigation
map("n", "<leader>bn", "<cmd>bnext<CR>") -- Next buffer
map("n", "<leader>bp", "<cmd>bprevious<CR>") -- Prev buffer
map("n", "<leader>wq", "<cmd>wq<CR>") -- Prev buffer
map("n", "<leader>wa", "<cmd>wall<CR>") -- Prev buffer
map("n", "<leader>qa", "<cmd>qall<CR>") -- Prev buffer
map("n", "<leader>bb", ":e #") -- Switch to Other Buffer
map("n", "<leader>`", ":e #") -- Switch to Other Buffer

--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Pane and Window Navigation
map("t", "<C-h>", "wincmd h") -- Navigate Left
map("t", "<C-j>", "wincmd j") -- Navigate Down
map("t", "<C-k>", "wincmd k") -- Navigate Up
map("t", "<C-l>", "wincmd l") -- Navigate Right

-- Window Management
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split Vertically" }) -- Split Vertically
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split Horizontally" }) -- Split Horizontally

-- Indenting
map("v", "<", "<gv") -- Shift Indentation to Left
map("v", ">", ">gv") -- Shift Indentation to Right

-- Show Full File-Path
-- map( "n", "<leader>pwd", "echo expand('%:p')") -- Show Full File Path

-- TIP Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

--  See `:help map()`
-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- Zen Mode
vim.api.nvim_set_keymap("n", "<leader>zn", ":TZNarrow<CR>", {})
vim.api.nvim_set_keymap("v", "<leader>zn", ":'<,'>TZNarrow<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>zf", ":TZFocus<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>zm", ":TZMinimalist<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>za", ":TZAtaraxis<CR>", {})

-- Comments
map("n", "<C-/>", "gtc", { noremap = false })
map("v", "<C-/>", "goc", { noremap = false })
-- vim.api.nvim_set_keymap("n", "<C-c>", "gtc", { noremap = false })
-- vim.api.nvim_set_keymap("v", "<C-c>", "goc", { noremap = false })

-- Telescope file browser
-- vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files." })
vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers." })
vim.api.nvim_set_keymap("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Find keymaps." })
