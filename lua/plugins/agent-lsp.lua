-- Language servers shared with the agent harnesses (OpenCode, Claude Code).
--
-- Mason is the primary provisioner: anything it can install is declared here,
-- and all three tools resolve the result from PATH (~/.zprofile appends
-- ~/.local/share/nvim/mason/bin). OpenCode is left to supply only what Mason
-- genuinely cannot -- see the npm note below. Claude Code never downloads
-- anything, so Mason is its only source.
--
-- Already covered elsewhere, deliberately not repeated:
--   rust-analyzer        rust.lua
--   ruff, basedpyright   python.lua
--   clangd, clang-format c.lua
--
-- See ~/github/agentsdots/README.md for the full division of labour.

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
        -- Zig LSP. Prebuilt release, so it installs without a Zig toolchain --
        -- which you still need to actually build anything.
        "zls",
        -- TOML LSP. OpenCode has no built-in id for TOML, so opencode.jsonc
        -- declares it as a custom server pointing at this same binary.
        "taplo",
        -- WGSL LSP, for the shader sources under ~/github.
        "wgsl-analyzer",
        -- Not an LSP: shell diagnostics via nvim-lint. bash-language-server is
        -- npm-only and unavailable here, and shellcheck is a static Haskell
        -- binary, so this is the node-free route to shell linting.
        "shellcheck",
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- LazyVim's defaults already cover toml, markdown, lua, python and the
      -- rest; these two are the ones its list omits.
      for _, lang in ipairs({ "zig", "wgsl" }) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
    end,
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.sh = { "shellcheck" }
      opts.linters_by_ft.bash = { "shellcheck" }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- OpenCode writes to two directories and the npm one is easy to miss.
      -- Servers published as release binaries land in Global.Path.bin =
      -- ~/.cache/opencode/bin; servers published on npm are `bun add`-ed into
      -- the *config* directory and surface at
      -- ~/.config/opencode/node_modules/.bin. Both are searched here.
      --
      -- Self-contained: do not rely on the shell having exported these.
      -- Appended so they cannot shadow Mason's copies or system binaries.
      for _, dir in ipairs({
        vim.fn.expand("$HOME/.cache/opencode/bin"),
        vim.fn.expand("$HOME/.config/opencode/node_modules/.bin"),
      }) do
        if not (":" .. vim.env.PATH .. ":"):find(":" .. dir .. ":", 1, true) then
          vim.env.PATH = vim.env.PATH .. ":" .. dir
        end
      end

      opts.servers = opts.servers or {}

      -- Mason-provided, so declared unconditionally: ensure_installed above
      -- guarantees the binary. No LazyVim extra covers Zig, TOML or WGSL, so
      -- nothing else configures these.
      opts.servers.zls = {}
      opts.servers.taplo = {}
      opts.servers.wgsl_analyzer = {}

      -- Go is deliberately absent here: lazyvim.plugins.extras.lang.go owns it
      -- and lua/config/lazy.lua gates that import on a Go toolchain existing.

      -- npm-only, so Mason cannot install them and OpenCode is the supplier.
      -- Those directories are caches, not package roots we own: they can be
      -- cleared, and they stay empty until OpenCode has actually opened a
      -- matching file. Strictly best-effort -- configured only when present,
      -- silently skipped otherwise. Nothing here breaks if OpenCode is never
      -- run; the two languages simply get no LSP.
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
