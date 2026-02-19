# Templates

This directory powers the Neovim template pickers:

- `<leader>it` inserts a template at the cursor.
- `<leader>ic` inserts a Markdown callout snippet (Markdown only).

## Layout

### Markdown templates

All Markdown templates live in `templates/notes/`.

### Callouts (Markdown)

Callout snippets live in `templates/callouts/`. These are inserted as plain Markdown blockquotes and can be customized freely.

### Non-Markdown templates

Non-Markdown templates are organized by filetype under `templates/code/`:

- `templates/code/<filetype>/...` (e.g. `templates/code/python/`)
- `templates/code/_common/...` fallback when no folder exists

## Placeholders

Templates support simple placeholders:

- `{{date}}` → `YYYY-MM-DD`
- `{{datetime}}` → `YYYY-MM-DD HH:MM`
- `{{title}}` → current filename (no extension)
- `{{file}}` → current filename
- `{{path}}` → absolute path to current file
