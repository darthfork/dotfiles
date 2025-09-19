#!/usr/bin/env zsh

# prompt.zsh - Custom Zsh prompt with AWS, Kubernetes, Git, and directory info

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt PROMPT_SUBST # Enable prompt substitution
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Use zsh's built-in color system for proper width calculation
autoload -U colors && colors

# Enable colors for ls command
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad  # macOS color scheme

# Set up ls aliases with colors
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls="ls -G"  # macOS
  alias ll="ls -lG"
  alias la="ls -laG"
else
  alias ls="ls --color=auto"  # Linux
  alias ll="ls -l --color=auto"
  alias la="ls -la --color=auto"
fi

# Fast completion initialization with cache
if [[ -z "$_COMPINIT_LOADED" ]]; then
  autoload -Uz compinit
  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
  export _COMPINIT_LOADED=1
fi

# Enable history search with up/down arrows
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# Enable edit-command-line widget for Ctrl-x Ctrl-e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Unicode character definitions (global scope)
typeset -g STAGED_SYMBOL=$'\u271A'      # ✚ (Heavy Greek Cross)
typeset -g UNSTAGED_SYMBOL=$'\u25CF'    # ● (Black Circle)
typeset -g STASH_SYMBOL=$'\u2691'       # ⚑ (Black Flag)
typeset -g PROMPT_ARROW=$'\u276F'       # ❯ (Heavy Right-Pointing Angle Quotation Mark)
typeset -g KUBERNETES_SYMBOL=$'\u2388'  # ⎈ (Helm Symbol)
typeset -g GIT_SYMBOL=$'\ue0a0'         #  (git branch symbol)

# Cache variables for expensive operations
typeset -g _PROMPT_CACHE_K8S=""
typeset -g _PROMPT_CACHE_K8S_TIME=0
typeset -g _PROMPT_CACHE_GIT=""
typeset -g _PROMPT_CACHE_GIT_TIME=0
typeset -g _PROMPT_CACHE_GIT_PWD=""
typeset -g _PROMPT_HAS_UNTRACKED=0
typeset -g PROMPT_CACHE_TTL=2  # Cache for 2 seconds

# Configure vcs_info for git
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' check-for-staged-changes true
zstyle ':vcs_info:*' unstagedstr "${UNSTAGED_SYMBOL}"
zstyle ':vcs_info:*' stagedstr "${STAGED_SYMBOL}"
zstyle ':vcs_info:*' formats '%b %u%c%m'
zstyle ':vcs_info:*' actionformats '%b [%a]%u%c%m'

# Add comprehensive git status hooks
+vi-git-stash() {
  local stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  if [[ $stash_count -gt 0 ]]; then
    hook_com[misc]+="${STASH_SYMBOL}"
  fi
}

+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == 'true' ]] && \
     [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    _PROMPT_HAS_UNTRACKED=1
  else
    _PROMPT_HAS_UNTRACKED=0
  fi
}

zstyle ':vcs_info:git*+set-message:*' hooks git-stash git-untracked

# Get AWS profile
get_aws_profile() {
  if [[ -n "$AWS_PROFILE" ]]; then
    echo "aws:${AWS_PROFILE}"
  elif [[ -n "$AWS_DEFAULT_PROFILE" ]]; then
    echo "aws:${AWS_DEFAULT_PROFILE}"
  else
    echo ""
  fi
}

# Get Kubernetes context and namespace (with caching)
get_k8s_info() {
  local current_time=$(date +%s)

  # Return cached result if still valid
  if (( current_time - _PROMPT_CACHE_K8S_TIME < PROMPT_CACHE_TTL )); then
    echo "$_PROMPT_CACHE_K8S"
    return
  fi

  # Check if kubectl is available and config exists
  command -v kubectl >/dev/null 2>&1 || return
  [[ -f ~/.kube/config ]] || return

  local context=$(kubectl config current-context 2>/dev/null)
  [[ -n $context ]] || return  # Exit if no context

  local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  # Use default namespace if none specified
  local ns="${namespace:-default}"
  local result="${KUBERNETES_SYMBOL} ${context}:${ns}"

  # Cache the result
  _PROMPT_CACHE_K8S="$result"
  _PROMPT_CACHE_K8S_TIME=$current_time

  echo "$result"
}

# Get current directory (full path)
get_current_dir() {
  # Replace home directory with ~
  echo "${PWD/$HOME/~}"
}

