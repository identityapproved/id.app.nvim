return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- opts will be merged with the parent spec
	opts = { use_diagnostic_signs = true },
	keys = {
		{ "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Open/close trouble list" },
		{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Open trouble workspace diagnostics" },
		{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Open trouble document diagnostics" },
		{ "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
		{ "<leader>xr", "<cmd>TroubleToggle lsp_references<CR>", desc = "Open trouble LSP references" },
		{ "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
	},
}
