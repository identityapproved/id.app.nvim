-- local checkout; swap dir for "identityapproved/lain.nvim" once published
return {
  dir = "~/github/lain.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("lain")
  end,
}
