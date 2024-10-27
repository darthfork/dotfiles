#!/usr/bin/env bash

# This script starts an ssh-agent and adds the ssh key to it.

# shellcheck disable=SC1090,SC2009

export SSH_ENV="$HOME/.ssh/environment"
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    ssh-add
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep "${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
