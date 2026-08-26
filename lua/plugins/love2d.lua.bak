return {
  {
    "S1M0N38/love2d.nvim",
    event = "VeryLazy",
    version = "3.*",
    opts = {},
    keys = {
      { "<leader>vv", "<cmd>Love run<cr>", ft = "lua", desc = "Run LÖVE" },
      { "<leader>vw", "<cmd>Love watch<cr>", ft = "lua", desc = "Watch LÖVE" },
      { "<leader>vs", "<cmd>Love stop<cr>", ft = "lua", desc = "Stop LÖVE" },
      { "<leader>vo", "<cmd>Love output<cr>", ft = "lua", desc = "LÖVE output" },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "lua-language-server") then
        table.insert(opts.ensure_installed, "lua-language-server")
      end
    end,
  },
}
