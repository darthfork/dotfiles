#!/usr/bin/env zsh

# .zprofile - Zsh profile for sourcing shell utilities at login

# Cache brew shellenv for faster startup
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#Source FZF
source <(fzf --zsh)

# Lazy load pyenv
pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
}

# Lazy load goenv
goenv() {
    unset -f goenv
    eval "$(command goenv init -)"
    goenv "$@"
}

# Lazy load nodenv
nodenv() {
    unset -f nodenv
    eval "$(command nodenv init -)"
    nodenv "$@"
}

# Lazy load rbenv
rbenv() {
    unset -f rbenv
    eval "$(command rbenv init -)"
    rbenv "$@"
}
