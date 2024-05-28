return {
	"startup-nvim/startup.nvim",
	lazy = false,
	priority = 999,
	requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	config = function()
		require("startup").setup({
			theme = "startify",
		})
	end,
}
