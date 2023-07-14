#!/usr/bin/env bash
# Installation script for Github codespaces and alike
set -eo pipefail

function usage(){
cat <<EOF
Usage: $0 [options]

--skip-brew | skip brew packages
--help      | show this help message
EOF
}

SKIP_BREW=0

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --skip-brew)
            SKIP_BREW=1
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
    esac
done

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
    install -m644 ./.zshrc "$HOME/.zshrc"

    printf "Setup agnoster theme\n"
    install -m644 .config/utils/agnoster-modifications.diff "$HOME/.oh-my-zsh/"
    pushd "$HOME/.oh-my-zsh/"; git apply agnoster-modifications.diff; popd

    printf "install zsh syntax completion\n"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
else
    printf "\n==================================\nzsh is not available\n==================================\n"
fi

# setup homebrew
if [ $SKIP_BREW -eq 0 ]; then
    if ! brew --version &> /dev/null ; then
        printf "Installing homebrew\n"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    printf "Installing homebrew packages\n"
    brew bundle
fi

# copy other configs and scripts (including tmux)
printf "Installing .local/bin and .config\n"
mkdir -p "$HOME/.local/bin" "$HOME/.config"
cp -r .config/ "$HOME/.config"
cp -r .local/bin/ "$HOME/.local/bin"
install -m644 .gitconfig "$HOME/.gitconfig"


# Install yarn and coc
if node --version &> /dev/null ; then
    printf "Installing yarn and coc.nvim\n"
    npm install yarn
    printf "Installing COC plugin\n"
    pushd "$HOME/.vim/pack/plugins/start/coc.nvim/"; yarn install; popd
fi

# Install fzf binding
printf "run \"\$(brew --prefix)/opt/fzf/install\" to install fzf keybindings\n"
