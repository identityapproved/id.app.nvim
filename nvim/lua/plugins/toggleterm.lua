local size = function()
	return vim.o.columns * 0.3
end

-- local curr_dir = function()
-- 	return vim.fn.getcwd()
-- end

return {
	"akinsho/toggleterm.nvim",
	keys = {
		-- { "<C-\\>", "<cmd>ToggleTerm size=" .. size() .. "<cr>", desc = "Toggle Terminal", mode = "n" },
		{ "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "n" },
		{ "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "t" },
		{
			"<leader>tf",
			"<cmd>ToggleTerm direction=float<cr>",
			desc = "ToggleTerm Float",
			mode = "n",
		},
		{
			"<leader>th",
			"<cmd>ToggleTerm direction=horizontal<cr>",
			desc = "ToggleTerm Horizontal",
			mode = "n",
		},
		{
			"<leader>tv",
			"<cmd>ToggleTerm direction=vertical size=" .. size() .. "<cr>",
			desc = "ToggleTerm Vertical",
			mode = "n",
		},
	},
	opts = {
		-- size = size(),
		autochdir = true,
		-- direction = "horizontal" or "vertical" or "float",
		persist_size = false,
		float_opts = {
			-- Hide border
			border = "rounded",
		},
	},
}
