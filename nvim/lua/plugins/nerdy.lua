return { -- Glyph Picker
	"2kabhishek/nerdy.nvim",

	keys = {
		{
			"<leader>fe",
			"<cmd> Nerdy<CR>",
			mode = "n",
			desc = "Glyph Picker",
		}, -- Gigantic Search Base
	},

	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-telescope/telescope.nvim",
	},

	cmd = "Nerdy",
}
