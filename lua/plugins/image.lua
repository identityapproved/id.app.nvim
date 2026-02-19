return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    ft = { "markdown" },
    enabled = function()
      return vim.env.TMUX == nil
    end,
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating = true,
        },
      },
      kitty_method = "normal",
    },
  },
}