# Get Python virtual environment info
get_venv_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    local venv_name=$(basename "$VIRTUAL_ENV")
    echo "venv:${venv_name}"
  elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    echo "conda:${CONDA_DEFAULT_ENV}"
  fi
}

# Get git information using vcs_info (with caching)
get_git_info() {
  # Smart git detection - only check if we're actually in a git repo
  [[ -d .git ]] || git rev-parse --git-dir >/dev/null 2>&1 || return

  local current_time=$(date +%s)
  local current_pwd=$PWD

  # Return cached result if still valid and in same directory
  if (( current_time - _PROMPT_CACHE_GIT_TIME < PROMPT_CACHE_TTL )) && [[ "$current_pwd" == "$_PROMPT_CACHE_GIT_PWD" ]]; then
    echo "$_PROMPT_CACHE_GIT"
    return
  fi

  # Use vcs_info to get git information
  vcs_info
  [[ -z $vcs_info_msg_0_ ]] && return

  # Determine color based on git state
  local git_color="green"  # Default to clean
  if [[ -n ${vcs_info_msg_0_//[^${STAGED_SYMBOL}${UNSTAGED_SYMBOL}${STASH_SYMBOL}]/} ]] || [[ ${_PROMPT_HAS_UNTRACKED:-0} -eq 1 ]]; then
    git_color="yellow"  # Has changes, stashes, or untracked files
  fi

  local result="%F{${git_color}}${GIT_SYMBOL} ${vcs_info_msg_0_}%f"

  # Cache the result
  _PROMPT_CACHE_GIT="$result"
  _PROMPT_CACHE_GIT_TIME=$current_time
  _PROMPT_CACHE_GIT_PWD="$current_pwd"

  echo "$result"
}

# Prompt status
get_prompt_status() {
  local symbols=""

  # Check if running as root
  [[ $UID -eq 0 ]] && symbols+="%F{yellow}⚡%f"

  # Check background jobs
  [[ ${#jobstates} -gt 0 ]] && symbols+="%F{cyan}⚙%f"

  [[ -n "$symbols" ]] && echo " $symbols"
}

# Build the prompt - using zsh native color codes
build_prompt() {
  local segments=()

  # Prompt status (leftmost)
  local status_info=$(get_prompt_status)
  if [[ -n "$status_info" ]]; then
    segments+="$status_info"
  fi

  # Current directory
  local dir_info=$(get_current_dir)
  segments+="%F{blue}$dir_info%f"

  # Git info (already includes color)
  local git_info=$(get_git_info)
  if [[ -n "$git_info" ]]; then
    segments+="$git_info"
  fi

  # Join segments with separator
  local prompt_line=""
  for i in {1..$#segments}; do
    if [[ $i -gt 1 ]]; then
      prompt_line+=" %F{white}|%f "
    fi
    prompt_line+="$segments[$i]"
  done

  # Add arrow with conditional color based on return code
  local arrow_color="cyan"
  [[ $RETVAL -ne 0 ]] && arrow_color="red"
  prompt_line+=" %F{${arrow_color}}${PROMPT_ARROW}%f"

  echo "$prompt_line"
}

# Build the right prompt with AWS and K8s info
build_rprompt() {
  local segments=()

  # AWS Profile
  local aws_info=$(get_aws_profile)
  if [[ -n "$aws_info" ]]; then
    segments+="%F{yellow}$aws_info%f"
  fi

  # Kubernetes info
  local k8s_info=$(get_k8s_info)
  if [[ -n "$k8s_info" ]]; then
    segments+="%F{magenta}$k8s_info%f"
  fi

  # Python virtual environment
  local venv_info=$(get_venv_info)
  if [[ -n "$venv_info" ]]; then
    segments+="%F{cyan}$venv_info%f"
  fi

  # Join segments with separator
  local rprompt_line=""
  for i in {1..$#segments}; do
    if [[ $i -gt 1 ]]; then
      rprompt_line+=" %F{white}|%f "
    fi
    rprompt_line+="$segments[$i]"
  done

  echo "$rprompt_line"
}

# Set up the prompt
setup_prompt() {
  # Main prompt - capture return value and build prompt (arrow included)
  PROMPT='$(RETVAL=$?; build_prompt) '

  # Right prompt with AWS/K8s info
  RPROMPT='$(build_rprompt)'
}

# Initialize the prompt
setup_prompt
