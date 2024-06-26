### todo comments

- TODO = { icon = " ", color = "info" },
- HACK = { icon = " ", color = "warning" },
- WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
- PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
- TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },

### Leetcode

- toggle = { "q" },
- confirm = { "<CR>" },
- reset_testcases = "r",
- use_testcase = "U",
- focus_testcases = "H",
- focus_result = "L",

### Telescope CMDline

#### Mappings

- <CR> Run user input if entered, otherwise run first selection
- <TAB> complete current selection into input (useful for :e, :split, :vsplit, :tabnew)
- <C-CR>Run selection directly
- <C-e> edit current selection in prompt

### ChatGPT

- close = "<C-c>"
- yank_last = "<C-y>"
- yank_last_code = "<C-k>"
- scroll_up = "<C-u>"
- scroll_down = "<C-d>"
- new_session = "<C-n>"
- cycle_windows = "<Tab>"
- cycle_modes = "<C-f>"
- next_message = "<C-j>"
- prev_message = "<C-k>"
- select_session = "<Space>"
- rename_session = "r"
- delete_session = "d"
- draft_message = "<C-r>"
- edit_message = "e"
- delete_message = "d"
- toggle_settings = "<C-o>"
- toggle_sessions = "<C-p>"
- toggle_help = "<C-h>"
- toggle_message_role = "<C-r>"
- toggle_system_role_open = "<C-s>"
- stop_generating = "<C-x>"

### LeetCode

| **Command**                   | **Description**                                                           |
| ----------------------------- | ------------------------------------------------------------------------- |
| **Leet opens menu dashboard** |                                                                           |
| menu                          | same as Leet                                                              |
| exit                          | close leetcode.nvim                                                       |
| console                       | opens console pop-up for currently opened question                        |
| info                          | opens a pop-up containing information about the currently opened question |
| tabs                          | opens a picker with all currently opened question tabs                    |
| yank                          | yanks the current question solution                                       |
| lang                          | opens a picker to change the language of the current question             |
| run                           | run currently opened question                                             |
| test                          | same as Leet run                                                          |
| submit                        | submit currently opened question                                          |
| random                        | opens a random question                                                   |
| daily                         | opens the question of today                                               |
| list                          | opens a problem list picker                                               |
| open                          | opens the current question in a default browser                           |
| reset                         | reset current question to default code definition                         |
| last_submit                   | retrieve last submitted code for the current question                     |
| restore                       | try to restore default question layout                                    |
| inject                        | re-inject code for the current question                                   |
| **session**                   |                                                                           |
| create                        | create a new session                                                      |
| change                        | change the current session                                                |
| update                        | update the current session in case it went out of sync                    |
| **desc**                      |                                                                           |
| toggle                        | same as Leet desc                                                         |
| stats                         | toggle description stats visibility                                       |
| **cookie**                    |                                                                           |
| update                        | opens a prompt to enter a new cookie                                      |
| delete                        | sign-out                                                                  |
| **cache**                     |                                                                           |
| update                        | updates cache                                                             |
| **Optional Arguments**        |                                                                           |
| Leet list                     | Leet list status=<status> difficulty=<difficulty>                         |
| Leet random                   | Leet random status=<status> difficulty=<difficulty> tags=<tags>           |
