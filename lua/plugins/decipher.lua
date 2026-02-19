return {
  "MisanthropicBit/decipher.nvim",
  event = "VeryLazy",
  opts = {
    float = {
      padding = 0,
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },
      mappings = {
        close = "q",
        apply = "<CR>",
        jsonpp = "J",
        help = "?",
      },
      title = true,
      title_pos = "left",
      autoclose = true,
      enter = true,
      options = {},
    },
  },
  keys = {
    {
      "<leader>dc",
      function()
        require("decipher").decode_selection_prompt({ preview = true })
      end,
      mode = "v",
      desc = "Decipher decode (prompt)",
    },
    {
      "<leader>dc",
      function()
        require("decipher").decode_motion_prompt({ preview = true })
      end,
      mode = "n",
      desc = "Decipher decode (prompt)",
    },
  },
}
