return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		"nvim-telescope/telescope.nvim",
		"KingMichaelPark/age.nvim", -- Add age dependency
	},
	config = function()
		local identity = vim.fn.expand("$HOME/.age/identity.txt")
		local secret = vim.fn.expand("$HOME/.config/secret.age")
		vim.env.OPENAI_API_KEY = require("age").get(secret, identity) -- Get secret
		require("chatgpt").setup({
			-- api_key_cmd = "gpg -d -r " .. whoami .. " " .. home .. "/gptapi.txt.gpg",
		})
	end,
}
