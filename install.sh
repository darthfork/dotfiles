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

# store docker images in /home/
echo "Configuring docker storage"
mkdir -p "$HOME/docker"
echo "{'data-root': '${HOME}/docker'}" > /etc/docker/daemon.json

# Install node16, yarn and coc
echo "Installing yarn"
npm install yarn
echo "Installing COC plugin"
pushd "$HOME/.vim/pack/plugins/start/coc.nvim/"; yarn install; popd

# setup tmux
echo "Copying tmux config"
cp -r .tmux.conf "$HOME/.tmux.conf"
# ex is exiting with exit code 1 for some reason. This needs to be done last to ensure install.sh works.
echo "Patching .tmux.conf to set default shell to zsh"
ex "$HOME/.tmux.conf" << HEREDOC
6 insert
set -g default-shell $(which zsh)
.
xit
HEREDOC
