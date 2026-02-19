-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function md_gf_with_anchor()
  local cfile = vim.fn.expand("<cfile>")
  if cfile == nil or cfile == "" then
    vim.cmd("normal! gf")
    return
  end

  local file, anchor = cfile:match("^(.-)#(.+)$")
  if not file then
    file = cfile
  end

  local base_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  local target = file
  if file:sub(1, 1) ~= "/" then
    target = vim.fs.joinpath(base_dir, file)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(target))

  if anchor and anchor ~= "" then
    anchor = anchor:gsub("%%20", " "):gsub("-", " ")
    vim.fn.search("^#+\\s\\+.*" .. vim.fn.escape(anchor, "\\/.*$^~[]"), "W")
  end
end

local function relative_path(from_dir, to_path)
  local from = vim.fs.normalize(from_dir)
  local to = vim.fs.normalize(to_path)

  local from_parts = vim.split(from, "/", { trimempty = true })
  local to_parts = vim.split(to, "/", { trimempty = true })

  local i = 1
  while i <= #from_parts and i <= #to_parts and from_parts[i] == to_parts[i] do
    i = i + 1
  end

  local rel = {}
  for _ = i, #from_parts do
    table.insert(rel, "..")
  end
  for j = i, #to_parts do
    table.insert(rel, to_parts[j])
  end

  if #rel == 0 then
    return "."
  end
  return table.concat(rel, "/")
end

-- Manual signature help (auto popups disabled in options)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("custom_signature_help", { clear = true }),
  callback = function(event)
    vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, {
      buffer = event.buf,
      desc = "Signature help",
    })
  end,
})

-- Apply clipboard provider after LazyVim finishes loading.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("custom_clipboard_provider", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    require("config.clipboard").setup()
  end,
})

-- Markdown: insert file link via fzf-lua
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("custom_markdown_links", { clear = true }),
  pattern = { "markdown", "markdown_inline" },
  callback = function(event)
    vim.keymap.set("n", "<leader>if", function()
      require("fzf-lua").files({
        file_icons = false,
        git_icons = false,
        actions = {
          ["default"] = function(selected)
            local entry = selected[1]
            if not entry or entry == "" then
              return
            end
            local path = tostring(entry)
            local absolute = vim.fn.fnamemodify(path, ":p")
            local current_file = vim.api.nvim_buf_get_name(event.buf)
            local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
            local relative = relative_path(current_dir, absolute)
            local name = vim.fn.fnamemodify(absolute, ":t")
            if name:sub(-3) == ".md" then
              name = name:sub(1, -4)
            end
            vim.api.nvim_put({ string.format("[%s](%s)", name, relative) }, "c", true, true)
          end,
        },
      })
    end, { buffer = event.buf, desc = "Insert file link" })

    vim.keymap.set("n", "gf", md_gf_with_anchor, {
      buffer = event.buf,
      desc = "gf markdown file#heading",
    })
  end,
})
