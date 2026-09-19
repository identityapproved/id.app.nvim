return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      signature = {
        enabled = false,
        auto_open = { enabled = false },
      },
    },
    -- These views hardcode border.style = "rounded" and never consult
    -- 'winborder'. cmdline_popup is rounded twice over: once in noice's
    -- config/views.lua and again in the command_palette preset LazyVim
    -- enables. User opts merge last, so this wins over both.
    views = {
      popup = { border = { style = "single" } },
      popupmenu = { border = { style = "single" } },
      cmdline_popup = { border = { style = "single" } },
      cmdline_input = { border = { style = "single" } },
      confirm = { border = { style = "single" } },
    },
  },
}
