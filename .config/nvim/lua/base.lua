-- base.lua - base neovim configuration

-- luacheck: globals vim

-- Set leader key
vim.g.mapleader = " "

-- Configuration Options
vim.opt.guicursor = ""
vim.opt.regexpengine = 2
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.colorcolumn = "120"
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.fillchars = { eob = " " }
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("$HOME/.config/nvim/undo/")
vim.opt.undolevels = 10000
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.completeopt = { "menuone", "fuzzy", "noselect", "popup", "preview" }

-- Runtime path configuration
vim.opt.rtp:append(vim.fn.system("brew --prefix fzf"):gsub("\n", ""))

-- Key mappings
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true, desc = "Move to next search result" })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true, desc = "Move to previous search result" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Move down a buffer" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Move up a buffer" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Move left a buffer" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Move right a buffer" })
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { noremap = true, silent = true, desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<C-p>", ":FZF --bind ctrl-p:abort<CR>", { noremap = true, silent = true, desc = "Find files" })
vim.keymap.set("n", "<C-b>", ":Buffers<CR>", { noremap = true, silent = true, desc = "Search open buffers" })
vim.keymap.set("n", "<C-f>", ":RG<CR>", { silent = true, desc = "Search through files with RipGrep" })
vim.keymap.set("n", "<C-t>", ":Tags <CR>", { noremap = true, silent = true, desc = "Search through tags" })
vim.keymap.set("n", "<C-_>", ":Commands <CR>", { noremap = true, silent = true, desc = "Search available commands" })
vim.keymap.set("n", "<leader>gb", ":GitBlame<CR>", { silent = true, desc = "Show Git Blame for current line" })
vim.keymap.set("n", "<leader>ht", ":Helptags<CR>", { silent = true, desc = "Search Vim documentation" })
vim.keymap.set("n", "<leader>cc", ":ClaudeCodeResume<CR>", { noremap = true, silent = true, desc = "Resume Claude" })

-- Filetype specific settings
vim.api.nvim_create_augroup("filetypesettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", { -- Default for all filetypes including c/cpp, python, bash etc.
  pattern = { "*" },
  command = "setlocal ai ts=4 sw=4 si sta et",
  group = "filetypesettings",
})
vim.api.nvim_create_autocmd("FileType", { -- Override tabstop to 2 spaces for lua, ruby etc.
  pattern = { "lua", "html", "terraform", "javascript", "typescript", "markdown", "ruby", "yaml" },
  command = "setlocal ai ts=2 sw=2 si sta et",
  group = "filetypesettings",
})
vim.api.nvim_create_autocmd("FileType", { -- Use tabs instead of spaces for golang and Makefiles
  pattern = { "make", "go" },
  command = "setlocal ai ts=8 sw=8 si sta noet list",
  group = "filetypesettings",
})
vim.api.nvim_create_autocmd("FileType", { -- Enable spellcheck for markdown and rst
  pattern = { "markdown", "rst" },
  command = "setlocal spell spelllang=en_us",
  group = "filetypesettings",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { -- Set filetype to startlark for bazel and tilt
  pattern = { "Tiltfile", "*.tilt", "BUILD", "*.bazel", "WORKSPACE", "*.bzl" },
  command = "set filetype=starlark",
  group = "filetypesettings",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { -- Set keywordprg to :help for vim and neovim configs
  pattern = { "vimrc", "init.lua" },
  command = "setlocal keywordprg=:help",
  group = "filetypesettings",
})
