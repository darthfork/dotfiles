#!/usr/bin/env bash

set -eo pipefail

# Installation script for Github codespaces and alike

# Pull in submoduled vim plugins
git submodule update --init --recursive

# setup vim
echo "Copying vim config"
cp -r .vim/ "$HOME/.vim"

# setup zsh
echo "Installing oh-my-zsh"
if zsh --version &> /dev/null ; then
    # install oh-my-zsh
    sh -c "$(curl -fssl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # copy my zshrc to HOME
    cp ./.zshrc "$HOME/.zshrc"
    # copy my clone of agnoster theme
    cp .config/zsh-themes/agnoster.zsh-theme "$HOME/.oh-my-zsh/themes/agnoster.zsh-theme"
    # install zsh syntax completion
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

else
    printf "==================================\nzsh is not available\ninstall it manually\n==================================\n"
fi

# copy other configs and scripts
echo "Installing .local/bin and .config"
mkdir -p "$HOME/.local/bin" "$HOME/.config"
cp -r .config/ "$HOME/.config"
cp -r .local/bin/ "$HOME/.local/bin"
cp .gitconfig "$HOME/.gitconfig"

# Install yarn and coc
echo "Installing yarn and coc.nvim"
npm install yarn
echo "Installing COC plugin"
pushd "$HOME/.vim/pack/plugins/start/coc.nvim/"; yarn install; popd

# setup tmux
echo "Copying tmux config"
cp -r .tmux.conf "$HOME/.tmux.conf"
