return {
	"SmiteshP/nvim-navbuddy",
	event = { "BufReadPre", "BufNewFile" },
	requires = {
		"neovim/nvim-lspconfig",
		"SmiteshP/nvim-navic",
		"MunifTanjim/nui.nvim",
		"numToStr/Comment.nvim", -- Optional
		"nvim-telescope/telescope.nvim", -- Optional
	},
	config = function()
		require("nvim-navbuddy").setup({
			window = {
				border = "none",
			},
		})
	end,
}
