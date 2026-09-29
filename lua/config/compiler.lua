-- fzf-lua frontend for compiler.nvim, plus the options it does not ship.
--
-- compiler.nvim has exactly one frontend, lua/compiler/telescope.lua, and
-- hardcodes `require("telescope.config")` inside it. Telescope is disabled here in
-- favour of fzf-lua (plugins/fzf-lua.lua), so :CompilerOpen throws. Only the
-- picker is telescope-bound: each language module is a plain
-- `{ options = { { text, value }, ... }, action(value) }` pair, and the build
-- automation utilities (Makefile, CMake, meson, gradle, package.json) are the same
-- shape plus a `bau` field. So this reimplements the frontend and leaves every
-- backend untouched.
--
-- Departures from upstream, all deliberate:
--   * options carry their own table through the picker rather than being matched
--     back by display text, which upstream does and which breaks on duplicates.
--   * :CompilerRedo is reimplemented over the same state, so it replays the extras
--     below as well as the plugin's own options.

local M = {}

local FINAL_MESSAGE = "--task finished--"

--- Extra options this config adds per filetype. compiler.nvim ships no `cargo
--- test` at all (nor any test target for any language), and editing its own
--- languages/rust.lua would be undone by the next Lazy sync, so they live here.
---
--- `when` gates on project layout, as the bau discovery does. An entry is either
--- a fixed `cmd` string, or a `prompt` plus a `cmd(input)` function for the ones
--- that need an argument.
M.extras = {
  rust = {
    when = function()
      return vim.uv.fs_stat("Cargo.toml") ~= nil
    end,
    options = {
      { text = "Cargo test", cmd = "cargo test" },
      -- Rust swallows stdout for passing tests; --nocapture is how you see print
      -- and dbg output.
      { text = "Cargo test (show output)", cmd = "cargo test -- --nocapture" },
      -- Also runs the #[ignore] tests, which plain `cargo test` skips.
      { text = "Cargo test (include ignored)", cmd = "cargo test -- --include-ignored" },
      {
        text = "Cargo test (filter by name)",
        prompt = "Test name filter: ",
        cmd = function(filter)
          return "cargo test " .. vim.fn.shellescape(filter) .. " -- --nocapture"
        end,
      },
      { text = "Cargo test --workspace", cmd = "cargo test --workspace" },
      { text = "Cargo test --release", cmd = "cargo test --release" },
      { text = "Cargo test --doc", cmd = "cargo test --doc" },
      -- rust.lua has clippy nowhere either, and plugins/rust.lua already points
      -- rust-analyzer's checkOnSave at it, so this is the same lints on demand.
      { text = "Cargo clippy", cmd = "cargo clippy --all-targets -- -D warnings" },
    },
  },
}

--- Run a shell line as an overseer task, shaped like the tasks compiler.nvim's own
--- backends build so results land in the same panel.
local function start_task(name, cmd)
  require("overseer")
    .new_task({
      name = "- Compiler",
      strategy = {
        "orchestrator",
        tasks = {
          {
            name = name,
            cmd = cmd .. ' && echo "' .. FINAL_MESSAGE .. '"',
            components = { "default_extended" },
          },
        },
      },
    })
    :start()
end

--- Build the option list for a filetype.
--- @param filetype string
--- @return table language, table[] options
local function collect(filetype)
  local utils = require("compiler.utils")

  -- require_language uses dofile, not require, so this is a fresh table every
  -- call: safe to mutate, and no stale state between opens.
  local language = utils.require_language(filetype) or utils.require_language("make") or {}

  local options = {}
  for _, option in ipairs(language.options or {}) do
    -- Upstream pads its list with { text = "", value = "separator" } rows for
    -- telescope's benefit (rust, python, java, dart, cs, kotlin and swift all
    -- have them). In a flat fzf list they are blank, selectable no-ops.
    if option.value ~= "separator" then
      table.insert(options, option)
    end
  end

  -- Options discovered from Makefile, CMakeLists.txt, meson.build, package.json...
  -- Already self-labelling ("Make all"), so no separators are needed.
  vim.list_extend(options, require("compiler.utils-bau").get_bau_opts())

  local extra = M.extras[filetype]
  if extra and (not extra.when or extra.when()) then
    for _, option in ipairs(extra.options) do
      table.insert(options, vim.tbl_extend("force", option, { extra = true }))
    end
  end

  return language, options
