local map = vim.keymap.set
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- map("n", "<leader>?", ":SearchBoxMatchAll clear_matches=false<CR>")

-- Buffer Navigation
map("n", "<leader>bn", "<cmd>bnext<CR>") -- Next buffer
map("n", "<leader>bp", "<cmd>bprevious<CR>") -- Prev buffer
map("n", "<leader>wq", "<cmd>wq<CR>") -- Prev buffer
map("n", "<leader>wa", "<cmd>wall<CR>") -- Prev buffer
map("n", "<leader>qa", "<cmd>qall<CR>") -- Prev buffer
map("n", "<leader>qq", "<cmd>q<CR>") -- Prev buffer
-- map("n", "<leader>bb", ":e #") -- Switch to Other Buffer
-- map("n", "<leader>`", ":e #") -- Switch to Other Buffer

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
-- map("n", "<C-/>", "gtc", { noremap = false })
-- map("v", "<C-/>", "goc", { noremap = false })
map("n", "<C-c>", "gtc", { noremap = false })
map("v", "<C-c>", "goc", { noremap = false })

-- Telescope file browser
-- vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files." })
vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers." })
vim.api.nvim_set_keymap("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Find keymaps." })
vim.api.nvim_set_keymap("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find projects." })
vim.api.nvim_set_keymap("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find Todos." })
vim.api.nvim_set_keymap("n", "<leader><leader>", ":Telescope cmdline<CR>", { noremap = true, desc = "Cmdline" })

-- Spectre (visual)
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
-- Cht.sh
vim.api.nvim_set_keymap("n", "<leader>ch", ":CheatList<CR>", { desc = "Cht.sh List" })
vim.api.nvim_set_keymap("n", "<leader>cl", ":CheatClose<CR>", { desc = "Cht.sh Close" })

-- LeetCode
vim.api.nvim_set_keymap("n", "<leader>lc", ":Leet<CR>", { desc = "LeetCode" })

-- Lazygit
map("n", "<leader>gg", function()
	local term = require("toggleterm.terminal").Terminal
	local lazygit = term:new({
		cmd = "lazygit",
		dir = "git_dir",
		direction = "float",
		float_opts = {
			border = "none",
			-- fullscreen
			width = vim.o.columns,
			height = vim.o.lines,
		},
	})
	lazygit:toggle()
end, { desc = "Lazygit" })

-- Compilers
-- Open compiler
vim.api.nvim_set_keymap("n", "<leader>co", "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
-- Redo last selected option
vim.api.nvim_set_keymap(
	"n",
	"<leader>cr",
	"<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
		.. "<cmd>CompilerRedo<cr>",
	{ noremap = true, silent = true }
)
-- Toggle compiler results
vim.api.nvim_set_keymap("n", "<leader>ct", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>cs",
	"<cmd>:AsyncRun gcc '$(VIM_FILEPATH)' -o '$(VIM_FILEDIR)/$(VIM_FILENOEXT)'<cr>",
	{ noremap = true, silent = true }
)
-- vim.api.nvim_set_keymap("n", "<leader>cp", "<cmd>:AsyncRun py '$(VIM_FILEPATH)'<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>cp",
	"<cmd>:AsyncRun -cwd=$(VIM_FILEDIR) -mode=term -pos=bottom python3 '$(VIM_FILEPATH)'<cr>",
	{ noremap = true, silent = true }
)
