return {
  "water-sucks/darkrose.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("darkrose").setup({
      styles = {
        bold = true,
        italic = true,
        underline = true,
      },
    })
    vim.cmd.colorscheme("darkrose")

    local function set_transparent()
      local groups = {
        "Normal",
        "NormalFloat",
        "SignColumn",
        "FoldColumn",
        "LineNr",
        "CursorLineNr",
        "EndOfBuffer",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "WinSeparator",
      }
      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end

    set_transparent()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("darkrose_transparent", { clear = true }),
      callback = set_transparent,
    })
  end,
}
