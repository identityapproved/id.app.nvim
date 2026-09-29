-- Build/run/test front end. Nothing here ran builds before, so C, Python, Rust
-- and Zig work meant dropping to a terminal every time. compiler.nvim derives the
-- options per language; overseer is its task backend.
--
-- The picker is ours: compiler.nvim's only frontend hardcodes telescope, which is
-- disabled in favour of fzf-lua. config/compiler.lua reimplements it over fzf-lua
-- and overrides :CompilerOpen -- see that file for why only the picker needed
-- replacing. This is also why fzf-lua is a dependency here.
--
-- Bound under <leader>r, not NormalNvim's <leader>m: marks.nvim owns <leader>m*
-- here (and mistake.nvim <leader>ms*). <leader>r is unused -- LazyVim only takes
-- it in the refactoring extra, which is not enabled.

return {
  {
    "zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "CompilerStop" },
    dependencies = { "stevearc/overseer.nvim", "ibhagwan/fzf-lua" },
    config = function(_, opts)
      -- setup() registers the commands and the overseer "default_extended"
      -- component alias every language backend builds its tasks with, so it has
      -- to run. Our CompilerOpen replaces its telescope-bound one afterwards.
      require("compiler").setup(opts)
      require("config.compiler").setup()
    end,
    opts = {},
    keys = {
      { "<leader>r", "", desc = "+run/compile" },
      { "<leader>rr", "<cmd>CompilerOpen<cr>", desc = "Compiler: open" },
      { "<leader>rR", "<cmd>CompilerRedo<cr>", desc = "Compiler: redo last" },
      { "<leader>rt", "<cmd>CompilerToggleResults<cr>", desc = "Compiler: toggle results" },
      { "<leader>rs", "<cmd>CompilerStop<cr>", desc = "Compiler: stop" },
    },
  },

  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}
