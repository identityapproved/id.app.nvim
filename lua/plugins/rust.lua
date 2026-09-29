-- Rust support builds on LazyVim's `lang.rust` extra (rustaceanvim + crates.nvim
-- + codelldb debugging + rustfmt formatting). Two things the extra leaves out on
-- this host:
--   1. rust-analyzer itself -- the extra only warns if it's missing, it never
--      installs it. It's a standalone binary in Mason (no node/npm), and
--      options.lua already puts Mason's bin dir on PATH, so rustaceanvim finds it.
--   2. clippy-powered diagnostics -- the extra turns checkOnSave on but leaves the
--      command at plain `cargo check`. Point it at clippy (installed system-wide as
--      cargo-clippy) so lints run on save.
--
-- Toolchain is the system Gentoo rust-bin (rustc/cargo/rustfmt/clippy in /usr/bin).
-- NOTE: std-library completion/goto needs rust-src, which this sysroot lacks. See
-- the setup note printed after this change to enable it.
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "rust-analyzer") then
        table.insert(opts.ensure_installed, "rust-analyzer")
      end
    end,
  },

  -- Merge into the extra's rustaceanvim opts.
  -- Was held at v8.0.5 because v9.0.0 hard-requires Neovim 0.12 and this host was
  -- on stable 0.11.7. It now runs 0.12.5, so the pin moves up to the v9 major
  -- rather than coming off entirely: rustaceanvim gates hard on the Neovim
  -- version, and a major range keeps the next such bump from arriving unannounced
  -- (the repo default is `version = false`, i.e. track HEAD -- see config/lazy.lua).
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    opts = function(_, opts)
      opts.server = opts.server or {}

      -- Advertise blink.cmp's completion capabilities to rust-analyzer. Unlike
      -- lspconfig servers, rustaceanvim starts rust-analyzer itself, so LazyVim
      -- never injects blink's capabilities -- without this, completions don't
      -- show even though diagnostics work. Same pattern as python.lua does for
      -- basedpyright. rustaceanvim deep-merges this over its own default caps,
      -- so the rust-specific experimental capabilities are preserved.
      local ok, blink = pcall(require, "blink.cmp")
      if ok and blink.get_lsp_capabilities then
        opts.server.capabilities = blink.get_lsp_capabilities(opts.server.capabilities)
      end

      -- Use clippy for on-save diagnostics (the extra enables checkOnSave but
      -- leaves the command at plain `cargo check`).
      opts.server.default_settings = vim.tbl_deep_extend("force", opts.server.default_settings or {}, {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
        },
      })
    end,
  },
}
