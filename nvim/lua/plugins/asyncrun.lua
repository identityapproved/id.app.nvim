return {
	"skywind3000/asyncrun.vim", -- Asyncrun plugin
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("asyncrun_toggleterm").setup({
			mapping = "<leader>tt",
			start_in_insert = false,
		})
	end,
	-- config = function()
	-- 	require("asyncrun").setup({
	-- 		-- Configuration options for asyncrun.vim go here
	-- 	})
	-- end,
}
