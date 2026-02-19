# Neovim Config (`id.app.nvim`)

Personal Neovim configuration built on top of LazyVim.

This repository is meant to be the source of truth for `~/.config/nvim` across machines.

## Requirements

- Neovim `>= 0.9` (recommended: latest stable)
- Git
- A Nerd Font (recommended for icons)
- `ripgrep` (`rg`)
- `fd` (or `fdfind` depending on distro)
- `fzf` (for workflows/plugins that use it)

## Install (new machine)

```bash
git clone https://github.com/identityapproved/id.app.nvim.git ~/.config/nvim
nvim
```

On first start, Lazy will install plugins automatically.

Or clone anywhere and run the installer:

```bash
git clone https://github.com/identityapproved/id.app.nvim.git ~/id.app.nvim
cd ~/id.app.nvim
./install.sh
```

## Link Existing Repo to `~/.config/nvim`

If you keep this repo somewhere else on disk and want to link it:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
ln -sfn /path/to/id.app.nvim ~/.config/nvim
```

Preferred script-based link:

```bash
./symlinkin.sh
```

Useful flags:

```bash
./symlinkin.sh --dry-run
./symlinkin.sh --force
./symlinkin.sh --target ~/.config/nvim
```

Then start Neovim:

```bash
nvim
```

## Update Plugins

Inside Neovim:

- `:Lazy sync`
- `:Lazy check`

Headless equivalents:

```bash
nvim --headless "+Lazy! sync" +qa
nvim --headless "+Lazy! check" +qa
```

## Repo Layout

- `init.lua`: Neovim entrypoint
- `lua/config/`: core config (options, keymaps, autocmds, bootstrap)
- `lua/plugins/`: plugin specs and plugin-specific setup
- `templates/`: reusable note/code templates
- `snippets/`: custom snippets
- `lazy-lock.json`: pinned plugin versions

## Notes

- `AGENTS.md` is intentionally tracked and should stay in the repo.
- Machine-local runtime artifacts (for example `.nvimlog`, `.DS_Store`) are ignored.

## Troubleshooting

If plugins look broken after changes:

```bash
nvim --headless "+Lazy! restore" +qa
nvim --headless "+checkhealth" +qa
```

If needed, remove local plugin/cache state and reopen Neovim.
Warning: this deletes local Neovim cache/state and will force a full plugin reinstall on next start.

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
nvim
```
