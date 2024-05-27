return {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", ":Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",  
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
        ensure_installed = {
            -- "docker-compose-language-service",
            -- "dockerfile-language-server",
            -- "goimports-reviser",
            -- "golines",
            -- "gopls",
            -- "html-lsp",
            -- "json-lsp",
            -- "ltex-ls",
            -- "lua-language-server",
            -- "markdownlint-cli2",
            -- "prettier",
            -- "shfmt",
        },
        registries = {
            "github:mason-org/mason-registry",
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)
        local mason = require("mason")
        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        })

        mason_tool_installer.setup({
          ensure_installed = {
            "prettier", -- prettier formatter
            "stylua", -- lua formatter
            "isort", -- python formatter
            "black", -- python formatter
            "pylint", -- python linter
            "eslint_d", -- js linter
            "clangd",
            "clang-format",
          },
        })

        local mr = require("mason-registry")
        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end
        if mr.refresh then
            mr.refresh(ensure_installed)
        else
            ensure_installed()
        end
    end,
}
