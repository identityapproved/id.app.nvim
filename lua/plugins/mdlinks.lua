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
  },
}
