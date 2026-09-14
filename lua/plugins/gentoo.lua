return {
  { "gentoo/gentoo-syntax", ft = { "ebuild", "eclass" }, lazy = false },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.treesitter.language.register("bash", { "ebuild", "eclass" })
    end,
  },
}
