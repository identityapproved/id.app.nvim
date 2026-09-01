-- Installed from GitHub. `dev` in config/lazy.lua points lazy.nvim at the local
-- checkout under ~/github when one exists, and falls back to cloning the repo
-- on machines that do not have it.
return {
  {
    "identityapproved/lain.nvim",
    lazy = false,
    priority = 1000,
    -- lain.load() falls back to its own defaults, so no setup() call is needed.
  },
  -- LazyVim applies a colorscheme itself during its setup, which runs after
  -- plugin config functions. Setting it here is the only way to win; a
  -- `vim.cmd.colorscheme` in a config function gets overwritten by tokyonight.
  { "LazyVim/LazyVim", opts = { colorscheme = "lain" } },
}
