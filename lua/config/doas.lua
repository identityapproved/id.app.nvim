-- Write root-owned files (/etc on the Void and Gentoo hosts) without reopening
-- nvim as root. These hosts have no sudo, and doas reads its passphrase from
-- /dev/tty, which vim.fn.system() cannot drive. Priming the persist timestamp
-- in a separate call does not help either: doas keys the timestamp on the
-- caller's ppid, start time and session id, and a terminal job gets its own
-- session from the pty's setsid(). So the privileged command itself has to run
-- in the terminal, where doas can prompt.
local M = {}

---Serialise the current buffer to a temp file. nvim does the writing so
---'fileformat', 'fileencoding' and 'endofline' are honoured.
---@return string
local function snapshot()
  local tmp = vim.fn.tempname()
  vim.cmd(("silent keepalt write! %s"):format(vim.fn.fnameescape(tmp)))
  return tmp
end

-- dd writes through the existing inode, so the target keeps its owner and mode.
local function dd(tmp, path)
  return { "dd", "if=" .. tmp, "of=" .. path, "bs=1048576" }
end

---@param cmd string[]
---@param on_done fun(ok: boolean)
local function in_terminal(cmd, on_done)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor(vim.o.lines / 2) - 3,
    col = math.floor(vim.o.columns / 4),
    width = math.floor(vim.o.columns / 2),
    height = 4,
    border = "rounded",
    title = " doas ",
  })

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, code)
      vim.schedule(function()
        -- Leave the window up on failure so doas' own message stays readable.
        if code == 0 then
          pcall(vim.api.nvim_win_close, win, true)
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        else
          vim.bo[buf].modifiable = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, desc = "Close" })
        end
        on_done(code == 0)
      end)
    end,
  })
  vim.cmd.startinsert()
end

---Write the current buffer to a root-owned path.
---@param path? string target, defaulting to the buffer's own file
function M.write(path)
  local bufnr = vim.api.nvim_get_current_buf()
  path = path and #path > 0 and path or vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return vim.notify("doas: buffer has no file name", vim.log.levels.ERROR)
  end
  path = vim.fn.fnamemodify(path, ":p")

  local tmp = snapshot()
  local function finish(ok)
    vim.fn.delete(tmp)
    if not ok then
      return
    end
    if path == vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p") then
      vim.bo[bufnr].modified = false
    end
    vim.notify(("%s written as root"):format(vim.fn.fnamemodify(path, ":~")))
  end

  -- A live persist timestamp or a nopass rule means no prompt is needed, so try
  -- that first and skip the terminal entirely.
  vim.fn.system(vim.list_extend({ "doas", "-n" }, dd(tmp, path)))
  if vim.v.shell_error == 0 then
    return finish(true)
  end

  -- doas needs a tty. Run the same command there, where it can ask.
  in_terminal(vim.list_extend({ "doas" }, dd(tmp, path)), function(ok)
    if not ok then
      vim.notify("doas: write failed, see the doas window (q closes it)", vim.log.levels.ERROR)
    end
    finish(ok)
  end)
end

return M
