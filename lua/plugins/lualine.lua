return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options = opts.options or {}
    opts.options.theme = "retro-theme"
    return opts
  end,
}
