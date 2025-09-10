-- lsp.lua - LSP configs for neovim

-- luacheck: globals vim

local M = {}
local lsp_keymaps = {}

-- Open next/previous diagnostic
local function open_diagnostic(direction)
  local count = direction == "next" and 1 or direction == "previous" and -1
  if not count then
    vim.notify("Invalid direction: " .. tostring(direction), vim.log.levels.ERROR)
    return
  end

  -- Check if there are any diagnostics before jumping
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify("No diagnostics found in current buffer", vim.log.levels.INFO)
    return
  end

  vim.diagnostic.jump({
    count = count,
    wrap = true,  -- Wrap around when reaching end/beginning
    on_jump = function()
      vim.diagnostic.open_float({
        focusable = false,
        border = "rounded"
      })
    end
  })
end

-- Show LSP info and keymaps in a popup
local function show_lsp_info()
  local lines = { "" }

  -- Get active LSP clients for current buffer
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 then
    table.insert(lines, "Active LSP Clients:")
    for _, client in ipairs(clients) do
      local status = "running"
      table.insert(lines, string.format("  • %s (%s)", client.name, status))
    end
    table.insert(lines, "")
  else
    table.insert(lines, "No active LSP clients")
    table.insert(lines, "")
  end

  -- Add diagnostics count
  local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warn_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local info_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  local hint_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

  table.insert(lines, "Diagnostics:")
  table.insert(lines, string.format("  Errors: %d", error_count))
  table.insert(lines, string.format("  Warnings: %d", warn_count))
  table.insert(lines, string.format("  Info: %d", info_count))
  table.insert(lines, string.format("  Hints: %d", hint_count))
  table.insert(lines, "")

  -- Add keymaps
  table.insert(lines, "LSP Keybindings:")
  for _, map in ipairs(lsp_keymaps) do
    local buffer_indicator = map.buffer and " (buffer)" or ""
    table.insert(lines, string.format("  %-12s  %s%s", map.key, map.desc, buffer_indicator))
  end

  -- Create a scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "help")

  -- Calculate window size
  local width = math.max(60, math.min(90, vim.api.nvim_get_option("columns") - 10))
  local height = math.min(#lines + 2, math.floor(vim.api.nvim_get_option("lines") * 0.8))

  -- Create floating window
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.api.nvim_get_option("columns") - width) / 2),
    row = math.floor((vim.api.nvim_get_option("lines") - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " LSP Info ",
    title_pos = "center"
  })

  -- Set up keymaps to close the window
  local opts = { buffer = buf, silent = true }
  vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", opts)
end


-- LSP keymap definitions
lsp_keymaps = {
  { mode = "n", key = "[d", func = function() open_diagnostic("previous") end, desc = "Previous diagnostic" },
  { mode = "n", key = "]d", func = function() open_diagnostic("next") end, desc = "Next diagnostic" },
  { mode = "i", key = "<C-space>", func = vim.lsp.completion.get, desc = "Trigger completion", buffer = true },
  { mode = "n", key = "<leader>d", func = vim.diagnostic.open_float, desc = "Open diagnostic float" },
  { mode = "n", key = "<leader>q", func = vim.diagnostic.setloclist, desc = "Diagnostic quickfix list" },
  { mode = "n", key = "<leader>D", func = vim.lsp.buf.type_definition, desc = "Type definition", buffer = true },
  { mode = "n", key = "<leader>rn", func = vim.lsp.buf.rename, desc = "Rename symbol", buffer = true },
  { mode = "n", key = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code action", buffer = true },
  { mode = "n", key = "<C-]>", func = vim.lsp.buf.definition, desc = "Go to definition", buffer = true },
  { mode = "n", key = "gr", func = vim.lsp.buf.references, desc = "References", buffer = true },
  { mode = "n", key = "gD", func = vim.lsp.buf.declaration, desc = "Go to declaration", buffer = true },
  { mode = "n", key = "gk", func = vim.lsp.buf.hover, desc = "Hover documentation", buffer = true },
  { mode = "n", key = "gi", func = vim.lsp.buf.implementation, desc = "Go to implementation", buffer = true },
  { mode = "n", key = "gK", func = vim.lsp.buf.signature_help, desc = "Signature help", buffer = true },
  { mode = "n", key = "<leader>l", func = show_lsp_info, desc = "Show LSP info", buffer = false }
}

-- LSP attach function
local function on_lsp_attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then return end

  -- Enable completion for all LSP servers
  vim.lsp.completion.enable(true, client.id, args.buf, {
    autotrigger = true,
    convert = function(item)
      return { abbr = item.label:gsub("%b()", "") }
    end,
  })

  -- Set up all keymaps dynamically
  for _, map in ipairs(lsp_keymaps) do
    local opts = { noremap = true, silent = true }
    if map.buffer then
      opts.buffer = args.buf
    end
    vim.keymap.set(map.mode, map.key, map.func, opts)
  end
end

-- Setup function to initialize LSP configuration
function M.setup(opts)
  opts = opts or {}
  local servers = opts.servers or {}

  -- Set up the LspAttach autocmd
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = on_lsp_attach
  })

  -- Enable all configured LSP servers
  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end
end

return M
