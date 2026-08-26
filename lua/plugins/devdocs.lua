-- Offline documentation browser (DevDocs.io sets). The initial `:DevDocs install`
-- fetch needs network; after that the docs live under stdpath("data") and are
-- browsed entirely offline as markdown, so glow.nvim handles the rendering.
-- `:DevDocs install` lists the exact doc names (Python needs the version suffix,
-- e.g. python~3.13).
return {
  "maskudo/devdocs.nvim",
  lazy = false,
  dependencies = { "folke/snacks.nvim" },
  cmd = { "DevDocs" },
  opts = {
    ensure_installed = { "python~3.13", "html", "http" },
  },
  keys = {
    { "<leader>do", "<cmd>DevDocs get<cr>", desc = "Open devdocs" },
    { "<leader>di", "<cmd>DevDocs install<cr>", desc = "Install devdocs" },
    { "<leader>df", "<cmd>DevDocs fetch<cr>", desc = "Fetch devdocs index" },
    { "<leader>dd", "<cmd>DevDocs delete<cr>", desc = "Delete devdocs" },
  },
}
