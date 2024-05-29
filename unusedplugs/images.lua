return {
	"vhyrro/luarocks.nvim",
	event = "VeryLazy",
	priority = 1001, -- this plugin needs to run before anything else
	opts = {
		rocks = { "magick" },
	},
}, {
	"3rd/image.nvim",
	event = "VeryLazy",
	dependencies = { "luarocks.nvim" },
	config = function()
		-- ...
	end,
}
