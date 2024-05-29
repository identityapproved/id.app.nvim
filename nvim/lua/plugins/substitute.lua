return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local substitute = require("substitute")

		substitute.setup()

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>sb", substitute.operator, { desc = "Substitute with motion" })
		keymap.set("n", "<leader>sl", substitute.line, { desc = "Substitute line" })
		keymap.set("n", "<leader>se", substitute.eol, { desc = "Substitute to end of line" })
		keymap.set("x", "<leader>sb", substitute.visual, { desc = "Substitute in visual mode" })
	end,
}
