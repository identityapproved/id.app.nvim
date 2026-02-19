# Repository Guidelines

## Project Structure & Module Organization
- Neovim entrypoint lives in `init.lua`, which bootstraps LazyVim via `lua/config/lazy.lua`.
- Core settings live under `lua/config/` (`options.lua`, `keymaps.lua`, `autocmds.lua`, `taskwarrior.lua`). Add new shared helpers here instead of inside plugins.
- Plugin specs sit in `lua/plugins/` as individual Lua tables; `.bak` files are examples/disabled specs. Keep one feature per file.
- Tooling config is at `stylua.toml` (formatting), `lazy-lock.json` (plugin versions), and `lazyvim.json` (LazyVim defaults). Do not hand-edit the lockfile.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy! sync" +qa` installs/updates plugins; run after adding or editing specs.
- `nvim --headless "+Lazy! check" +qa` validates plugin availability and reports missing dependencies.
- `stylua .` formats all Lua per `stylua.toml`; run before submitting changes.
- Launch locally with `nvim` (using this repo as `~/.config/nvim` or `-u` flag) to manually verify keymaps and plugins.

## Coding Style & Naming Conventions
- Format with Stylua (2-space indentation, 120-column wrap). Avoid trailing whitespace and align tables compactly.
- Name modules and files with `snake_case` (config) or concise feature-focused filenames (plugins). Prefer descriptive keymap descriptions (`desc` fields).
- Keep plugin specs declarative: return a table; use `opts` for configuration and `config` only when imperative setup is required.
- Keep comments brief and purposeful (why over what); rely on LazyVim defaults where possible instead of re-defining.

## Testing Guidelines
- No automated test suite exists; rely on headless health checks (`nvim --headless "+checkhealth" +qa`) when changing core setup.
- For plugin changes, open Neovim and exercise related commands/keymaps (e.g., Taskwarrior bindings `<leader>ta`, Mistake entries `<leader>ma`).
- Validate new keymaps do not collide with LazyVim defaults and that required external tools (e.g., `task`) are installed.

## Commit & Pull Request Guidelines
- Repository has no recorded Git history; prefer Conventional Commits (`feat:`, `fix:`, `chore:`) to keep future history readable.
- Scope commits narrowly (one feature/fix) and mention touched modules (`plugins/mistake`, `config/taskwarrior`).
- Pull requests should describe motivation, notable config changes, manual validation steps, and any external tool requirements; include before/after notes for UX-facing tweaks (keymaps, commands, visuals).
- Avoid editing `lazy-lock.json` by hand; let Lazy manage it and include the updated lockfile when plugin versions change.
