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
typeset -g PROMPT_ARROW=$'\u276F'       # ❯ (Heavy Right-Pointing Angle Quotation Mark)
typeset -g KUBERNETES_SYMBOL=$'\u2388'  # ⎈ (Helm Symbol)
typeset -g GIT_SYMBOL=$'\ue0a0'         #  (git branch symbol)

# Cache variables for expensive operations
typeset -g _PROMPT_CACHE_K8S=""
typeset -g _PROMPT_CACHE_K8S_TIME=0
typeset -g _PROMPT_CACHE_GIT=""
typeset -g _PROMPT_CACHE_GIT_TIME=0
typeset -g _PROMPT_CACHE_GIT_PWD=""
typeset -g PROMPT_CACHE_TTL=2  # Cache for 2 seconds

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

# Get git information with advanced status and coloring (with caching)
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

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -z $branch ]] && return  # Exit if we can't get branch info

    local git_status=""
    local git_color="magenta"  # default color

    # Use git status --porcelain to get detailed status
    local status_output=$(git status --porcelain 2>/dev/null)

    if [[ -n $status_output ]]; then
      local has_staged=false
      local has_unstaged=false
      local has_untracked=false

      # Check for staged files (first column) - using zsh pattern matching
      if [[ $status_output =~ '(^|\n)[MADRC]' ]]; then
        has_staged=true
      fi

      # Check for unstaged changes (second column) - using zsh pattern matching
      if [[ $status_output =~ '(^|\n).[MD]' ]]; then
        has_unstaged=true
      fi

      # Check for untracked files - using zsh pattern matching
      if [[ $status_output == *$'\n??'* || $status_output == '??'* ]]; then
        has_untracked=true
      fi

      # Set status symbols based on combinations
      if [[ "$has_staged" == true && "$has_unstaged" == true ]]; then
        git_status="${UNSTAGED_SYMBOL}${STAGED_SYMBOL}"  # Mixed: some staged, some unstaged
      elif [[ "$has_staged" == true ]]; then
        git_status="${STAGED_SYMBOL}"   # All staged
      elif [[ "$has_unstaged" == true ]]; then
        git_status="${UNSTAGED_SYMBOL}"   # All unstaged
      fi

      # Set color based on any changes (like agnoster)
      git_color="yellow"  # Any changes present (staged/unstaged/untracked)
    else
      git_color="green"   # Clean repo - everything committed
    fi

    local result="%F{${git_color}}${GIT_SYMBOL} ${branch} ${git_status}%f"

    # Cache the result
    _PROMPT_CACHE_GIT="$result"
    _PROMPT_CACHE_GIT_TIME=$current_time
    _PROMPT_CACHE_GIT_PWD="$current_pwd"

    echo "$result"
  fi
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
