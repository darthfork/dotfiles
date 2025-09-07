-- plugins.lua - Plugin configurations

-- luacheck: globals vim

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
