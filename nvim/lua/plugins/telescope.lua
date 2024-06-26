-- Additional
-- https://github.com/jonarrien/telescope-cmdline.nvim
local config = function()
	local telescope = require("telescope")
	-- telescope.setup({
	-- 	pickers = {
	-- 		find_files = {
	-- 			previewer = true,
	-- 			hidden = true,
	-- 		},
	-- 		live_grep = {
	-- 			previewer = true,
	-- 		},
	-- 		buffers = {
	-- 			previewer = false,
	-- 		},
	-- 	},
	-- extensions = {
	-- 	extension_name = "cmdline",
	-- },
	-- })
	telescope.load_extension("cmdline", "projects")
end

return {
	"nvim-telescope/telescope.nvim",
	-- tag = "0.1.6",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jonarrien/telescope-cmdline.nvim",
	},
	config = config,
}
