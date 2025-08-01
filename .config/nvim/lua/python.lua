-- python.lua - Python-specific LSP configuration

local lsp = require('lsp')

vim.lsp.start({
  name = 'pylsp',
  cmd = { 'pylsp' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    { upward = true })[1]),
  settings = {
    pylsp = {
      plugins = {
        -- Linting
        ruff = { enabled = true },
        pylint = { enabled = false }, -- Enable if ruff can't be installed

        -- Code formatting
        black = { enabled = true },

        -- Import sorting
        isort = { enabled = true },

        -- Type checking
        mypy = { enabled = true },

        -- Completion and hover
        jedi_completion = {
          enabled = true,
          include_params = true,
        },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true },
      },
    },
  },
  on_attach = lsp.on_attach,
})