end

--- Execute one option. `replay` skips the prompt on :CompilerRedo by reusing the
--- answer given the first time.
local function run(option, language, filetype, replay)
  if option.extra then
    if option.prompt and not replay then
      vim.ui.input({ prompt = option.prompt }, function(input)
        if input and input ~= "" then
          option = vim.tbl_extend("force", option, { answer = input })
          M.last = { option = option, language = language, filetype = filetype }
          start_task("- " .. option.text .. ": " .. input, option.cmd(input))
        end
      end)
      return
    end
    local cmd = option.cmd
    if type(cmd) == "function" then
      cmd = cmd(option.answer)
    end
    start_task("- " .. option.text, cmd)
  elseif option.bau then
    local bau = require("compiler.utils-bau").require_bau(option.bau)
    if not bau then
      return
    end
    bau.action(option.value)
    -- Kept in sync for anything else reading compiler.nvim's globals.
    _G.compiler_redo_selection = nil
    _G.compiler_redo_bau_selection = option.value
    _G.compiler_redo_bau = bau
  else
    language.action(option.value)
    _G.compiler_redo_selection = option.value
    _G.compiler_redo_filetype = filetype
    _G.compiler_redo_bau_selection = nil
    _G.compiler_redo_bau = nil
  end

  M.last = { option = option, language = language, filetype = filetype }
end

function M.show()
  -- Upstream's guard: the backends compile into ./bin and glob sources from the
  -- working directory, so $HOME as cwd would scatter build output across it.
  if vim.uv.os_homedir() == vim.uv.cwd() then
    vim.notify("You must :cd your project dir first.\nHome is not allowed as working dir.", vim.log.levels.WARN, {
      title = "Compiler.nvim",
    })
    return
  end

  local filetype = vim.bo.filetype
  local language, options = collect(filetype)
  if vim.tbl_isempty(options) then
    vim.notify("No compiler options for filetype '" .. filetype .. "'.", vim.log.levels.INFO, {
      title = "Compiler.nvim",
    })
    return
  end

  -- Numbered so display strings stay unique, which is what maps a selection back
  -- to its option table.
  local by_display, entries = {}, {}
  for i, option in ipairs(options) do
    local display = string.format("%2d  %s", i, option.text)
    by_display[display] = option
    table.insert(entries, display)
  end

  require("fzf-lua").fzf_exec(entries, {
    prompt = "Compiler> ",
    fzf_opts = { ["--no-multi"] = true, ["--no-sort"] = true },
    winopts = { height = 0.50, width = 0.60 },
    actions = {
      ["default"] = function(selected)
        local option = selected and selected[1] and by_display[selected[1]]
        if option then
          run(option, language, filetype)
        end
      end,
    },
  })
end

--- Replay the last selection. Reimplemented rather than left to compiler.nvim so
--- it covers M.extras too; the filetype check is upstream's.
function M.redo()
  local last = M.last
  if not last then
    vim.notify("Open the compiler and select an option before doing redo.", vim.log.levels.INFO, {
      title = "Compiler.nvim",
    })
    return
  end
  if last.filetype ~= vim.bo.filetype then
    vim.notify(
      "You are on a different language now. Open the compiler and select an option before doing redo.",
      vim.log.levels.INFO,
      { title = "Compiler.nvim" }
    )
    return
  end
  run(last.option, last.language, last.filetype, true)
end

--- Replace the :CompilerOpen and :CompilerRedo that compiler.nvim's own setup()
--- creates. :CompilerToggleResults and :CompilerStop are picker-agnostic and left
--- alone, as is the overseer "default_extended" alias setup() registers.
function M.setup()
  vim.api.nvim_create_user_command("CompilerOpen", M.show, { desc = "Open the compiler" })
  vim.api.nvim_create_user_command("CompilerRedo", M.redo, { desc = "Redo the last selected compiler option" })
end

return M
