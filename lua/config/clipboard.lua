local M = {}

function M.setup()
  if vim.fn.executable("copyq") ~= 1 then
    return
  end

  vim.opt.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "copyq",
    copy = {
      ["+"] = function(lines, _)
        local text = table.concat(lines, "\n")
        vim.fn.system({ "copyq", "add", "-" }, text)
        vim.fn.system({ "copyq", "select", "0" })
      end,
      ["*"] = function(lines, _)
        local text = table.concat(lines, "\n")
        vim.fn.system({ "copyq", "add", "-" }, text)
        vim.fn.system({ "copyq", "select", "0" })
      end,
    },
    paste = {
      ["+"] = function()
        local data = vim.fn.system({ "copyq", "read", "0" })
        return vim.split(data, "\n", { plain = true })
      end,
      ["*"] = function()
        local data = vim.fn.system({ "copyq", "read", "0" })
        return vim.split(data, "\n", { plain = true })
      end,
    },
    cache_enabled = 0,
  }
end

return M
