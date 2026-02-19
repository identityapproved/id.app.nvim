return {
  -- remove Telescope in favor of fzf-lua
  { "nvim-telescope/telescope.nvim", enabled = false },
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local fzf = require("fzf-lua")
      local theme_opts = {
        "--highlight-line",
        "--info=inline-right",
        "--ansi",
        "--layout=reverse",
        "--border=none",
        "--color=bg+:#3B4252",
        "--color=bg:#2E3440",
        "--color=border:#81A1C1",
        "--color=fg:#D8DEE9",
        "--color=gutter:#2E3440",
        "--color=header:#EBCB8B",
        "--color=hl+:#88C0D0",
        "--color=hl:#88C0D0",
        "--color=info:#4C566A",
        "--color=marker:#BF616A",
        "--color=pointer:#BF616A",
        "--color=prompt:#88C0D0",
        "--color=query:#D8DEE9:regular",
        "--color=scrollbar:#81A1C1",
        "--color=separator:#EBCB8B",
        "--color=spinner:#B48EAD",
      }

      local env_opts = table.concat(theme_opts, " ")
      vim.env.FZF_DEFAULT_OPTS = vim.trim((vim.env.FZF_DEFAULT_OPTS or "") .. " " .. env_opts)

      fzf.setup({
        winopts = {
          width = 0.85,
          height = 0.85,
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
          ["--color"] = {
            "bg+:#3B4252",
            "bg:#2E3440",
            "border:#81A1C1",
            "fg:#D8DEE9",
            "gutter:#2E3440",
            "header:#EBCB8B",
            "hl+:#88C0D0",
            "hl:#88C0D0",
            "info:#4C566A",
            "marker:#BF616A",
            "pointer:#BF616A",
            "prompt:#88C0D0",
            "query:#D8DEE9:regular",
            "scrollbar:#81A1C1",
            "separator:#EBCB8B",
            "spinner:#B48EAD",
          },
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
