local config = function()
	-- local theme = require("lualine.themes.dracula")

	-- set bg transparency in all modes
	-- theme.normal.c.bg = nil
	-- theme.insert.c.bg = nil
	-- theme.visual.c.bg = nil
	-- theme.replace.c.bg = nil
	-- theme.command.c.bg = nil

	require("lualine").setup({
		options = {
			theme = "tokyonight",
			globalstatus = true,
		},
		tabline = {
			lualine_b = { "buffers" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = config,
}
