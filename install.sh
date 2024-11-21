#!/usr/bin/env bash

# install.sh: A script to install and configure dotfiles, tools and utilities

set -euo pipefail

# Create directories
printf "Creating configuration directories...\n"
mkdir -p "$HOME/.vim"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/utils"
mkdir -p "$HOME/.config/yamllint"

# Symlink configuration files for vim, neovim, shell, tmux, alacritty and other tools
printf "Symlinking vim, neovim, shell, tmux, alacritty and other configuration files...\n"
ln -s ".zshrc" "$HOME/.zshrc"
ln -s ".gitconfig" "$HOME/.gitconfig"
ln -s ".vim/vimrc" "$HOME/.vim/vimrc"
ln -s ".config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -s ".config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -s ".config/tmux/vscode.conf" "$HOME/.config/tmux/vscode.conf"
ln -s ".config/utils/compose.yaml" "$HOME/.config/utils/compose.yaml"
ln -s ".config/utils/kubernetes.yaml" "$HOME/.config/utils/kubernetes.yaml"
ln -s ".config/utils/agnoster-modifications.diff" "$HOME/.config/utils/agnoster-modifications.diff"
ln -s ".config/yamllint/config" "$HOME/.config/yamllint/config"

# Install utility scripts and kubernetes plugins
printf "Install Utility scripts and kubernetes plugins...\n"
install -m755 ".local/bin/*" "$HOME/.local/bin"

# Setup homebrew
printf "Installing homebrew...\n"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install homebrew packages
printf "Installing homebrew packages...\n"
brew bundle

# Install oh-my-zsh
printf "Removing existing oh-my-zsh installation if any...\n"
rm -rf "$HOME/.oh-my-zsh"
printf "Installing oh-my-zsh...\n"
bash -c "$(curl -fssl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Apply agnoster theme changes
printf "Applying agnoster theme changes...\n"
cp ".config/utils/agnoster-modifications.diff" "$HOME/.oh-my-zsh/"
pushd "$HOME/.oh-my-zsh/" || exit
git apply agnoster-modifications.diff
rm agnoster-modifications.diff
popd || exit

# Install zsh syntax completion
printf "Installing zsh syntax completion...\n"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git\
    "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
