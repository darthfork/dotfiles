-- lsp.lua - LSP configs for neovim

-- luacheck: globals vim

-- Setup LSP for golang
require("lspconfig")["gopls"].setup({
  on_attach = function(client, bufnr)
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })
    vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
  end
})
