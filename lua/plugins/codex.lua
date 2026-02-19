return {
  "pittcat/codex.nvim",
  cmd = {
    "CodexOpen",
    "CodexToggle",
    "CodexSendPath",
    "CodexSendSelection",
    "CodexSendReference",
    "CodexSendContent",
  },
  keys = {
    {
      "<leader>co",
      function()
        require("codex").open()
      end,
      desc = "Codex: Open TUI",
    },
    {
      "<leader>ct",
      function()
        require("codex").toggle()
      end,
      desc = "Codex: Toggle terminal",
    },
    {
      "<leader>cp",
      "<cmd>CodexSendPath<CR>",
      desc = "Codex: Send file path",
    },
    {
      "<leader>cS",
      function()
        vim.cmd("'<,'>CodexSendSelection")
      end,
      mode = "v",
      desc = "Codex: Send selection",
    },
    {
      "<leader>cr",
      function()
        vim.cmd("'<,'>CodexSendReference")
      end,
      mode = "v",
      desc = "Codex: Send reference",
    },
    {
      "<leader>cC",
      function()
        vim.cmd("'<,'>CodexSendContent")
      end,
      mode = "v",
      desc = "Codex: Send content",
    },
  },
  opts = {
    terminal = {
      direction = "vertical",
      position = "right",
      size = 0.4,
      reuse = false,
    },
  },
  config = function(_, opts)
    require("config.codex").setup(opts)
  end,
}
