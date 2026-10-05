-- codecompanion.nvim: chat and inline edits against the local ollama server.
--
-- Picked over the agentic alternatives on purpose. A 3B model cannot hold up a
-- tool-calling loop, but it can hold a conversation, and a plain chat buffer
-- degrades gracefully where an agent just fails. It is also pure Lua with a
-- built-in ollama adapter, so unlike avante.nvim there is no Rust toolchain to
-- build -- and both its dependencies were already installed here.
--
-- Slow is expected and accepted: this is the no-internet fallback.
--
-- Endpoint and model come from config.localllm, never from this file.

local llm = require("config.localllm")

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    keys = {
      { "<leader>acc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "x" }, desc = "Toggle chat" },
      { "<leader>aca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "x" }, desc = "Actions" },
      { "<leader>aci", ":CodeCompanion ", mode = { "n", "x" }, desc = "Inline assistant" },
      { "<leader>acp", "<cmd>CodeCompanionChat Add<cr>", mode = "x", desc = "Add selection to chat" },
    },
    opts = {
      adapters = {
        http = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              -- Load-bearing. The ollama adapter otherwise falls back to
              -- os.getenv("OLLAMA_HOST"), which is scheme-less ("127.0.0.1:11434")
              -- because that is the form ollama's own CLI wants -- not a valid
              -- URL. config.localllm always carries the scheme.
              env = { url = llm.url },
              schema = {
                model = { default = llm.chat_model },
                -- Matches OLLAMA_CONTEXT_LENGTH. Larger windows cost prompt-eval
                -- time on a CPU-only host, which is the slowest part here.
                num_ctx = { default = 4096 },
              },
            })
          end,
        },
      },
      -- "interactions" is the current key; "strategies" still works but is
      -- migrated onto interactions at setup, and passing both makes one clobber
      -- the other. Use one.
      interactions = {
        chat = {
          adapter = "ollama",
          opts = {
            -- The stock prompt is derived from GitHub Copilot Chat's and runs
            -- ~1700 tokens. Measured on voidbox: prompt eval alone took tens of
            -- minutes at 230% CPU before a single reply token appeared, which
            -- makes chat unusable rather than merely slow. A 3B model does not
            -- follow a prompt that long anyway.
            system_prompt = function()
              return table.concat({
                "You are a coding assistant inside Neovim.",
                "Answer with code first and minimal prose.",
                "Do not restate the question or explain unless asked.",
              }, " ")
            end,
          },
        },
        inline = { adapter = "ollama" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>ac", group = "codecompanion" },
      },
    },
  },
}
