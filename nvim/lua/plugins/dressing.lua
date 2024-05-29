return { -- This plugin overrides the default vim selector ui (e.g <leader>ca)
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	config = function(_, opts)
		require("dressing").setup(opts)
	end,

	opts = {
		default_prompt = "❯ ",
	},
}
