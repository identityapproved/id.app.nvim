return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>fl",
      function()
        require("config.mdlinks").find_links()
      end,
      desc = "Find links in buffer",
    },
    {
      "gp",
      function()
        require("config.mdlinks").peek()
      end,
      ft = "markdown",
      desc = "Peek link in float",
    },
  },
}
