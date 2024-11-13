-- init.lua - Main configuration file for Neovim

vim.g.mapleader = ','

-- Configuration Options
vim.opt.guicursor = ''
vim.opt.rtp:append(vim.fn.system('brew --prefix fzf'):gsub('\n', ''))
vim.opt.regexpengine = 2
vim.opt.background = 'dark'
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.colorcolumn = '120'
vim.opt.encoding = 'utf-8'
vim.opt.keywordprg = ':Man'
vim.opt.laststatus = 3
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.wildmenu = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.smartcase = true

-- Persistent undo
if vim.fn.has('persistent_undo') == 1 then
  vim.opt.undodir = vim.fn.expand('$HOME/.config/nvim/undo/')
  vim.opt.undolevels = 10000
  vim.opt.undofile = true
end

-- Set colorscheme
vim.cmd('colorscheme retrobox')

-- Key mappings
vim.keymap.set('n', 'n', 'nzz', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<C-n>', ':Lexplore<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':FZF --bind ctrl-p:abort<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':Buffers<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', ':Tags <CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>g', ':GitBlame<CR>', { silent = true })

-- Command abbreviation
vim.cmd.cnoreabbrev('Ack', 'Ack!')

-- Plugin manager setup
local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath('data') .. '/pckr/pckr.nvim'
  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none', 'https://github.com/lewis6991/pckr.nvim', pckr_path
      })
  end
  vim.opt.rtp:prepend(pckr_path)
end

-- Bootstrap plugin manager
bootstrap_pckr()

-- Install plugins
require('pckr').add{
  'darthfork/git-blame.vim';
  'github/copilot.vim';
  'dense-analysis/ale';
  'junegunn/fzf.vim';
  'mhinz/vim-signify';
  'mileszs/ack.vim';
  'sheerun/vim-polyglot';
  'akinsho/bufferline.nvim';
  'nvim-lualine/lualine.nvim';
  'nvim-tree/nvim-web-devicons';
}

-- Lualine configurations
require("lualine").setup{
 options = {
    icons_enabled = true,
    theme = 'codedark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = '' },
  },
}

-- Bufferline configurations
require("bufferline").setup{
  options = {
    numbers = 'ordinal',
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    tab_size = 20,
    separator_style = 'slant',
  },
}

-- Plugin configurations
vim.g.fzf_tags_command = 'ctags -R --exclude=.git --exclude=node_modules --exclude=docs --exclude=.venv --exclude=.terraform'
vim.g.go_def_mapping_enabled = 0
vim.g.fzf_layout = { down = '40%' }
vim.g.ackprg = 'rg --vimgrep --type-not sql --smart-case'
vim.g.ack_autoclose = 1
vim.g.ack_use_cword_for_empty_search = 1
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

-- NetRW Settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = -28

-- Filetype-specific settings
vim.api.nvim_set_hl(0, 'BadWhitespace', { ctermbg = 'red', bg = 'red' })
vim.api.nvim_create_augroup('filetypesettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*', -- Default settings
    command = 'setlocal ai ts=4 sw=4 si sta et',
    group = 'filetypesettings',
  })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'python', 'bash', 'rust' },
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
    pattern = { 'Tiltfile', '*.tilt' },
    command = 'set filetype=bzl',
    group = 'filetypesettings',
  })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'vimrc', 'init.lua' },
    command = 'setlocal keywordprg=:help',
    group = 'filetypesettings',
  })
