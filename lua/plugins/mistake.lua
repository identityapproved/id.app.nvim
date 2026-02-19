return {
  "ck-zhang/mistake.nvim",
  config = function()
    local plugin = require("mistake")
    vim.defer_fn(function()
      plugin.setup()
    end, 500)

    vim.keymap.set("n", "<leader>msa", plugin.add_entry, { desc = "[M]istake [A]dd entry" })
    vim.keymap.set("n", "<leader>mse", plugin.edit_entries, { desc = "[M]istake [E]dit entries" })
    vim.keymap.set("n", "<leader>msc", plugin.add_entry_under_cursor, { desc = "[M]istake add [C]urrent word" })
  end,
}
