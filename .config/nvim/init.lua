vim.g.mapleader = ","
vim.filetype.plugin = true
vim.filetype.indent = true
vim.cmd.runtime('ftplugin/man.vim')
vim.cmd('colorscheme retrobox')
vim.cmd('syntax enable')
vim.opt.rtp:append('/opt/homebrew/opt/fzf')

-- Load custom functions
require("GitBlame")

-- Configuration Options
vim.opt.guicursor = ''
vim.opt.regexpengine = 2
vim.opt.background = 'dark'
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.colorcolumn = '120'
vim.opt.encoding = 'utf-8'
vim.opt.keywordprg = ':Man'
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.splitright = true
vim.opt.compatible = false
vim.opt.swapfile = false
vim.opt.wildmenu = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Persistent undo
if vim.fn.has('persistent_undo') == 1 then
    vim.opt.undodir = vim.fn.expand('$HOME/.config/nvim/undo/')
    vim.opt.undolevels = 10000
    vim.opt.undofile = true
end

-- Key mappings
vim.api.nvim_set_keymap('n', 'n', 'nzz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':Lexplore<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':FZF --bind ctrl-p:abort<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-b>', ':Buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':Tags <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rw', ':%s/\\s\\+$//e<CR>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Leader>g', ':GitBlame<CR>', { silent = true })

-- Command abbreviation
vim.cmd.cnoreabbrev('Ack', 'Ack!')

-- Plugin manager setup
local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system({
      'git', 'clone', "--filter=blob:none", 'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end
  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
    'dense-analysis/ale';
    'junegunn/fzf.vim';
    'mhinz/vim-signify';
    'mileszs/ack.vim';
    'ryanoasis/vim-devicons';
    'sheerun/vim-polyglot';
    'vim-airline/vim-airline';
    'vim-airline/vim-airline-themes';
}

-- Plugin configurations
vim.g.airline_theme = 'hybridline'
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#fnamemod'] = ':t'
vim.g['airline#extensions#tabline#tab_nr_type'] = 1
vim.g.fzf_tags_command = 'ctags -R --exclude=.git --exclude=node_modules --exclude=docs --exclude=.venv --exclude=.terraform'
vim.g.go_def_mapping_enabled = 0
vim.g.fzf_layout = { down = '40%' }
vim.g.ackprg = 'rg --vimgrep --type-not sql --smart-case'
vim.g.ack_autoclose = 1
vim.g.ack_use_cword_for_empty_search = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_fixers = {
    ['*'] = { 'remove_trailing_lines', 'trim_whitespace' }
}
vim.g.ale_linters = {
    javascript = { 'eslint' },
    sh = { 'shellcheck' },
    go = { 'golangci-lint' },
    rust = { 'rustfmt' },
    python = { 'pylint' }
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
    pattern = { 'c', 'cpp', 'python', 'bash', 'rust' },
    command = 'setlocal ai ts=4 sw=4 si sta et',
    group = 'filetypesettings',
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'html', 'terraform', 'javascript', 'typescript', 'markdown', 'ruby', 'yaml' },
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
