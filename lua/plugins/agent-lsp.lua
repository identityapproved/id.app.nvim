-- Language servers shared with the agent harnesses (OpenCode, Claude Code).
--
-- All three tools resolve LSP binaries from PATH, so a server installed once is
-- reused everywhere. See ~/github/agentsdots/README.md.
--
-- Already covered elsewhere, deliberately not repeated:
--   rust-analyzer        rust.lua
--   ruff, basedpyright   python.lua
--   clangd               c.lua (system LLVM build, not Mason)

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Lua LSP. Was declared by love2d.lua until that plugin was retired;
        -- LazyVim's lang.lua extra configures lua_ls but never installs it.
        "lua-language-server",
        -- Markdown LSP. A standalone release binary, so no npm needed.
        "marksman",
      })
    end,
  },

  -- bash-language-server and typescript-language-server are npm-only, and this
  -- host has no usable npm, so Mason cannot install them. OpenCode fetches both
  -- with its own embedded Bun runtime into ~/.cache/opencode/bin; borrow them
  -- from there rather than depending on a system Node.
  --
  -- That directory is a cache, not a package root: it can be cleared, and it is
  -- empty until OpenCode has opened a matching file at least once. So this is
  -- strictly best-effort -- each server is configured only when its binary is
  -- actually present, and silently skipped otherwise. Nothing here breaks if
  -- OpenCode is never run; the two languages simply get no LSP.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Self-contained: do not rely on the shell having exported this.
      -- Appended so it cannot shadow system binaries, matching options.lua.
      local cache_bin = vim.fn.expand("$HOME/.cache/opencode/bin")
      if not (":" .. vim.env.PATH .. ":"):find(":" .. cache_bin .. ":", 1, true) then
        vim.env.PATH = vim.env.PATH .. ":" .. cache_bin
      end

      opts.servers = opts.servers or {}

      if vim.fn.executable("bash-language-server") == 1 then
        opts.servers.bashls = {}
      end

      -- ts_ls additionally needs `typescript` in the project's own
      -- node_modules; lspconfig resolves that per project.
      if vim.fn.executable("typescript-language-server") == 1 then
        opts.servers.ts_ls = {}
      end
    end,
  },
}
