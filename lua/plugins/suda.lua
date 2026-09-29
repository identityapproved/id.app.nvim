-- Write root-owned files (/etc on the Void and Gentoo hosts) without reopening
-- nvim under sudo.
return {
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
    keys = {
      { "<leader>W", "<cmd>SudaWrite<cr>", desc = "Write as root" },
    },
  },
}
