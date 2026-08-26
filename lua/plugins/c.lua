-- C support: system clangd (LLVM) for LSP, system clang-format via conform.
-- No Mason packages: both binaries are installed through the system package
-- manager rather than Mason.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "c") then
        table.insert(opts.ensure_installed, "c")
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("clangd") == 0 then
        vim.schedule(function()
          vim.notify("clangd not found in PATH; install it to enable C LSP", vim.log.levels.WARN)
        end)
        return
      end

      opts.servers = opts.servers or {}
      opts.servers.clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
      },
    },
  },
}
