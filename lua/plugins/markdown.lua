-- mdformat is a pure-Python markdown formatter (no node/npm needed). The bare
-- package, however, treats YAML frontmatter as a setext heading and destroys
-- it, so we run it from a dedicated venv that also has mdformat-frontmatter and
-- mdformat-gfm installed. The venv is pinned by absolute path (like the
-- basedpyright cmd in python.lua) so a Mason update can't silently swap in the
-- plugin-less binary and start mangling note frontmatter again.
--
-- One-time setup (network step, run manually):
--   python3 -m venv ~/.local/share/nvim/tools/mdformat
--   ~/.local/share/nvim/tools/mdformat/bin/python -m pip install \
--     mdformat mdformat-frontmatter mdformat-gfm
local mdformat_bin = vim.fn.expand("$HOME/.local/share/nvim/tools/mdformat/bin/mdformat")

return {
  -- Wire mdformat (from the dedicated venv) as the markdown formatter. LazyVim
  -- runs it on save via the global autoformat. The prettier extra used to
  -- provide this. If the venv isn't built yet, conform finds no command and
  -- simply skips formatting -- it never falls back to a frontmatter-eating one.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        markdown = { "mdformat", "hr_dashes" },
        ["markdown.mdx"] = { "mdformat", "hr_dashes" },
      },
      formatters = {
        mdformat = { command = mdformat_bin },
        -- mdformat hardcodes thematic breaks as a 70-underscore line (no CLI
        -- option to change it). Rewrite exactly that line back to `---` so
        -- horizontal rules keep their conventional form.
        hr_dashes = {
          format = function(_, _, lines, callback)
            local hr = string.rep("_", 70)
            local out = {}
            for i, line in ipairs(lines) do
              out[i] = (line == hr) and "---" or line
            end
            callback(nil, out)
          end,
        },
      },
    },
  },

  -- Markdown preview rendered in a floating terminal by `glow` (installed at
  -- /usr/bin/glow; glow_path is auto-detected from $PATH). Used both for plain
  -- markdown buffers and for the markdown that devdocs.nvim opens.
  --
  -- This is the read path for wide tables: a markdown table row is one buffer
  -- line and nothing in the editor can fold it, while glow reflows every cell
  -- to the width it is handed. Same Lain glamour style as the fzf-lua previewer
  -- and lainland's tmux-pick, so all three previews look alike.
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    ft = "markdown",
    opts = {
      border = "single",
      style = vim.fn.expand("$HOME/.config/glow/themes/lain.json"),
      width_ratio = 0.9,
      height_ratio = 0.9,
      -- The ratio-derived width is then clamped to `width` (the plugin defaults
      -- it to 100 columns, which is what was cutting the tables short), so this
      -- has to sit above any real terminal width rather than be unset.
      width = 500,
    },
    keys = {
      -- Not <leader>c: that is LazyVim's code group. <leader>m would be the
      -- markdown key but marks.nvim owns it, so the preview takes a
      -- markdown-local <leader>p.
      { "<leader>p", "<cmd>Glow<cr>", desc = "Markdown Preview (glow)", ft = "markdown" },
    },
  },
}
