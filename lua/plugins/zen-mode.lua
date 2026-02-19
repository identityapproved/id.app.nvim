return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
  opts = {
    window = {
      backdrop = 1, -- no dimming
      width = 120,
      height = 1,
      options = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
        foldcolumn = "0",
        list = false,
      },
    },
    plugins = {
      options = {
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      lualine = { enabled = false },
      tmux = { enabled = true },
    },
  },
}
