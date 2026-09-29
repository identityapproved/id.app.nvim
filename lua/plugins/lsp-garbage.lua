-- LSP garbage collector: stop language servers that have gone idle and wake them
-- on return. This laptop cannot afford clangd (--background-index),
-- basedpyright, rust-analyzer, zls, taplo and wgsl-analyzer all resident for a
-- whole session, and nothing else here manages LSP lifetime.
--
-- Ported from NormalNvim (lua/plugins/3-dev-core.lua). Version-pinned because it
-- hooks LSP lifecycle internals.

return {
  {
    "zeioth/garbage-day.nvim",
    version = "^1.4",
    -- LazyVim has no `User BaseFile` equivalent, and there is nothing to collect
    -- before a client has attached anyway.
    event = "LspAttach",
    opts = {
      aggressive_mode = false,
      -- Cheap or restart-hostile clients. The heavy ones (basedpyright, clangd,
      -- rust-analyzer, zls, taplo, wgsl_analyzer, bashls, ts_ls) are the whole
      -- point of this plugin and are deliberately absent.
      --   marksman, lua_ls  small footprint, in constant use (excluded upstream too)
      --   zk                backs the whole note workflow via zk-nvim auto_attach
      --   ruff              tiny, and its hoverProvider patch re-runs on every
      --                     LspAttach (plugins/python.lua), so a restart is pure churn
      excluded_lsp_clients = { "marksman", "zk", "lua_ls", "ruff" },
      grace_period = (60 * 15),
      wakeup_delay = 3000,
      notifications = false,
      retries = 3,
      timeout = 1000,
    },
  },
}
