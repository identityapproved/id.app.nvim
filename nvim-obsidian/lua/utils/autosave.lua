vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "VimLeavePre" }, {
	pattern = "*",
	callback = function(event)
		if event.buftype or event.file == "" then
			return
		end
		vim.api.nvim_buf_call(event.buf, function()
			vim.schedule(function()
				vim.cmd("silent! write")
			end)
		end)
	end,
})
