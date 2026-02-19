return {
  "ibhagwan/fzf-lua",
  keys = {
    {
      "<leader>it",
      function()
        require("config.templates").insert_template()
      end,
      desc = "Insert template",
    },
    {
      "<leader>ic",
      function()
        require("config.templates").insert_callout()
      end,
      desc = "Insert callout",
    },
  },
}
