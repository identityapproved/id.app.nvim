return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo =
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⠛⠛⠛⠛⠻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠛⢛⣿⠋⢀⡾⠃⠀⠀⠀⠀⢀⣤⣤⠤⠤⣤⣤⣀⣀⣀⣠⠶⡶⣤⣀⣠⠾⡷⣦⣀⣤⣤⡤⠤⠦⢤⣤⣄⡀⠀⢠⡶⢶⡄⠀⠀
⢠⡟⠁⣴⣿⢤⡄⣴⢶⠶⡆⠈⢷⡀⠀⠀⠀⠀⢀⣭⣫⠵⠥⠽⣄⣝⠵⢍⣘⣄⠳⣤⣀⠀⠀⢀⡤⠊⣽⠁⠀⠸⣇⠀⢿⠀⠀
⠸⢷⣴⣤⡤⠾⠇⣽⠋⠼⣷⠀⠈⢷⡄⢀⣤⡶⠋⠀⣀⡄⠤⠀⡲⡆⠀⠀⠈⠙⡄⠘⢮⢳⡴⠯⣀⢠⡏⠀⠀⠀⢻⠀⢸⠇⠀
⠀⠀⠀⠀⠀⠀⠀⠙⠛⠋⠉⢀⣴⠟⠉⢯⡞⡠⢲⠉⣼⠀⠀⡰⠁⡇⢀⢷⠀⣄⢵⠀⠈⡟⢄⠀⠀⠙⢷⣤⣤⣤⡿⢢⡿⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠟⠑⠊⠁⡼⣌⢠⢿⢸⢸⡀⢰⠁⡸⡇⡸⣸⢰⢈⠘⡄⠀⢸⠀⢣⡀⠀⠈⢮⢢⣏⣤⡾⠃⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣯⣴⠞⡠⣼⠁⡘⣾⠏⣿⢇⣳⣸⣞⣀⢱⣧⣋⣞⡜⢳⡇⠀⢸⠀⢆⢧⠀⠰⣄⢏⢧⣾⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢹⡏⢰⠁⡻⠀⡟⡏⠉⠀⣀⠀⠀⠀⠀⣀⠁⠀⠉⠛⢽⠇⠀⣼⡆⠈⡆⠃⠀⡏⠻⣾⣽⣇⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⡇⠀⡇⡄⣿⠷⠿⠿⠛⠀⠀⠀⠀⠛⠻⠿⠿⠿⡜⢀⡴⡟⢸⣸⡼⠀⠀⡇⠀⡞⡆⢻⠙⢦⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡶⢀⣼⣿⣬⣽⠧⠬⠇⠀⠀⠀⠀⠀⠀⢞⣯⣭⢺⣔⣪⣾⣤⠺⡇⢳⠀⢠⣧⡾⠛⠛⠻⠶⠞⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠷⢿⠟⠉⡀⠈⢦⡀⠀⠀⣠⠖⠒⠒⢤⡀⠀⢀⡼⠿⢇⡣⢬⣶⠷⢿⣤⡾⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠷⠾⠷⠖⠛⠛⠲⠶⠿⠤⣤⠤⠤⢷⣶⠋⠀⠀⠀⣱⠞⠁⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠓⠒⠚⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]]

      local tips = {
        "Once your brain remembers K (hover) and gl (diagnostic info), the rest falls into place.",
        "Use <leader>ff to find files fast; your future self will thank you.",
        "Grepping beats scrolling. Trust the search.",
        "<leader>if now inserts file links in md format via fzf.",
        "Define “done” more aggressively. “Understood enough to explain” beats “perfectly mapped.”",
        "The next version of you is not smarter. It is louder, narrower, and more finished.",
        "You are slightly over-protecting your potential from the risk of being measured.",
        "Authority in tech is taken by those who write first and apologize later.",
        "Silence does not improve taste. Publishing does.",
        "People don’t evaluate what you could do—only what you claim and demonstrate.",
        "At some point, the assistant should become a rubber duck, not a mentor.",
        "Security especially rewards ugly persistence. Elegant thinking helps—but flags fall to the stubborn.",
        "You don’t need more understanding in several areas. You need more boring reps.",
        "Your setup is already good enough. Past that point, each extra 1% polish costs you 10% execution velocity.",
        "At some point, tool optimization becomes procrastination with better aesthetics.",
        "Your Git should intimidate more than it currently does.",
      }

      local opts = {
        theme = "hyper",
        disable_move = true,
        shortcut_type = "letter",
        shuffle_letter = false,
        change_to_vcs_root = true,
        hide = { statusline = false, tabline = false, winbar = false },
        config = {
          header = vim.split(logo, "\n"),
          week_header = { enable = true },
          packages = { enable = true },
          project = {
            enable = true,
            limit = 8,
            icon = " ",
            action = "local path = ...; require('fzf-lua').files({ cwd = path })",
          },
          session = {
            enable = true,
            icon = " ",
            action = "lua require('persistence').select()",
          },
          mru = {
            enable = true,
            limit = 10,
            icon = " ",
            cwd_only = false,
            action = "local path = ...; require('fzf-lua').files({ cwd = path })",
          },
          shortcut = {
            { desc = "Update", group = "@property", action = "Lazy update", key = "u" },
            {
              desc = "Files",
              group = "Label",
              action = "lua require('fzf-lua').files()",
              key = "f",
            },
            {
              desc = "Commands",
              group = "DiagnosticHint",
              action = "lua require('fzf-lua').commands()",
              key = "a",
            },
            {
              desc = "Config",
              group = "Number",
              action = "lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })",
              key = "d",
            },
            {
              desc = "Session",
              group = "DiagnosticInfo",
              action = "lua require('persistence').select()",
              key = "s",
            },
            {
              desc = "Quit",
              group = "Error",
              action = "qa",
              key = "q",
            },
          },
          footer = {},
        },
        preview = { command = nil, file_path = nil, file_height = 0, file_width = 0 },
      }

      -- Precompute footer to avoid function serialization
      do
        math.randomseed(os.time())
        local tip = tips[math.random(#tips)]
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        local footer_logo = vim.split(logo, "\n")
        opts.config.footer = {
          "",
          "",
          tip,
          "",
          "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
          unpack(footer_logo),
        }
      end

      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    opts = { dashboard = { enabled = false } },
  },
}
