-- lsp.lua - LSP configs for neovim

-- luacheck: globals vim

local M = {}

-- Open next/previous diagnostic
local function open_diagnostic(direction)
  local count = direction == 'next' and 1 or direction == 'previous' and -1
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
        border = 'rounded'
      })
    end
  })
end

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

  local opts = { noremap=true, silent=true }
  local bufopts = { noremap = true, silent = true, buffer = args.buf }

  -- Set up keymaps
  vim.keymap.set('n', '[d', function() open_diagnostic('previous') end, opts)
  vim.keymap.set('n', ']d', function() open_diagnostic('next') end, opts)
  vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, bufopts)
  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gk', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
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
