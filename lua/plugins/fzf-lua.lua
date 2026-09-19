return {
  -- remove Telescope in favor of fzf-lua
  { "nvim-telescope/telescope.nvim", enabled = false },
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local fzf = require("fzf-lua")

      -- Markdown previews through glow with the Lain glamour style, as in the
      -- tmux picker (lainland scripts/tmux-pick). fzf-lua runs extension
      -- commands in a pty sized to the preview window, which is what glow
      -- needs to style at all; tput reads that width for the wrap. Without
      -- glow, markdown keeps the normal treesitter preview.
      local extensions = {}
      if vim.fn.executable("glow") == 1 then
        local glow = {
          "sh",
          "-c",
          'COLORTERM=truecolor glow -s "$HOME/.config/glow/themes/lain.json" -w "$(tput cols)" "$1"',
          "sh",
          "{file}",
        }
        extensions = { md = glow, markdown = glow }
      end

      fzf.setup({
        -- Colors come from the colorscheme. `true` maps every fzf color to an
        -- FzfLuaFzf* highlight group, which lain.nvim styles (lua/lain/groups/
        -- plugins.lua), so the picker follows the theme instead of carrying
        -- hex values of its own. Hardcoded `--color` flags here, or appended to
        -- FZF_DEFAULT_OPTS, would override those groups.
        fzf_colors = true,
        winopts = {
          width = 0.85,
          height = 0.85,
          -- fzf-lua defaults both of these to "rounded" and never falls back
          -- to 'winborder'. Not to be confused with fzf_opts["--border"]
          -- below, which is a flag to the fzf binary's own TUI.
          border = "single",
          preview = { border = "single" },
        },
        previewers = {
          builtin = { extensions = extensions },
        },
        -- Scrolling, the same keys as every other fzf here (lainland
        -- fzf/lain.fzfrc): ctrl-f / ctrl-b half a page, alt-j / alt-k a line,
        -- shift-down / shift-up a page, f3 wrap, f4 hide. `builtin` is nvim's
        -- own previewer, `fzf` the fzf-native ones (bat, git). ctrl-f / ctrl-b
        -- replace fzf-lua's list half-page defaults; ctrl-u stays "clear query".
        -- The leading `true` keeps fzf-lua's defaults; without it a custom
        -- table replaces them and shift/f3/f4/ctrl-u stop working.
        keymap = {
          builtin = {
            true,
            ["<C-f>"] = "preview-half-page-down",
            ["<C-b>"] = "preview-half-page-up",
            ["<M-j>"] = "preview-down",
            ["<M-k>"] = "preview-up",
          },
          fzf = {
            true,
            ["ctrl-f"] = "preview-half-page-down",
            ["ctrl-b"] = "preview-half-page-up",
            ["alt-j"] = "preview-down",
            ["alt-k"] = "preview-up",
          },
        },
        files = {
          -- include hidden and ignored files so .txt never gets filtered out
          rg_opts = "--hidden --follow --no-ignore --color=never --files",
        },
        fzf_opts = {
          ["--highlight-line"] = "",
          ["--info"] = "inline-right",
          ["--ansi"] = "",
          ["--layout"] = "reverse",
          ["--border"] = "none",
        },
      })

      local map = vim.keymap.set
      map("n", "<leader>ff", fzf.files, { desc = "Find files (fzf)" })
      map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep (fzf)" })
      map("n", "<leader>fb", fzf.buffers, { desc = "Buffers (fzf)" })
      map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags (fzf)" })
      map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files (fzf)" })
      map("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor (fzf)" })
      map("n", "<leader>fs", fzf.live_grep, { desc = "Search in project (fzf)" })
      map("n", "<leader>/", fzf.live_grep, { desc = "Search in project (fzf)" })
    end,
  },
}
