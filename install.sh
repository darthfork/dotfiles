#!/usr/bin/env bash

# Installation script for Github codespaces and alike

# setup vim
if vim --version &> /dev/null ; then
    cp -r .vim/ "$HOME/.vim"
else
    printf "==================================\nvim is not available\n==================================\n"
fi

# setup tmux
if tmux -v &> /dev/null ; then
    cp -r .tmux.conf "$HOME/.tmux.conf"
else
    printf "==================================\ntmux is not available\n==================================\n"
fi

# setup zsh
if zsh --version &> /dev/null ; then
    # change default shell to zsh assuming passwordless sudo
    chsh -s "$(which zsh)" "$USER"
    # install oh-my-zsh
    sh -c "$(curl -fssl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # copy my zshrc to HOME
    cp ./.zshrc "$HOME/.zshrc"
    # copy my clone of agnoster theme
    cp .config/zsh-themes/agnoster.zsh-theme "$HOME/.oh-my-zsh/themes/agnoster.zsh-theme"
else
    printf "==================================\nzsh is not available\n==================================\n"
fi

# copy other configs and scripts
mkdir -p "$HOME/.local/bin" "$HOME/.config"
cp -r .config/ "$HOME/.config"
cp -r .local/bin/ "$HOME/.local/bin"
cp .gitconfig "$HOME/.gitconfig"
