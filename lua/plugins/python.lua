-- Full Python LSP support: basedpyright (types/completion) + ruff (lint/codeactions),
-- venv-aware (auto-detects .venv/.env/venv/env or $VIRTUAL_ENV), DAP, venv picker.
-- basedpyright is used instead of pyright because it installs via pip and bundles
-- its own Node, so it works on this box which has no system node/npm.

-- Resolve the interpreter for a project root so the LSP sees installed packages
-- (e.g. `requests`) even when the venv is named ".env" instead of ".venv".
local function venv_python(root)
  root = root or vim.fn.getcwd()
  for _, name in ipairs({ ".venv", "venv", ".env", "env" }) do
    local py = root .. "/" .. name .. "/bin/python"
    if vim.fn.executable(py) == 1 then
      return py
    end
  end
  local active = vim.env.VIRTUAL_ENV
  if active and vim.fn.executable(active .. "/bin/python") == 1 then
    return active .. "/bin/python"
  end
  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python3"
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "black",
        "debugpy",
        "isort",
        "basedpyright",
        "ruff",
      })
    end,
  },

  -- basedpyright is attached manually via the FileType autocmd below, NOT through
  -- LazyVim's server pipeline: vim.lsp.enable() was silently failing to attach it
  -- on this setup, while a direct vim.lsp.start() works (verified: returns a live
  -- client). enabled=false keeps LazyVim/mason-lspconfig from touching it.
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          local root = vim.fs.root(args.buf, {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "pyrightconfig.json",
            ".git",
          }) or vim.fn.getcwd()
          -- Use blink's capabilities so completion/snippets are advertised.
          local caps = vim.lsp.protocol.make_client_capabilities()
          local ok, blink = pcall(require, "blink.cmp")
          if ok and blink.get_lsp_capabilities then
            caps = blink.get_lsp_capabilities(caps)
          end
          vim.lsp.start({
            name = "basedpyright",
            -- absolute path to the Mason binary: exactly the cmd that attached a
            -- working client in testing; independent of $PATH timing.
            cmd = {
              vim.fn.expand("$HOME/.local/share/nvim/mason/bin/basedpyright-langserver"),
              "--stdio",
            },
            root_dir = root,
            capabilities = caps,
            before_init = function(_, config)
              config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                python = { pythonPath = venv_python(root) },
              })
            end,
            settings = {
              basedpyright = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "openFilesOnly",
                  typeCheckingMode = "basic",
                },
              },
            },
          }, { bufnr = args.buf })
        end,
      })
    end,
    opts = {
      servers = {
        basedpyright = { enabled = false }, -- handled by the FileType autocmd above
        ruff = {
          -- ruff handles lint + import sorting + quick-fixes; basedpyright owns hover/types.
          init_options = {
            settings = {
              organizeImports = true,
            },
          },
        },
      },
      setup = {
        ruff = function()
          -- Avoid duplicate hover from ruff; basedpyright is the source of truth.
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "ruff" then
                client.server_capabilities.hoverProvider = false
              end
            end,
          })
        end,
      },
    },
  },

  -- Interactive venv switching: :VenvSelect (auto-detection is handled by
  -- basedpyright's before_init above; this is just for picking a venv by hand).
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    opts = {},
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("debugpy")
    end,
  },

  -- :Pydoc-style lookup (<leader>cD): full module/object docs for ANY installed
  -- package, including third-party ones devdocs.io doesn't carry (psutil, etc.).
  -- Runs `python -m pydoc <target>` through the project's venv interpreter (the
  -- same venv_python resolver basedpyright uses above), so it sees the same
  -- packages as the LSP, and shows the plain-text output in a snacks float.
  -- Defaults to the word under the cursor; the prompt lets you edit it.
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "<leader>cD",
        function()
          vim.ui.input({ prompt = "Pydoc: ", default = vim.fn.expand("<cword>") }, function(target)
            if not target or target == "" then
              return
            end
            local root = vim.fs.root(0, {
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              "pyrightconfig.json",
              ".git",
            }) or vim.fn.getcwd()
            local res = vim.system({ venv_python(root), "-m", "pydoc", target }, { text = true }):wait()
            local text = res.code == 0 and res.stdout or res.stderr
            if not text or text == "" then
              text = "No documentation found for '" .. target .. "'"
            end
            Snacks.win({
              title = " pydoc: " .. target .. " ",
              text = text,
              position = "right", -- vertical split, like a doc pane
              width = 0.45,
              enter = true,
              wo = { wrap = false, cursorline = false },
            })
          end)
        end,
        desc = "Pydoc (venv)",
        ft = "python",
      },
    },
  },
}
