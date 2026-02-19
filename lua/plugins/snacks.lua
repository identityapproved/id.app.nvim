return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false, preset = { keys = {} } },
    bigfile = { enabled = true },
    explorer = {
      enabled = true,
      hidden = true,
      ignored = true,
      follow = true,
    },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          -- use sidebar preset but place it on the right
          layout = { preset = "right" },
          hidden = true,
          ignored = true,
          follow = true,
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
