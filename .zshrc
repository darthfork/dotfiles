ZSH_THEME="agnoster"
DEFAULT_USER=`whoami`
plugins=(
  zsh-syntax-highlighting
)

export TERM="xterm-256color"
export EDITOR="nvim"
export AWS_PAGER=""
export GPG_TTY=$(tty)
export skip_global_compinit=1
export PATH="$PATH:$HOME/.local/bin"
export NVM_DIR="$HOME/.nvm"
export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --hidden -g "!{node_modules,.venv,.git}"'
export FZF_DEFAULT_OPTS="--tmux --layout=reverse --border"
export MANPAGER="vim -M +MANPAGER - "
export SHELLCHECK_OPTS="-e SC2155"
export VIRTUAL_ENV_DISABLE_PROMPT=1 # This allows agnoster to handle the venv prompt
export DOCKER_GROUP_ID=0

source $HOME/.oh-my-zsh/oh-my-zsh.sh
source start_ssh_agent.sh

alias vim="nvim"
alias vimdiff="nvim -d"
alias virsh="virsh --connect qemu:///system"
alias tmux="tmux attach -t Base || tmux new -s Base"
alias tmuxb="tmux attach -t Alt || tmux new -s Alt"

eval "$(pyenv init -)"
eval "$(goenv init -)"
source "/opt/homebrew/opt/nvm/nvm.sh"
source <(fzf --zsh)

# Enable completions
source <(kubectl completion zsh)
complete -C '$(command -v aws_completer)' aws

# Use ~/.zshenv for secrets and system specific aliases
