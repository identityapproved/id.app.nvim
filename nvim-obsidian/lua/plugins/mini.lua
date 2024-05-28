return {
	"echasnovski/mini.nvim",
	lazy = false,
	config = function()
		-- require("mini.completion").setup({})
		require("mini.cursorword").setup({})
		require("mini.surround").setup({})
		require("mini.bufremove").setup({})
		require("mini.pairs").setup({})
		-- require("mini.notify").setup({})
	end,
}
