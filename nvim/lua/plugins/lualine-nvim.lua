local config = function()
	-- local theme = require("lualine.themes.dracula")

	-- set bg transparency in all modes
	-- theme.normal.c.bg = nil
	-- theme.insert.c.bg = nil
	-- theme.visual.c.bg = nil
	-- theme.replace.c.bg = nil
	-- theme.command.c.bg = nil

	-- Define a function to check that ollama is installed and working
	local function get_condition()
		return package.loaded["ollama"] and require("ollama").status ~= nil
	end

	-- Define a function to check the status and return the corresponding icon
	local function get_status_icon()
		local status = require("ollama").status()

		if status == "IDLE" then
			return "󱙺 " -- nf-md-robot-outline
		elseif status == "WORKING" then
			return "󰚩 " -- nf-md-robot
		end
	end

	require("lualine").setup({
		options = {
			theme = "tokyonight",
			icons_enabled = true,
			globalstatus = true,
			always_divide_middle = true,
		},
		tabline = {
			lualine_b = { "buffers" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { { get_status_icon, get_condition }, { "filename", path = 3 } },
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
