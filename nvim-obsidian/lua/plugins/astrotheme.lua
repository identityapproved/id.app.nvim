return {
	"maxmx03/fluoromachine.nvim",
	lazy = false,
	priority = 999,
	config = function()
		local fm = require("fluoromachine")

		fm.setup({
			glow = true,
			transparent = "full",
			theme = "fluoromachine",
		})

		vim.cmd.colorscheme("fluoromachine")
	end,
}
