#!/usr/bin/env zsh

# .zprofile - Zsh profile for sourcing shell utilities at login

# XDG Base Directory Specification
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share

# GPG configuration
export GNUPGHOME="$XDG_CONFIG_HOME/gpg"

# Cache brew shellenv for faster startup
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Start ssh agent
source $HOME/.local/bin/start_ssh_agent.sh

# Enable tab completion
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

# Source language versions managers
eval "$(command pyenv init -)"
eval "$(command goenv init -)"
eval "$(command nodenv init -)"
[[ ":$PATH:" != *":$HOME/.rbenv/shims:"* ]] && eval "$(command rbenv init -)"
