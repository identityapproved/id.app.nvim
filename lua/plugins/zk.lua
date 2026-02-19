return {
  "zk-org/zk-nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  config = function()
    require("zk").setup({
      picker = "fzf_lua",
      lsp = {
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
        },
        auto_attach = {
          enabled = true,
        },
      },
    })

    vim.api.nvim_create_user_command("ZkNewPrompt", function()
      local title = vim.fn.input("Title: ")
      if title == "" then
        title = os.date("%Y-%m-%d")
      end
      require("zk").new({ title = title })
    end, { desc = "Zk new note (prompt/date)" })
  end,
}
