return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "nim") then
        table.insert(opts.ensure_installed, "nim")
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local has_server = vim.fn.executable("nimlangserver") == 1
      if not has_server then
        vim.schedule(function()
          vim.notify("nimlangserver not found in PATH; install nim-lang/langserver to enable Nim LSP", vim.log.levels.WARN)
        end)
        return
      end

      opts.servers = opts.servers or {}
      opts.servers.nim_langserver = {
        settings = {
          nim = {
            inlayHints = {
              typeHints = true,
              parameterHints = true,
              exceptionHints = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      }
    end,
  },
}
