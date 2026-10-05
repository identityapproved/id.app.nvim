-- minuet-ai.nvim: fill-in-the-middle completion from the local ollama server.
--
-- Manual only, by design. This laptop is a Bay Trail Pentium with no AVX, so a
-- completion costs seconds, not milliseconds -- background requests would make
-- typing unusable. Nothing here fires unless a key is pressed:
--   * minuet is registered as a blink provider but kept OUT of default_sources
--   * prefetch_on_insert is disabled so blink cannot warm it
--   * virtualtext.auto_trigger_ft is empty, which is what makes ghost text manual
--
-- Two trigger styles are wired so the better one can be picked in use; deleting
-- the other is a single block. Insert-mode Alt keys do the triggering (a
-- normal-mode leader cannot fire mid-typing); <leader>am* only manages them.
--
-- Endpoint and model come from config.localllm, never from this file.

local llm = require("config.localllm")

return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Loaded on InsertEnter so setup() has run before any trigger key exists.
    -- No request is made at load time.
    event = "InsertEnter",
    keys = {
      { "<leader>amt", "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle ghost text" },
      { "<leader>amb", "<cmd>Minuet blink toggle<cr>", desc = "Toggle blink auto-complete" },
      { "<leader>amm", "<cmd>Minuet change_model<cr>", desc = "Change model" },
      { "<leader>ams", llm.status, desc = "Local LLM status" },
    },
    opts = {
      provider = "openai_fim_compatible",
      -- Upstream default is 3 seconds, which is hopeless here: a cold 1.9G
      -- model load plus generation on a CPU with no AVX runs far past that,
      -- and every completion would silently time out.
      request_timeout = 60,
      -- Manual-only means nothing is ever coalesced or rate-limited, so both
      -- of these only add latency to a keypress.
      throttle = 0,
      debounce = 0,
      -- Third guard on manual-only, alongside staying out of default_sources
      -- and prefetch_on_insert = false.
      blink = { enable_auto_complete = false },
      -- Two completions, short. n_completions is NOT a sampling count: the
      -- backend fires that many independent curl jobs with identical bodies
      -- (openai_base.lua, `for idx = 1, n_completions`), so it is also the
      -- server-side concurrency this asks for. At 1 there is nothing for
      -- <A-;>/<A-'> to cycle to -- advance() wraps straight back onto the only
      -- suggestion -- which reads as "the next key does nothing". At 2 cycling
      -- works, and it only stays cheap where the server has a matching
      -- OLLAMA_NUM_PARALLEL; with 1 slot ollama queues the second job behind
      -- the first and the wall time doubles. That is why the count is
      -- env-resolved rather than written here: g33nto sets 2, voidbox stays at
      -- the fallback of 1, and lua/ keeps no host conditional.
      n_completions = llm.fim_completions,
      -- 512-char window keeps prompt eval cheap. Not yet retuned for the GPU
      -- tier; see the note's benchmark before raising it.
      context_window = 512,
      provider_options = {
        openai_fim_compatible = {
          -- Ollama ignores the key but minuet requires the field to resolve.
          api_key = function()
            return "ollama"
          end,
          name = "Ollama",
          end_point = llm.fim_endpoint(),
          model = llm.fim_model,
          optional = {
            -- Generation is ~5.9 tok/s at 0.5B, so this is now the dominant
            -- cost, not prompt eval: 56 tokens is ~9.5s, 32 is ~5.4s. A FIM
            -- hole is usually a line or two, so the budget buys little.
            max_tokens = 32,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        -- Empty list = never auto-trigger. This is the manual switch.
        auto_trigger_ft = {},
        keymap = {
          accept = "<A-A>",
          accept_line = "<A-a>",
          prev = "<A-'>",
          next = "<A-;>", -- also the invoke key when nothing is shown
          dismiss = "<A-e>",
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      -- Manual invoke: show the menu with ONLY minuet in it.
      opts.keymap["<A-y>"] = {
        function(cmp)
          cmp.show({ providers = { "minuet" } })
        end,
      }

      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.minuet = {
        name = "minuet",
        module = "minuet.blink",
        async = true,
        -- A cold model load plus generation can exceed blink's default cutoff.
        timeout_ms = 30000,
        score_offset = 100,
      }
      -- Deliberately NOT added to opts.sources.default: staying out of the
      -- default list is what keeps it manual.

      opts.completion = opts.completion or {}
      opts.completion.trigger = opts.completion.trigger or {}
      opts.completion.trigger.prefetch_on_insert = false

      return opts
    end,
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>am", group = "minuet (fim)" },
      },
    },
  },
}
