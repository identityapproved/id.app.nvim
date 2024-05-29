local config = function()
	require("nvim-treesitter.configs").setup({
		build = ":TSUpdate",
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		ensure_installed = {
			"asm",
			"nasm",
			"gdscript",
			"gdshader",
			"markdown",
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"toml",
			"xml",
			"html",
			"htmldjango",
			"css",
			"markdown",
			"bash",
			"regex",
			"awk",
			"diff",
			"http",
			"ssh_config",
			"lua",
			"dockerfile",
			"solidity",
			"git_config",
			"git_rebase",
			"gitignore",
			"gitattributes",
			"gitcommit",
			"python",
			"csv",
			"pascal",
			"passwd",
			"perl",
			"php",
			"c",
			"cpp",
			"c_sharp",
			"cmake",
			"arduino",
			"cpp",
			"sql",
			"graphql",
			"go",
			"ruby",
			"rust",
			"zathurarc",
			"vim",
			"vimdoc",
			"query",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-s>",
				node_incremental = "<C-s>",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-treesitter/nvim-treesitter-context" },
	config = config,
}