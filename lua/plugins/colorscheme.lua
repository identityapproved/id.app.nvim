-- local checkout; swap dir for "identityapproved/lain.nvim" once published
return {
  {
    dir = "~/github/lain.nvim",
    lazy = false,
    priority = 1000,
    -- lain.load() falls back to its own defaults, so no setup() call is needed.
  },
  -- LazyVim applies a colorscheme itself during its setup, which runs after
  -- plugin config functions. Setting it here is the only way to win; a
  -- `vim.cmd.colorscheme` in a config function gets overwritten by tokyonight.
  { "LazyVim/LazyVim", opts = { colorscheme = "lain" } },
}
