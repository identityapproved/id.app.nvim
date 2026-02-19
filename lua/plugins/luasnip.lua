return {
  "L3MON4D3/LuaSnip",
  opts = function(_, opts)
    opts.snippet_paths = opts.snippet_paths or {}
    table.insert(opts.snippet_paths, vim.fn.stdpath("config") .. "/snippets")
  end,
  config = function(_, opts)
    require("luasnip").config.setup(opts)
    local paths = opts.snippet_paths or {}
    require("luasnip.loaders.from_vscode").lazy_load({ paths = paths })
  end,
}
