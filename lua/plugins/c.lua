-- C support: Mason's clangd for LSP, system clang-format via conform.
--
-- clangd comes from Mason rather than the system LLVM so this config is
-- self-sufficient on any machine -- the Void laptop has no clangd packaged at
-- all. It is invoked by absolute path, not by name, because the system LLVM
-- build precedes Mason on PATH and would otherwise win.
--
-- Note this is deliberately narrower than the Python setup: OpenCode and Claude
-- Code still resolve plain `clangd` from PATH, so on a host with a system LLVM
-- they use that one while Neovim uses Mason's. On a host without one, all three
-- fall through to Mason's copy.

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "clangd") then
        table.insert(opts.ensure_installed, "clangd")
      end
    end,
  },
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
      local clangd = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/clangd")
      if vim.fn.executable(clangd) == 0 then
        -- Mason has not installed it yet; fall back to whatever is on PATH.
        clangd = "clangd"
      end
      if vim.fn.executable(clangd) == 0 then
        return
      end

      opts.servers = opts.servers or {}
      opts.servers.clangd = {
        cmd = {
          clangd,
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
