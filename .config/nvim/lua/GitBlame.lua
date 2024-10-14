local function GitBlame()
  -- Get the current file path
  local file_path = vim.fn.resolve(vim.fn.expand("%:p"))
  local dir_path = vim.fn.fnamemodify(file_path, ":h")

  -- Get the current visual selection or current line
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")

  -- Run the git log command with systemlist
  local cmd = string.format("cd %s && git log --no-merges -n 1 -L %s,%s:%s", vim.fn.shellescape(dir_path), vim.fn.shellescape(start_line), vim.fn.shellescape(end_line), file_path)
  local output = vim.fn.systemlist(cmd)

  -- Ensure there is content to display
  if #output == 0 then
    vim.notify("No Git blame information found", vim.log.levels.INFO)
    return
  end

  -- Create a buffer for the floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

  -- Calculate the maximum line width for proper window sizing
  local max_width = 0
  for _, line in ipairs(output) do
    local line_len = vim.fn.strdisplaywidth(line)
    if line_len > max_width then
      max_width = line_len
    end
  end

  -- Set window dimensions based on content size
  local width = math.min(max_width, vim.o.columns - 4)  -- Limit width to fit the screen
  local height = math.min(#output, vim.o.lines - 4)  -- Limit height to fit the screen

  -- Configure the floating window options
  local opts = {
    relative = "cursor",
    row = 1,
    col = 1,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",  -- Rounded border around the floating window
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set the filetype of the floating window to "git"
  vim.api.nvim_buf_set_option(buf, "filetype", "git")

  -- Set an autocmd to close the window when any key is pressed
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,  -- The autocmd should run only once
    callback = function()
      vim.api.nvim_win_close(win, true)  -- Close the floating window
    end
  })

  -- Optionally set a key mapping to close the window with <Esc>
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':lua vim.api.nvim_win_close(' .. win .. ', true)<CR>', { noremap = true, silent = true })
end

-- Create a command to trigger GitBlame function
vim.api.nvim_create_user_command("GitBlame", GitBlame, {})
