-- init.lua - configuration file for Neovim

-- Setup base configuration
require("base")

-- Setup plugins
require("plugins")

-- Setup LSP
require("lsp").setup({
  servers = { "gopls", "pylsp", "terraformls" , "zls" }
})
