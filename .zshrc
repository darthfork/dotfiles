export ZSH="$HOME/.oh-my-zsh"
export TERM="xterm-256color"
export EDITOR="vim"
export AWS_PAGER=""

ZSH_THEME="agnoster"
DEFAULT_USER=`whoami`
plugins=(
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Default path for linux machines
# export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin"

if [[ -d $HOME/.local/bin ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi;

if [[ -d $HOME/workspace/go ]]; then
    export GOPATH=$HOME/workspace/go
fi;

source start_ssh_agent.sh

function add_keys {
    ssh-add ~/.ssh/id_rsa ~/.ssh/*.pem
}

function aws_creds {
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
    export AWS_ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)
    export AWS_PROFILE="default"
}

alias virsh="virsh --connect qemu:///system"
alias man="$HOME/.local/bin/cool_man"
alias tmux="tmux attach -t Base || tmux new -s Base"
alias tmuxb="tmux attach -t Alt || tmux new -s Alt"

if [[ "$(uname)" -eq "Linux" ]];
then
    alias open="xdg-open"
fi;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
