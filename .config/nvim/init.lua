-- init.lua - configuration file for Neovim

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
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- Runtime path configuration
vim.opt.rtp:append(vim.fn.system("brew --prefix fzf"):gsub("\n", ""))

-- Install plugins
vim.pack.add({
  "https://github.com/darthfork/git-blame.vim",
  "https://github.com/junegunn/fzf.vim",
  "https://github.com/mhinz/vim-signify",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/greggh/claude-code.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/dense-analysis/ale",
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/rebelot/kanagawa.nvim",
})

-- Set colorscheme
vim.cmd("colorscheme kanagawa-dragon")

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

-- Claude configuration
require("claude-code").setup({
  window = {
    split_ratio = 0.3,
    position = "vertical",
    enter_insert = true,
    hide_numbers = true,
    hide_signcolumn = true
  },
  command = "claude",
  git = {
    use_git_root = true,
  },
})

-- ALE configuration
vim.g.ale_fix_on_save = 1
vim.g.ale_echo_msg_format = "[%linter%] %code: %%s [%severity%]"

vim.g.ale_fixers = {
  ["*"] = { "remove_trailing_lines", "trim_whitespace" },
  go = { "gofmt", "goimports" },
  json = { "jq" },
  python = { "ruff_format" },
  ruby = { "rubocop" },
  terraform = { "terraform" },
}

vim.g.ale_linters = {
  bzl = { "buildifier" },
  dockefile = { "hadolint" },
  go = { "golangci-lint" },
  javascript = { "eslint" },
  lua = { "luacheck" },
  python = { "ruff" },
  ruby = { "rubocop" },
  rust = { "rustfmt" },
  sh = { "shellcheck" },
  terraform = { "tflint" },
  yaml = { "yamllint" },
}

-- FZF configuration
vim.g.fzf_tags_command = "ctags -R --exclude=.git --exclude=node_modules --exclude=.venv --exclude=.terraform"

-- Lualine configuration
require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "codedark",
    component_separators = { left = "╲", right = "╱" },
    section_separators = { left = "", right = "" },
  },
}

-- Bufferline configuration
require("bufferline").setup {
  options = {
    numbers = "ordinal",
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    tab_size = 20,
    separator_style = "slope",
  },
}


-- Treesitter configuration
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash", "c", "go", "helm", "html", "json", "latex", "lua", "markdown",
    "python", "rust", "starlark", "terraform", "vim", "vimdoc", "yaml",
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
  },
}

-- Render Markdown configuration
require("render-markdown").setup({})

-- Neo-tree configuration
require("neo-tree").setup({
  close_if_last_window = false,
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})

-- Setup LSP
require("lsp").setup({
  servers = { "gopls", "pylsp", "terraformls" }
})

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
vim.api.nvim_create_autocmd("FileType", { -- Enable spellcheck for markdown and rst
  pattern = { "markdown", "rst" },
  command = "setlocal spell spelllang=en_us",
  group = "filetypesettings",
})
vim.api.nvim_create_autocmd("FileType", { -- Use tabs instead of spaces for golang and Makefiles
  pattern = { "make", "go" },
  command = "setlocal ai ts=8 sw=8 si sta noet list",
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
