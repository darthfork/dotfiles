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
if [[ -d $HOME/.local/bin ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi;

if [[ -d $HOME/workspace/go ]]; then
    export GOPATH=$HOME/workspace/go
fi;

if [[ -d $HOME/.fzf/bin ]]; then
    export PATH="$PATH:$HOME/.fzf/bin"
fi;

function dorker {
    docker run -it\
      -v $HOME/.ssh:/root/.ssh\
      -v $HOME/workspace:/workspace\
      -v $HOME/.aws:/root/.aws\
      -v /var/run/docker.sock:/var/run/docker.sock\
      --user $(id -u):$(id -g)\
      -e USER=$USER\
      -h dorker\
      abhi56rai/dorker:latest
}

function get_code {
    yubikey_connected=$(ykman list)
    if [ -z "$yubikey_connected" ]; then
        echo "No yubikey found"
        return
    fi
    if [ -z $1 ]; then
        ykman oath code
    else
        ykman oath code $1 | tee $(tty) | awk '{print $2}' | xclip -selection clipboard
    fi
}

function gh_docker_login {
    cat $HOME/.creds/GH_TOKEN.txt | docker login docker.pkg.github.com -u darthfork --password-stdin
}

function enable_kube_completion {
    autoload -U +X compinit && compinit
    source <(kubectl completion zsh)
}

alias virsh="virsh --connect qemu:///system"
alias python2="ipython2"
alias python="ipython3"
alias man="$HOME/.local/bin/cool_man"
alias tmux="tmux attach -t Base || tmux new -s Base"
alias tmuxb="tmux attach -t Alt || tmux new -s Alt"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
