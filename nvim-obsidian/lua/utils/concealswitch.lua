-- Toggle conceallevel
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*",
	callback = function()
		vim.keymap.set("n", "<leader>cl", function()
			if vim.opt.conceallevel:get() == 2 then
				vim.opt.conceallevel = 0
			else
				vim.opt.conceallevel = 2
			end
		end, { desc = "Toggle Conceal Level" })
	end,
})
