-- lua.lua - Lua-specific LSP configuration

local LUA = {}

-- Configure Lua LSP server for Neovim configuration
function LUA.setup()
  local lsp = require('lsp')

  vim.lsp.start({
    name = 'lua_ls',
    cmd = {'lua-language-server'},
    root_dir = vim.fs.dirname(vim.fs.find({'.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git'}, { upward = true })[1]),
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
          disable = {"missing-parameters", "missing-fields"},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        hint = {
          enable = true,
        },
      },
    },
    on_attach = lsp.on_attach,
  })
end

return LUA
