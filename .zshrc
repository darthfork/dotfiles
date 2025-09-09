#!/usr/bin/env zsh

# .zshrc - Zsh configuration file

ZSH_THEME="agnoster"
DEFAULT_USER=$(whoami)
plugins=(
  zsh-syntax-highlighting
)

export EDITOR="nvim"
export AWS_PAGER=""
export GPG_TTY=$(tty)
export skip_global_compinit=1
export PATH="$PATH:$HOME/.local/bin"
export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --hidden -g "!{node_modules,.venv,.git}"'
export FZF_DEFAULT_OPTS="--tmux --layout=reverse --border"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
export MANPAGER="nvim +Man!"
export SHELLCHECK_OPTS="-e SC2155 -e SC1008 -e SC2181 -e SC1091"
export VIRTUAL_ENV_DISABLE_PROMPT=1 # This allows agnoster to handle the venv prompt

source $HOME/.oh-my-zsh/oh-my-zsh.sh
source start_ssh_agent.sh

#Source FZF
source <(fzf --zsh)

alias vim="nvim"
alias vimdiff="nvim -d"
alias tmux="tmux attach -t Base || tmux new -s Base"


# Use ~/.zshenv for secrets and system specific aliases
