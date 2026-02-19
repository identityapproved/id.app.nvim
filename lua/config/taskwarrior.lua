local M = {}

--- Add a Taskwarrior task annotated with current file and line
function M.add_task()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local desc = vim.fn.input("Task description: ")

  if desc == "" then
    vim.notify("Task creation cancelled.", vim.log.levels.INFO)
    return
  end

  -- Add the task
  local add_cmd = string.format('task rc.verbose=nothing add "%s"', desc)
  vim.fn.system(add_cmd)

  -- Get the ID of the most recently added task
  local last_id = vim.fn.systemlist("task +LATEST _ids")[1]

  if not last_id or last_id == "" then
    vim.notify("⚠️ Task created but could not determine latest ID.", vim.log.levels.WARN)
    return
  end

  -- Annotate it with file path and line
  local annotation = string.format("%s:%d", file, line)
  local ann_cmd = string.format('task %s annotate "%s"', last_id, annotation)
  local result = vim.fn.system(ann_cmd)

  if vim.v.shell_error == 0 then
    vim.notify(string.format("✅ Task %s annotated with %s", last_id, annotation), vim.log.levels.INFO)
  else
    vim.notify("❌ Failed to annotate task:\n" .. result, vim.log.levels.ERROR)
  end
end

return M
