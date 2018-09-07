if [ "$(uname)" == "Linux" ]; then
    export HOME="/home/arai"
elif [ "$(uname)" == "Darwin" ]; then
    export HOME="/Users/arai"
fi;
export ZSH="$HOME/.oh-my-zsh"
export TERM='xterm-256color'
export EDITOR='vim'

ZSH_THEME="agnoster"
DEFAULT_USER=`whoami`
plugins=(
  git
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source $HOME/.start_ssh_agent.sh

# User specific environment and startup programs
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin"

if [[ -d $HOME/.local/bin ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi;

if [[ -d $HOME/workspace/go ]]; then
    export GOPATH=$HOME/workspace/go
fi;

if [[ -d $HOME/.fzf/bin ]]; then
    export PATH="$PATH:$HOME/.fzf/bin"
fi;

function dev_docker {
    docker run -it\
      -v $HOME/.ssh:/root/.ssh\
      -v $HOME/workspace:/workspace\
      -v $HOME/.aws:/root/.aws\
      -h arai_fedora_docker\
      abhi56rai/fedora_dev:latest
}

function enable_kube_completion {
    autoload -U +X compinit && compinit
    source <(kubectl completion zsh)
}

alias ll="ls -alh"
alias virsh="virsh --connect qemu:///system"
alias python2="ipython2"
alias python="ipython3"
alias tmux="/usr/bin/tmux attach -t Base || /usr/bin/tmux new -s Base"
alias tmuxb="/usr/bin/tmux attach -t Alt || /usr/bin/tmux new -s Alt"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
