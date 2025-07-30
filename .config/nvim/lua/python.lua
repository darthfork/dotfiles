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
        pycodestyle = { enabled = true },
        pyflakes = { enabled = true },
        pylint = { enabled = true },

        -- Code formatting
        autopep8 = { enabled = true },
        black = { enabled = false }, -- Enable for black

        -- Import sorting
        isort = { enabled = true },

        -- Type checking
        mypy = { enabled = false }, -- Enable for mypy

        -- Completion and hover
        jedi_completion = {
          enabled = true,
          include_params = true,
        },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true },

        -- Rope for refactoring
        rope_completion = { enabled = false },
        rope_autoimport = { enabled = false },
      },
    },
  },
  on_attach = lsp.on_attach,
})
