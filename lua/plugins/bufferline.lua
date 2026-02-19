return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    local ok, nord_bufferline = pcall(require, "nord.plugins.bufferline")
    if ok then
      opts.highlights = nord_bufferline.akinsho()
      return opts
    end

    local nord_ok, nord = pcall(require, "nord")
    if nord_ok and nord.bufferline and nord.bufferline.highlights then
      opts.highlights = nord.bufferline.highlights({ italic = true, bold = true })
    end
    return opts
  end,
}
