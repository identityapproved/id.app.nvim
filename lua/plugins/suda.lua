-- Write root-owned files (/etc on the Void and Gentoo hosts) without reopening
-- nvim under sudo.
return {
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
    init = function()
      -- These hosts have no sudo; doas cannot take a password on stdin, so the
      -- prompt is skipped and doas.conf must grant persist or nopass.
      vim.g["suda#executable"] = "doas"
      vim.g["suda#noninteractive"] = 1
    end,
    keys = {
      { "<leader>W", "<cmd>SudaWrite<cr>", desc = "Write as root" },
    },
  },
}
