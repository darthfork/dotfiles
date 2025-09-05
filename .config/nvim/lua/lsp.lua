-- lsp.lua - LSP configs for neovim

-- luacheck: globals vim

local M = {}

-- Common LSP attach function
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

  -- Set up keymaps
  vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { buffer = args.buf, desc = "trigger autocompletion" })
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
