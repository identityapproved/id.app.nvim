-- TODO: Try different yazi plugin
return {
	"DreamMaoMao/yazi.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>yz", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
	},
}
