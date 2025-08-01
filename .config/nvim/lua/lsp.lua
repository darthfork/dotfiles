-- lsp.lua - Basic LSP configuration and utilities shared by all language servers

local LSP = {}

-- Common LSP attach function - called when any LSP attaches to buffer
function LSP.on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- LSP keymaps
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
    vim.tbl_extend('force', opts, { desc = 'Code action' }))
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format { async = true }
  end, vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Go to references' }))
  vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type definition' }))

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end



-- Main setup function for basic LSP functionality
function LSP.setup()

  -- Configure diagnostic display
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      source = 'if_many',
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '✘',
        [vim.diagnostic.severity.WARN] = '▲',
        [vim.diagnostic.severity.HINT] = '⚑',
        [vim.diagnostic.severity.INFO] = '»',
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = true,
      header = '',
      prefix = '',
    },
  })

  -- Enable built-in completion
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

  -- Set up completion keymaps
  vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = 'Trigger LSP completion' })

  -- Optional: Auto-trigger completion on certain characters
  vim.api.nvim_create_autocmd('InsertCharPre', {
    callback = function()
      local char = vim.v.char
      if char == '.' or char == ':' then
        vim.schedule(function()
          vim.cmd('doautocmd InsertEnter')
        end)
      end
    end,
  })

  -- Remove trailing whitespace on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e"
  })

  -- Attach go lsp
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
      require('go')
    end,
    desc = 'Setup Go LSP'
  })

  -- Attach lua lsp
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function()
      require('lua')
    end,
    desc = 'Setup Lua LSP'
  })

  -- Attach python lsp
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
      require('python')
    end,
    desc = 'Setup Python LSP'
  })
end

return LSP
