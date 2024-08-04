return {
	"echasnovski/mini.nvim",
	lazy = false,
	config = function()
		-- require("mini.completion").setup({})
		require("mini.cursorword").setup({})
		require("mini.hipatterns").setup({})
		-- require("mini.surround").setup({})
		require("mini.pairs").setup({})
		-- require("mini.notify").setup({
		-- 	window = {
		-- 		winblend = 0,
		-- 	},
		-- })
	end,
}
