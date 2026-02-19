local function ytfzf_search()
  if vim.fn.executable("yt-dlp") ~= 1 or vim.fn.executable("jq") ~= 1 then
    vim.notify("yt-dlp and jq are required for YT search", vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = "YouTube search: " }, function(query)
    if not query or query == "" then
      return
    end

    local limit = tonumber(vim.env.YTFZF_LIMIT or "20") or 20
    local jq = [[. as $v | "\($v.title // "?")\t\($v.channel // $v.uploader // "?")\t\($v.duration_string // "??")\t\($v.upload_date // "")\t\($v.view_count // "?")\thttps://youtu.be/\($v.id)"]]
    local cmd = string.format(
      "yt-dlp --flat-playlist --dump-json %s | jq -r '%s'",
      vim.fn.shellescape("ytsearch" .. limit .. ":" .. query),
      jq
    )
    local lines = vim.fn.systemlist(cmd)
    if #lines == 0 then
      vim.notify("No results from yt-dlp", vim.log.levels.WARN)
      return
    end

    local function preview_line(args)
      local line = args[1]
      if not line or line == "" then
        return ""
      end
      local parts = vim.split(line, "\t", { plain = true })
      local title = parts[1] or ""
      local channel = parts[2] or "?"
      local duration = parts[3] or "??"
      local upload_date = parts[4] or ""
      local views = parts[5] or "?"
      local url = parts[6] or ""

      if #upload_date == 8 then
        upload_date = upload_date:sub(1, 4) .. "-" .. upload_date:sub(5, 6) .. "-" .. upload_date:sub(7, 8)
      end

      return table.concat({
        title,
        "",
        "Channel: " .. channel,
        "Duration: " .. duration,
        "Date: " .. (upload_date ~= "" and upload_date or "?"),
        "Views: " .. views,
        "",
        url,
      }, "\n")
    end

    local bind_open = "enter:execute-silent(bash -c 'if command -v mpv >/dev/null 2>&1; then mpv \"$1\" >/dev/null 2>&1 & else printf \"%s\\n\" \"mpv not found; URL: $1\" > /dev/tty; fi' _ {6})"
    local bind_open_alt = "ctrl-p:execute-silent(bash -c 'if command -v mpv >/dev/null 2>&1; then mpv \"$1\" >/dev/null 2>&1 & else printf \"%s\\n\" \"mpv not found; URL: $1\" > /dev/tty; fi' _ {6})"
    local bind_dl = "ctrl-d:execute(bash -c 'yt-dlp \"$1\"' _ {6})"
    local bind_copy = "ctrl-y:execute-silent(bash -c 'if command -v wl-copy >/dev/null 2>&1; then printf \"%s\" \"$1\" | wl-copy; elif command -v xclip >/dev/null 2>&1; then printf \"%s\" \"$1\" | xclip -selection clipboard; elif command -v xsel >/dev/null 2>&1; then printf \"%s\" \"$1\" | xsel --clipboard --input; elif command -v pbcopy >/dev/null 2>&1; then printf \"%s\" \"$1\" | pbcopy; else printf \"%s\\n\" \"$1\" > /dev/tty; fi' _ {6})"

    require("fzf-lua").fzf_exec(lines, {
      prompt = "yt> ",
      preview = preview_line,
      winopts = {
        preview = {
          layout = "vertical",
          vertical = "right:60%",
        },
      },
      fzf_opts = {
        ["--delimiter"] = "\t",
        ["--with-nth"] = "1,2,3",
        ["--bind"] = table.concat({ bind_open, bind_open_alt, bind_dl, bind_copy }, ","),
      },
    })
  end)
end

return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>yt", ytfzf_search, desc = "YouTube search (yt-dlp + fzf)" },
  },
}
