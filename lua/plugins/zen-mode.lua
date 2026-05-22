return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>zm", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
  opts = {
    on_open = function(win)
      vim.w[win].zen_mode_prev_scrolloff = vim.wo[win].scrolloff
      vim.wo[win].scrolloff = 999
    end,
    on_close = function(win)
      local prev = vim.w[win].zen_mode_prev_scrolloff
      vim.wo[win].scrolloff = prev or vim.o.scrolloff
      vim.w[win].zen_mode_prev_scrolloff = nil
    end,
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
