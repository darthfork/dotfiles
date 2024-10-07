vim.g.mapleader = ","

vim.filetype.plugin = true
vim.filetype.indent = true

vim.cmd.runtime('ftplugin/man.vim')

vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'

vim.cmd('syntax enable')

-- Converted configurations
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

if vim.fn.has('persistent_undo') == 1 then
    vim.opt.undodir = vim.fn.expand('$HOME/.vim/undo')
    vim.opt.undolevels = 10000
    vim.opt.undofile = true
end

-- Set colorscheme
vim.cmd('colorscheme retrobox')

-- Key mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', 'n', 'nzz', opts)
map('n', 'N', 'Nzz', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<C-n>', ':Lexplore<CR>', opts)
map('n', '<C-p>', ':FZF --bind ctrl-p:abort<CR>', opts)
map('n', '<C-b>', ':Buffers<CR>', opts)
map('n', '<C-t>', ':Tags <CR>', opts)
map('n', '<leader>rw', ':%s/\\s\\+$//e<CR>', opts)
map('n', '<leader>g', ':GitBlame<CR>', opts)

-- Command abbreviation
vim.cmd.cnoreabbrev('Ack', 'Ack!')

-- Plugin manager setup (packer.nvim)
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Plugins
    use 'mileszs/ack.vim'
    use 'mhinz/vim-signify'
    use 'dense-analysis/ale'
    use 'junegunn/fzf'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'ryanoasis/vim-devicons'
    use 'nvim-treesitter/nvim-treesitter'
    use 'hashivim/vim-terraform'

    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Plugin configurations
vim.g.airline_theme = 'hybridline'
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

-- Highlight BadWhitespace
vim.api.nvim_set_hl(0, 'BadWhitespace', { ctermbg = 'red', bg = 'red' })

-- Filetype-specific settings
vim.api.nvim_create_augroup('filetypesettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'python', 'bash', 'rust' },
    command = 'setlocal ai ts=4 sw=4 si sta et',
    group = 'filetypesettings',
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'html', 'javascript', 'typescript', 'markdown', 'ruby', 'yaml' },
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
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'terraform' },
    command = 'packadd vim-terraform | setlocal ai ts=2 sw=2 si sta et',
    group = 'filetypesettings',
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'Tiltfile', '*.tilt' },
    command = 'set filetype=bzl',
    group = 'filetypesettings',
})
