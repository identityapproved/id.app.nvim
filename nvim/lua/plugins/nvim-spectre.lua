return {
	"nvim-pack/nvim-spectre",
	cmd = "Spectre",
	keys = {
		{
			"<leader>sr",
			function()
				require("spectre").toggle()
			end,
			desc = "Toggle Spectre",
		},
		{
			"<leader>sf",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Spectre on current file",
		},
	},
}
