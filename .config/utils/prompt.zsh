#!/usr/bin/env zsh

# prompt.zsh - Custom Zsh prompt with AWS, Kubernetes, Git, and directory info

# Enable prompt substitution
setopt PROMPT_SUBST

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
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Enable history search with up/down arrows
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# Unicode character definitions
local STAGED_SYMBOL=$'\u271A'      # ✚ (Heavy Greek Cross)
local UNSTAGED_SYMBOL=$'\u25CF'    # ● (Black Circle)
local PROMPT_ARROW=$'\u276F'       # ❯ (Heavy Right-Pointing Angle Quotation Mark)
local KUBERNETES_SYMBOL=$'\u2388'  # ⎈ (Helm Symbol)
local GIT_SYMBOL=$'\u2387'         # ⎇ (Alternative Key Symbol)

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

# Get Kubernetes context and namespace
get_k8s_info() {
  if command -v kubectl >/dev/null 2>&1; then
    local context=$(kubectl config current-context 2>/dev/null)
    local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)

    if [[ -n "$context" ]]; then
      # Use default namespace if none specified
      local ns="${namespace:-default}"
      echo "${KUBERNETES_SYMBOL} ${context}:${ns}"
    fi
  fi
}

# Get current directory (full path)
get_current_dir() {
  # Replace home directory with ~
  echo "${PWD/$HOME/~}"
}

# Prompt status based on agnoster
get_prompt_status() {
  local symbols=""

  # Check if running as root
  [[ $UID -eq 0 ]] && symbols+="%F{yellow}⚡%f"

  # Check background jobs
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%F{cyan}⚙%f"

  # Check return code of last command
  [[ $RETVAL -ne 0 ]] && symbols+="%F{red}✘%f"

  [[ -n "$symbols" ]] && echo " $symbols"
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

# Get git information with advanced status and coloring
get_git_info() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    local git_status=""
    local git_color="magenta"  # default color

    # Use git status --porcelain to get detailed status
    local status_output=$(git status --porcelain 2>/dev/null)

    if [[ -n $status_output ]]; then
      local has_staged=false
      local has_unstaged=false
      local has_untracked=false

      # Check for staged files (first column)
      if echo "$status_output" | grep -q "^[MADRC]"; then
        has_staged=true
      fi

      # Check for unstaged changes (second column)
      if echo "$status_output" | grep -q "^.[MD]"; then
        has_unstaged=true
      fi

      # Check for untracked files
      if echo "$status_output" | grep -q "^??"; then
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

    echo "%F{${git_color}}${GIT_SYMBOL} ${branch} ${git_status}%f"
  fi
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
  # Main prompt - capture return value and build prompt
  PROMPT='$(RETVAL=$?; build_prompt) %F{cyan}${PROMPT_ARROW}%f '

  # Right prompt with AWS/K8s info
  RPROMPT='$(build_rprompt)'
}

# Initialize the prompt
setup_prompt
