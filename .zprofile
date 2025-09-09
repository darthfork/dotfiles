#!/usr/bin/env zsh

# .zprofile - Zsh profile for sourcing shell utilities at login

# Cache brew shellenv for faster startup
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#Source FZF
source <(fzf --zsh)

# Source language versions managers
eval "$(command pyenv init -)"
eval "$(command goenv init -)"
eval "$(command nodenv init -)"
eval "$(command rbenv init -)"
