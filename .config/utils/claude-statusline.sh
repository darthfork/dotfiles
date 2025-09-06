#!/bin/bash

# Read the JSON input from stdin
input=$(cat)

# Extract values from the JSON
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')

# Get current directory name
if [ -n "$current_dir" ]; then
    dir_name=$(basename "$current_dir")
else
    dir_name=$(basename "$(pwd)")
fi

# Check if we're in a git repository and get branch info
git_branch=""
git_status=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git branch --show-current 2>/dev/null || echo "detached")
    # Check for uncommitted changes
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
        git_status="*"
    fi
fi

# Color escape sequences
DIM="\033[2m"
CYAN="\033[36m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
GREEN="\033[32m"
RESET="\033[0m"

if [ -n "$git_branch" ]; then
    printf "${DIM}${CYAN}%s${RESET} ${DIM}in${RESET} ${YELLOW}%s${RESET} ${DIM}on${RESET} ${MAGENTA}%s%s${RESET} ${DIM}|${RESET} ${GREEN}%s${RESET}" \
        "$model_name" \
        "$dir_name" \
        "$git_branch" \
        "$git_status" \
        "$output_style"
else
    printf "${DIM}${CYAN}%s${RESET} ${DIM}in${RESET} ${YELLOW}%s${RESET} ${DIM}|${RESET} ${GREEN}%s${RESET}" \
        "$model_name" \
        "$dir_name" \
        "$output_style"
fi
