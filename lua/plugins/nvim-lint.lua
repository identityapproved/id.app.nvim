-- Markdown linting was dropped: markdownlint-cli2 is an npm package and this
-- host has no node/npm. Formatting is handled by mdformat (see markdown.lua),
-- which auto-fixes most of what markdownlint would flag. If you later want a
-- dedicated non-npm markdown/prose linter, `vale` (a single Go binary, in the
-- Mason registry) wires into nvim-lint via linters_by_ft.markdown = { "vale" }
-- and a .vale.ini at the project root. Original config: nvim-lint.lua.bak.
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      python = { "ruff" },
    },
  },
}
