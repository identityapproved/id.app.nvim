return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "markdownlint-cli2") then
        table.insert(opts.ensure_installed, "markdownlint-cli2")
      end
      if not vim.tbl_contains(opts.ensure_installed, "prettier") then
        table.insert(opts.ensure_installed, "prettier")
      end
    end,
  },
}
