return {
  "mistweaverco/retro-theme.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    italic_comments = true,
    disable_cache = false,
    hot_reload = false,
  },
  config = function(_, opts)
    require("retro-theme").setup(opts)
    vim.cmd.colorscheme("retro-theme")

    local function set_transparent()
      local groups = {
        "Normal",
        "NormalFloat",
        "SignColumn",
        "FoldColumn",
        "LineNr",
        "CursorLineNr",
        "EndOfBuffer",
      }
      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end

    set_transparent()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("retro_theme_transparent", { clear = true }),
      callback = set_transparent,
    })
  end,
}
