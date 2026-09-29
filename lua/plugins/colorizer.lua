-- Inline color-code highlighting. Scoped to the filetypes where color literals
-- actually occur rather than "*": attaching a hex scanner to every buffer is a
-- cost this laptop pays on every file for nothing.
return {
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "html",
        "lua", -- colorscheme work under ~/github/lain.nvim
        "toml",
        "json",
        "jsonc",
        "yaml",
        "conf",
        "dosini",
        "kitty",
        "xdefaults",
      })

      -- setup() only registers the filetypes; attaching is per buffer, so the
      -- size guard belongs here. Runs after colorizer's own FileType autocmd.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom_colorizer_bigfile", { clear = true }),
        callback = function(args)
          if require("config.bigfile").is_big_file(args.buf) then
            pcall(require("colorizer").detach_from_buffer, args.buf)
          end
        end,
      })
    end,
  },
}
