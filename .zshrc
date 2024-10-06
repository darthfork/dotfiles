ZSH_THEME="agnoster"
DEFAULT_USER=`whoami`
plugins=(
  zsh-syntax-highlighting
)

export TERM="xterm-256color"
export EDITOR="vim"
export AWS_PAGER=""
export GPG_TTY=$(tty)
export skip_global_compinit=1
export GOPATH=$HOME/.config/golang
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:$HOME/.local/bin:$GOPATH/bin:$PYENV_ROOT/bin"
export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --hidden -g "!{node_modules,.venv,.git}"'
export MANPAGER="vim -M +MANPAGER - "
export SHELLCHECK_OPTS="-e SC2155"
export VIRTUAL_ENV_DISABLE_PROMPT=1 # This allows agnoster to handle the venv prompt
export DOCKER_GROUP_ID=0

source $HOME/.oh-my-zsh/oh-my-zsh.sh
source start_ssh_agent.sh

# Enable completion for kubectl and aws
source <(kubectl completion zsh)
complete -C '$(command -v aws_completer)' aws

function aws_creds {
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
    export AWS_ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)
    export AWS_PROFILE="default"
}

alias virsh="virsh --connect qemu:///system"
alias tmux="tmux attach -t Base || tmux new -s Base"
alias tmuxb="tmux attach -t Alt || tmux new -s Alt"

eval "$(pyenv init -)"
eval "$(goenv init -)"
source <(fzf --zsh)
