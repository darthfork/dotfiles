-- init.lua - configuration file for Neovim

-- luacheck: globals vim

-- Set leader key
vim.g.mapleader = " "

-- Configuration Options
vim.opt.guicursor = ''
vim.opt.regexpengine = 2
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.colorcolumn = '120'
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
vim.opt.undodir = vim.fn.expand('$HOME/.config/nvim/undo/')
vim.opt.undolevels = 10000
vim.opt.undofile = true

-- Local variables
local pckr_path = vim.fn.stdpath('data') .. '/pckr/pckr.nvim'
local fzf_path = vim.fn.system('brew --prefix fzf'):gsub('\n', '')

-- Plugin manager setup
if not (vim.uv or vim.loop).fs_stat(pckr_path) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', 'https://github.com/lewis6991/pckr.nvim', pckr_path
  })
end

-- Runtime path configuration
vim.opt.rtp:prepend(pckr_path)
vim.opt.rtp:append(fzf_path)

-- Install plugins
require('pckr').add{
  'darthfork/git-blame.vim';
  'github/copilot.vim';
  'dense-analysis/ale';
  'junegunn/fzf.vim';
  'mhinz/vim-signify';
  {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};
  'MeanderingProgrammer/render-markdown.nvim';
  'akinsho/bufferline.nvim';
  'nvim-lualine/lualine.nvim';
  'nvim-tree/nvim-web-devicons';
}

-- Set colorscheme
vim.cmd('colorscheme retrobox')

-- Key mappings
vim.keymap.set('n', 'n', 'nzz', { noremap = true, silent = true , desc = 'Move to next search result' })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true, silent = true , desc = 'Move to previous search result' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move down a buffer' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move up a buffer' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move left a buffer' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move right a buffer' })
vim.keymap.set('n', '<C-n>', ':Lexplore<CR>', { noremap = true, silent = true , desc = 'Open netrw' })
vim.keymap.set('n', '<C-p>', ':FZF --bind ctrl-p:abort<CR>', { noremap = true, silent = true , desc = 'Find files' })
vim.keymap.set('n', '<C-b>', ':Buffers<CR>', { noremap = true, silent = true , desc = 'Show all open buffers' })
vim.keymap.set('n', '<C-t>', ':Tags <CR>', { noremap = true, silent = true , desc = 'Search through tags' })
vim.keymap.set('n', '<C-_>', ':Commands <CR>', { noremap = true, silent = true , desc = 'Show all available commands' })
vim.keymap.set('n', '<leader>gb', ':GitBlame<CR>', { silent = true , desc = 'Show Git Blame for current line' })
vim.keymap.set('n', '<leader>rg', ':RG<CR>', { silent = true , desc = 'Search through files with RipGrep' })
vim.keymap.set('n', '<leader>ht', ':Helptags<CR>', { silent = true , desc = 'Search Vim documentation' })

-- FZF configuration
vim.g.fzf_tags_command = 'ctags -R --exclude=.git --exclude=node_modules --exclude=.venv --exclude=.terraform'

-- ALE configuration
vim.g.ale_fix_on_save = 1
vim.g.ale_fixers = {
  ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
  go = { 'gofmt', 'goimports' },
  json = { 'jq' },
}

vim.g.ale_linters = {
  javascript = { 'eslint' },
  sh = { 'shellcheck' },
  go = { 'golangci-lint' },
  rust = { 'rustfmt' },
  python = { 'pylint' },
  bzl = { 'buildifier' },
}

-- Lualine configuration
require("lualine").setup{
  options = {
    icons_enabled = true,
    theme = 'codedark',
    component_separators = { left = '\\', right = '/'},
    section_separators = { left = '', right = '' },
  },
}

-- Bufferline configuration
require("bufferline").setup{
  options = {
    numbers = 'ordinal',
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    tab_size = 20,
    separator_style = 'slope',
  },
}

-- Treesitter configuration
require('nvim-treesitter.configs').setup{
  ensure_installed = {
    "bash", "c", "go", "helm", "json", "lua", "markdown", "python",
    "rust", "starlark", "terraform", "vim", "vimdoc", "yaml",
  },
  highlight = { enable = true },
}

-- Render Markdown configuration
require('render-markdown').setup({})

-- NetRW configuration
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = -28

-- Highlight Bad Whitespace
vim.api.nvim_set_hl(0, 'BadWhitespace', { ctermbg = 'red', bg = 'red' })

-- Filetype specific settings
vim.api.nvim_create_augroup('filetypesettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*', 'c', 'cpp', 'python', 'bash', 'rust' , 'starlark' },
    command = 'setlocal ai ts=4 sw=4 si sta et',
    group = 'filetypesettings',
  })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua', 'html', 'terraform', 'javascript', 'typescript', 'markdown', 'ruby', 'yaml' },
    command = 'setlocal ai ts=2 sw=2 si sta et',
    group = 'filetypesettings',
  })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'rst' },
    command = 'setlocal spell spelllang=en_us',
    group = 'filetypesettings',
  })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'make', 'go' },
    command = 'setlocal ai ts=8 sw=8 si sta noet list',
    group = 'filetypesettings',
  })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'Tiltfile', '*.tilt', 'BUILD', '*.bazel', 'WORKSPACE', '*.bzl' },
    command = 'set filetype=starlark',
    group = 'filetypesettings',
  })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'vimrc', 'init.lua' },
    command = 'setlocal keywordprg=:help',
    group = 'filetypesettings',
  })

-- Set relativenumber on buffer enter and insert leave
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {
    pattern = "*",
    command = "set relativenumber cursorline"
})
vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {
    pattern = "*",
    command = "set norelativenumber nocursorline"
})
