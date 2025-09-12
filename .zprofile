#!/usr/bin/env zsh

# .zprofile - Zsh profile for sourcing shell utilities at login

# Cache brew shellenv for faster startup
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Start ssh agent
source $HOME/.local/bin/start_ssh_agent.sh

# Source language versions managers
[[ -z "$PYENV_SHELL" ]] && eval "$(command pyenv init -)"
[[ -z "$GOENV_SHELL" ]] && eval "$(command goenv init -)"
[[ -z "$NODENV_SHELL" ]] && eval "$(command nodenv init -)"
[[ -z "$RBENV_ROOT" ]] || [[ ":$PATH:" != *":$HOME/.rbenv/shims:"* ]] && eval "$(command rbenv init -)"
