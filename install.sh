#!/usr/bin/env bash
# Installation script for Github codespaces and alike

set -eo pipefail

# Pull in submoduled vim plugins
git submodule update --init --recursive

# setup vim
printf "Copying vim config\n"
cp -r .vim/ "$HOME/.vim"

# setup zsh
printf "Setup shell\n"
if zsh --version &> /dev/null ; then
    printf "install oh-my-zsh\n"
    bash -c "$(curl -fssl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    printf "copy my zshrc to \$HOME\n"
    cp ./.zshrc "$HOME/.zshrc"

    printf "Setup agnoster theme\n"
    cp .config/zsh-themes/agnoster-modifications.diff "$HOME/.oh-my-zsh/"
    pushd "$HOME/.oh-my-zsh/"; git apply agnoster-modifications.diff; popd

    printf "install zsh syntax completion\n"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
else
    printf "\n==================================\nzsh is not available\n==================================\n"
fi

# setup homebrew
if ! brew --version &> /dev/null ; then
    printf "Installing homebrew\n"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

printf "Installing homebrew packages\n"
brew bundle

# copy other configs and scripts
printf "Installing .local/bin and .config\n"
mkdir -p "$HOME/.local/bin" "$HOME/.config"
cp -r .config/ "$HOME/.config"
cp -r .local/bin/ "$HOME/.local/bin"
cp .gitconfig "$HOME/.gitconfig"

# setup tmux
printf "Copying tmux config\n"
cp -r .tmux.conf "$HOME/.tmux.conf"

# Install yarn and coc
if node --version &> /dev/null ; then
    printf "Installing yarn and coc.nvim\n"
    npm install yarn
    printf "Installing COC plugin\n"
    pushd "$HOME/.vim/pack/plugins/start/coc.nvim/"; yarn install; popd
fi

# Install fzf binding
printf "run \"\$(brew --prefix)/opt/fzf/install\" to install fzf keybindings\n"
