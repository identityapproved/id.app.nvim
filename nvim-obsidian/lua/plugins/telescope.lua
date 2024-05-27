local config = function()
	local telescope = require("telescope")
	telescope.setup({
		pickers = {
			find_files = {
				previewer = true,
				hidden = true,
			},
			live_grep = {
				previewer = true,
			},
			buffers = {
				previewer = false,
			},
		},
	})
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = config,
}
