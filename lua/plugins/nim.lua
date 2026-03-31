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
      local server_name
      local server_cmd

      if vim.fn.executable("nimlangserver") == 1 then
        server_name = "nim_langserver"
        server_cmd = "nimlangserver"
      elseif vim.fn.executable("nimlsp") == 1 then
        server_name = "nimls"
        server_cmd = "nimlsp"
      end

      if not server_name then
        vim.schedule(function()
          vim.notify(
            "No Nim LSP found in PATH; install `nimlangserver` or `nimlsp` to enable Nim LSP",
            vim.log.levels.WARN
          )
        end)
        return
      end

      opts.servers = opts.servers or {}
      opts.servers[server_name] = {
        cmd = { server_cmd },
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
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nim = { "nimpretty" },
      },
    },
  },
}
