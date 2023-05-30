ZSH_THEME="agnoster"
DEFAULT_USER=`whoami`
plugins=(
  zsh-syntax-highlighting
)

export TERM="xterm-256color"
export EDITOR="vim"
export AWS_PAGER=""
export GPG_TTY=$(tty)
# Linux specific customizations
if [[ "$(uname)" -eq "Linux" ]];
then
    alias open="xdg-open"
    export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin"
fi;
export GOPATH=$HOME/.config/golang
export PATH="$PATH:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin"
export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --hidden -g "!{node_modules,.venv,.git}"'
export SHELLCHECK_OPTS="-e SC2155"
export VIRTUAL_ENV_DISABLE_PROMPT=1 # This allows agnoster to handle the venv prompt
export LPASS_AGENT_TIMEOUT=28800

source $HOME/.oh-my-zsh/oh-my-zsh.sh
source start_ssh_agent.sh

# quick namespace switcher
function set-ns {
  kubectl config set-context --current --namespace="$@"
}

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
alias tmux="tmux attach -t Base || tmux new -s Base"
alias tmuxb="tmux attach -t Alt || tmux new -s Alt"

test -e "${HOME}/.fzf.zsh" && source "${HOME}/.fzf.zsh"
