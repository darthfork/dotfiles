-- go.lua - Go-specific LSP configuration

local lsp = require('lsp')

vim.lsp.start({
  name = 'gopls',
  cmd = {'gopls'},
  root_dir = vim.fs.dirname(vim.fs.find({'go.mod', '.git'}, { upward = true })[1]),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  on_attach = lsp.on_attach,
})
