return {
  {
    "3rd/image.nvim",
    -- skip the rockspec build; the magick rock is only for magick_rock, we use magick_cli
    build = false,
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
