#!/usr/bin/env bash

echo "!!!! WARNING !!!!"
echo "DO NOT RUN THIS MORE THAN ONCE"

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit
fi

if [[ $(uname -s) != 'Linux' ]]; then
    echo "This script is intended to be run on linux only"
fi

cat << EOF >> /etc/zshrc
autoload -U +X compinit && compinit
source <(kubectl completion zsh)
source $(command -v aws_zsh_completer.sh)
EOF
