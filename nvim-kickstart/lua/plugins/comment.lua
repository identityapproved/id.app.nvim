return {
	"numToStr/Comment.nvim",
	opts = {
    ---Add a space b/w comment and the line
    padding = true,
        toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
		toggler = {
			line = "gtc",
			block = "gtb",
		},
		opleader = {
			line = "goc",
			block = "gob",
		},
	},
	lazy = false,
}
