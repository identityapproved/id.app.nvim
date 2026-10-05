-- Shared resolver for the local ollama endpoint and model names.
--
-- Both AI plugins that talk to a local model (minuet for FIM, codecompanion for
-- chat) read their endpoint and model from here rather than hardcoding one, so
-- this config stays identical on every host. What differs per machine lives in
-- the shell environment instead -- see the LOCAL_* block in lainland's
-- dot_zshenv. That is the only reason lua/ contains no host conditionals.
--
-- Two models, deliberately: FIM needs a -base tag, because the instruct
-- variants answer a question instead of completing the hole. Chat needs the
-- instruct tag for the opposite reason.
--
-- Runbook: ~/zettelnotes/adeg_local-llm-fim-and-chat-in-neovim.md

local M = {}

---@param name string environment variable
---@param fallback string used when unset or empty
---@return string
local function env(name, fallback)
  local value = vim.env[name]
  if value == nil or value == "" then
    return fallback
  end
  return value
end

-- Fallbacks are the voidbox tier: a fresh clone on a host with no LOCAL_* vars
-- set still works, just with the smaller models.
M.url = env("LOCAL_LLM_URL", "http://127.0.0.1:11434"):gsub("/+$", "")
M.fim_model = env("LOCAL_FIM_MODEL", "qwen2.5-coder:0.5b-base")
M.chat_model = env("LOCAL_CHAT_MODEL", "qwen2.5-coder:3b-instruct")

-- OpenAI-compatible FIM endpoint. Ollama accepts a "suffix" field here, which
-- is what makes fill-in-middle work at all.
function M.fim_endpoint()
  return M.url .. "/v1/completions"
end

---Is the server up? Used by the status keymap, not on any hot path -- this
---blocks for up to `timeout` seconds.
---@param timeout number? seconds, default 2
---@return boolean
function M.reachable(timeout)
  local ok, result = pcall(function()
    return vim.system({ "curl", "-fsS", "-m", tostring(timeout or 2), M.url .. "/api/tags" }, { text = true }):wait()
  end)
  return ok and result.code == 0
end

---Print endpoint, models and reachability. Bound to <leader>ams.
function M.status()
  local up = M.reachable()
  vim.notify(
    table.concat({
      "endpoint : " .. M.url .. (up and "  (up)" or "  (unreachable)"),
      "fim      : " .. M.fim_model,
      "chat     : " .. M.chat_model,
    }, "\n"),
    up and vim.log.levels.INFO or vim.log.levels.WARN,
    { title = "local llm" }
  )
end

return M
