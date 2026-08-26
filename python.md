# Python LSP setup

How Python language support is wired in this config, and why it is done this
way. The setup lives in two files:

- `lua/plugins/python.lua` - the Python tooling spec (LSP, lint, format, DAP)
- `lua/config/options.lua` - one line that puts Mason's bin dir on `$PATH`

The end result: `basedpyright` provides completion / hover / go-to / types,
`ruff` provides linting + import sorting + quick-fixes, and both are venv-aware
so packages installed in a project's virtualenv (including one named `.env`)
resolve correctly.

## Why basedpyright instead of pyright

This machine has no system `node` / `npm`. Stock `pyright` is an npm package,
so Mason cannot install it here - the install fails with
`Could not find executable "npm" in PATH`. `basedpyright` is a pyright fork
published on PyPI that Mason installs with `pip` and that bundles its own Node
binary, so it works with no system Node at all.

If you ever install system Node (`emerge net-libs/nodejs`), the npm-based tools
(`markdownlint-cli2`, `prettier`, `vtsls`, ...) that currently fail in the Mason
log will start working too. They are unrelated to Python.

## The two problems that had to be solved

Getting completion to actually appear required fixing two separate, independent
bugs. Both are worth knowing because they affect every Mason-installed server,
not just Python.

### Problem 1 - Mason's bin dir was not on Neovim's PATH

`vim.lsp` validates a server's `cmd` by resolving the executable on `$PATH`.
Mason installs its binaries under `$HOME/.local/share/nvim/mason/bin`, but that
directory was not reliably on the PATH that `vim.lsp` saw. The symptom was an
error in `~/.local/state/nvim/lsp.log`:

```
invalid "lua_ls" config: cmd: ... lua-language-server is not executable
```

Any server whose binary lives only in Mason (`lua_ls`, `basedpyright`) was
rejected and never spawned. `ruff` survived only because `ruff` also resolves on
the system PATH.

Fix, in `lua/config/options.lua` (loads before plugins):

```lua
do
  local mason_bin = vim.fn.expand("$HOME/.local/share/nvim/mason/bin")
  if not (":" .. vim.env.PATH .. ":"):find(":" .. mason_bin .. ":", 1, true) then
    vim.env.PATH = vim.env.PATH .. ":" .. mason_bin
  end
end
```

It is **appended**, not prepended, so a file in the Mason dir can never shadow a
system binary like `git` or `ls`. Setting `vim.env.PATH` updates Neovim's actual
process environment, so child LSP processes inherit it. This is done inside
Neovim (not `.zshrc`) so it applies no matter how Neovim is launched, and it
fixes every Mason server at once - it also cleared the old `lua_ls` errors.

### Problem 2 - LazyVim's auto-enable never attached basedpyright

Even with the PATH fixed and basedpyright installed and healthy (running the
binary by hand answered LSP requests correctly), it still would not attach to
Python buffers. LazyVim configures servers from `opts.servers` and then leans on
`vim.lsp.enable()` / mason-lspconfig's auto-enable to start them. On this setup
that path silently no-op'd for basedpyright - the server was never spawned, and
the buffer's `omnifunc` stayed empty (the tell that no completion-capable client
is attached).

A direct `vim.lsp.start{...}` call, by contrast, attached a working client every
time. So the fix is to stop using LazyVim's pipeline for this one server and
start it ourselves.

## How basedpyright is started now

In `lua/plugins/python.lua`, the `nvim-lspconfig` spec does two things:

- `opts.servers.basedpyright = { enabled = false }` - tells LazyVim and
  mason-lspconfig to leave basedpyright completely alone, so nothing competes
  with or double-starts it.
- An `init` function registers a `FileType python` autocmd that calls
  `vim.lsp.start` directly for every Python buffer.

The autocmd, in plain terms:

- Finds the project root with `vim.fs.root`, looking up the tree for
  `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`,
  `pyrightconfig.json`, or `.git`, falling back to the cwd.
- Builds completion capabilities from blink.cmp
  (`require("blink.cmp").get_lsp_capabilities`) so the server knows the client
  wants completion and snippets.
- Starts basedpyright with an **absolute** `cmd` pointing straight at the Mason
  binary (`$HOME/.local/share/nvim/mason/bin/basedpyright-langserver --stdio`).
  This is the exact command that attached a live client in testing, and it is
  immune to any PATH timing issues.
- In `before_init`, sets `python.pythonPath` to the project's venv interpreter
  (see below) so the server analyses against the right packages.
- Passes basedpyright analysis settings: `typeCheckingMode = "basic"`,
  `diagnosticMode = "openFilesOnly"`, library types on.
- Attaches to the triggering buffer via `{ bufnr = args.buf }`.

`vim.lsp.start` de-duplicates by config (name + root + cmd), so reopening or
revisiting a Python buffer reuses the same client instead of spawning copies.

## Venv detection (the `.env` gotcha)

The `venv_python(root)` helper at the top of the file picks the interpreter the
server should analyse against. It checks, in order:

- `<root>/.venv/bin/python`, `<root>/venv/bin/python`,
  `<root>/.env/bin/python`, `<root>/env/bin/python`
- `$VIRTUAL_ENV/bin/python` if a venv is currently activated
- system `python3` as a last resort

The `.env` entry matters here: virtualenvs are commonly named `.venv`, but this
project uses `.env`, which basedpyright would not auto-detect. Because the path
is resolved explicitly and fed in as `pythonPath`, completion for installed
packages (for example `requests.`) works regardless of whether you activated the
venv before launching Neovim.

`venv-selector.nvim` is also installed for switching venvs by hand with
`:VenvSelect` (`<leader>cv`), but day to day the automatic detection above is
what makes packages resolve.

## ruff

`ruff` is configured the normal LazyVim way in `opts.servers.ruff`, with
`organizeImports = true`. A small `setup.ruff` handler registers an `LspAttach`
autocmd that disables ruff's `hoverProvider`, so hover comes only from
basedpyright and you do not get duplicate popups. ruff still owns diagnostics,
import sorting, and quick-fixes. Formatting is handled separately by
`conform.nvim` (`isort` then `black`) in `lua/plugins/conform.lua`.

## Other Python pieces

- `mason.nvim` `ensure_installed` pulls `basedpyright`, `ruff`, `black`,
  `isort`, `debugpy`.
- `nvim-dap-python` wires up debugging through `debugpy`.

## Verifying it works

Open a `.py` file and run:

```vim
:lua for _,c in ipairs(vim.lsp.get_clients({bufnr=0})) do print(c.name) end
```

Expect both `basedpyright` and `ruff`. Then type `socketserver.` on a clean line
and completions should appear. `Ctrl-x Ctrl-o` should not raise `E764` once a
completion-capable client is attached.

If completion is missing again, the order to check:

- `:lua =vim.fn.exepath("basedpyright-langserver")` - should print the Mason
  path (PATH fix intact).
- Run the langserver binary by hand with `--stdio`; it should print
  `basedpyright language server ... starting` - confirms the binary is healthy.
- `tail ~/.local/state/nvim/lsp.log` - real spawn/exit errors land here.
- Confirm the package you expect is actually installed in the project venv;
  basedpyright can only complete what is importable from `pythonPath`.
