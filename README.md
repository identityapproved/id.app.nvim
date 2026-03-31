# `id.app.nvim` config

Personal Neovim configuration built on top of LazyVim, tuned for security research, lab work, writeups, and fast note-taking.

This repository is meant to be the source of truth for `~/.config/nvim` across machines.

## 𖦏 Focus 𖣠

This setup is optimized for a security / hacking workflow rather than general-purpose editing.

- Markdown-first note taking for boxes, challenges, and research logs
- Zettelkasten-style note creation with `zk`
- HTB / lab templates for enumeration, post-exploitation, and privesc notes
- Python templates for validation-oriented CVE / PoC work
- Terminal-heavy workflows with fast splits, fzf, and search-first navigation
- Language tooling centered on Python, Go, Rust, TypeScript, and Nim

The bias is toward speed, structured notes, reproducible commands, and lightweight PoC scaffolding.

## 🛠 Requirements

- Neovim `>= 0.9` (recommended: latest stable)
- Git
- A Nerd Font (recommended for icons)
- `ripgrep` (`rg`)
- `fd` (or `fdfind` depending on distro)
- `fzf` (for workflows/plugins that use it)

## ➤ Install 🖧

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

Setup script:

```bash
./install.sh
```

## ➜] Link Existing Repo to `~/.config/nvim`

If you keep this repo somewhere else on disk and want to link it:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
ln -sfn /path/to/id.app.nvim ~/.config/nvim
```

Preferred script-based link:

```bash
./install.sh
```

Useful flags:

```bash
./install.sh --dry-run
./install.sh --force
./install.sh --target ~/.config/nvim
```

Then start Neovim:

```bash
nvim
```

## 🗘 Update Plugins

Inside Neovim:

- `:Lazy sync`
- `:Lazy check`

Headless equivalents:

```bash
nvim --headless "+Lazy! sync" +qa
nvim --headless "+Lazy! check" +qa
```

## ⋮ ⌗ ┆ Repo Layout

- `init.lua`: Neovim entrypoint
- `lua/config/`: core config (options, keymaps, autocmds, bootstrap)
- `lua/plugins/`: plugin specs and plugin-specific setup
- `templates/`: reusable note and code templates, including security and HTB workflows
- `snippets/`: custom snippets
- `lazy-lock.json`: pinned plugin versions

## ☕︎‧₊˚⏱ Workflow Highlights ٠࣪⋆₊˚ᵎ

### Notes and writeups

- Markdown buffers can insert note templates with `<leader>it`
- Markdown buffers can insert callout snippets with `<leader>ic`
- `zk` is used for zettel-style note management
- `<leader>zn` creates a new note through a prompt

### Focus mode

- `<leader>zm` toggles Zen Mode

### Security templates

The repo includes reusable templates for:

- HTB / lab note sections
- Linux post-foothold and privesc checklists
- Docker group / `sg` enumeration notes
- Python CVE / research PoC skeletons
- HTTP, SSRF, LFI, SQLi, SSTI, IDOR, upload, race, and WebSocket validation templates

## (˘ŏ_ŏ) Troubleshooting

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
