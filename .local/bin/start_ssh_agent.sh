#!/usr/bin/env bash

# start_ssh_agent.sh -- Starts an ssh-agent and adds the ssh key to it.

# shellcheck disable=SC1090,SC2009
# Usage: Add the following line to your .zshrc or .bashrc
# source ~/start_ssh_agent.sh

export SSH_ENV="$HOME/.ssh/environment"

source "$HOME/.config/utils/common.sh"

function start_agent {
    log_info "Initializing new SSH agent..."
    # Start a new ssh-agent and save the environment variables to SSH_ENV
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    if [ $? -eq 0 ]; then
        log_info "SSH agent started successfully."
    else
        log_error "Failed to start SSH agent."
        return 1
    fi

    # Secure the file
    chmod 600 "${SSH_ENV}"

    # Load the SSH environment variables
    . "${SSH_ENV}" > /dev/null

    # Add default SSH key(s) to the agent
    ssh-add || {
        log_error "Failed to add SSH key(s) to the agent."
        return 1
    }
    log_info "SSH key(s) added successfully."
}

# Check if the SSH environment file exists
if [ -f "${SSH_ENV}" ]; then
    # Load the existing SSH environment variables
    . "${SSH_ENV}" > /dev/null

    # Verify if the SSH agent process is still running
    if ! ps -p "${SSH_AGENT_PID}" > /dev/null 2>&1; then
        log_info "SSH agent is not running. Starting a new one..."
        start_agent || exit 1
    fi
else
    log_info "SSH environment file not found. Starting a new SSH agent..."
    start_agent || exit 1
fi
