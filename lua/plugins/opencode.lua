-- opencode.nvim: pair with the opencode CLI from inside Neovim.
--
-- Configuration goes through vim.g.opencode_opts, not a setup() call, so this
-- spec deliberately has no `opts` key -- the defaults are what we want.
--
-- Keys live under <leader>a: <leader>o is outline.nvim and <leader>t is
-- terminal/taskwarrior. Upstream's recommended <C-a>, <C-x>, go and goo are
-- skipped because they shadow the built-in increment, decrement and goto-byte.

---@param name string opencode TUI command
local function cmd(name)
  return function()
    require("opencode").command(name)
  end
end

---@param suffix string? motion appended to make the operator line-wise
local function op(suffix)
  return function()
    return require("opencode").operator("@this ") .. (suffix or "")
  end
end

local function ask()
  require("opencode").ask("@this: ")
end

local function pick()
  require("opencode").select()
end

return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*", -- latest stable release
    keys = {
      { "<leader>aa", ask, mode = { "n", "x" }, desc = "Ask opencode" },
      { "<leader>as", pick, mode = { "n", "x" }, desc = "Select opencode prompt/command" },
      { "<leader>ao", op(), mode = { "n", "x" }, expr = true, desc = "Send motion to opencode" },
      { "<leader>aO", op("_"), expr = true, desc = "Send line to opencode" },
      { "<leader>an", cmd("session.new"), desc = "New opencode session" },
      { "<leader>ai", cmd("session.interrupt"), desc = "Interrupt opencode" },
      { "<leader>ac", cmd("session.compact"), desc = "Compact opencode session" },
      { "<S-C-u>", cmd("session.half.page.up"), desc = "Scroll opencode messages up" },
      { "<S-C-d>", cmd("session.half.page.down"), desc = "Scroll opencode messages down" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a", group = "opencode" },
      },
    },
  },
}
