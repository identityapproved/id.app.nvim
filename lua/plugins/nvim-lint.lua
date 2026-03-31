return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      markdown = { "markdownlint_cli2" },
      python = { "ruff" },
    },
    linters = {
      markdownlint_cli2 = {
        cmd = "markdownlint-cli2",
        args = { "--no-globs", ":" .. "$FILENAME" },
        stdin = false,
        stream = "stdout",
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          local filename = vim.api.nvim_buf_get_name(bufnr)
          for line in vim.gsplit(output or "", "\n", { plain = true, trimempty = true }) do
            local file, lnum, col, code, message = line:match("^(.+):(%d+):(%d+)%s+(MD%d+)%s+(.*)$")
            if file and lnum and col then
              table.insert(diagnostics, {
                lnum = tonumber(lnum) - 1,
                col = tonumber(col) - 1,
                end_lnum = tonumber(lnum) - 1,
                end_col = tonumber(col),
                source = "markdownlint-cli2",
                message = (code and (code .. " ") or "") .. (message or ""),
                severity = vim.diagnostic.severity.WARN,
              })
            elseif filename ~= "" and line:find(filename, 1, true) then
              -- ignore non-diagnostic banner/status lines
            end
          end
          return diagnostics
        end,
      },
    },
  },
}
