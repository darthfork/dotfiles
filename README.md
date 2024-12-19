![Dotfiles](https://dotfiles.github.io/images/dotfiles-logo.png "Dotfiles")

# Dotfiles

Vim/NeoVim, tmux, shell config files and utility scripts for macOS and Linux.

## Installation

To install the dotfiles, utility scripts and packages run the following commands:

```bash
./install.sh
```

## Utility Scripts and Kubernetes Plugins

- [**kubectl-shell**](.local/bin/kubectl-shell)
  - Description: kubectl plugin to open a shell in a pod in a Kubernetes cluster
  - Usage: `kubectl shell <pod-name>`
- [**kubectl-dorker**](.local/bin/kubectl-dorker)
  - Description: kubectl plugin to install a pod with a shell in a Kubernetes cluster for debugging cluster issues
  - Usage: `kubectl dorker {up|down}`
- [**kubectl-kind**](.local/bin/kubectl-kind)
  - Description: kubectl plugin to create a Kubernetes cluster using kind
  - Usage: `kubectl kind`
- [**kubectl-setns**](.local/bin/kubectl-setns)
  - Description: kubectl plugin to set the namespace of the current context
  - Usage: `kubectl setns <namespace>`
- [**dorker**](.local/bin/dorker)
  - Description: Utility script to create a container with aws/helm/kubectl and other utilities for debugging
  - Usage: `dorker`
- [**mfa**](.local/bin/mfa)
  - Description: Utility script to generate 2FA tokens from yubikey
  - Usage: `mfa <service-name>`
- [**codemux**](.local/bin/codemux)
  - Description: Utility script to open a tmux session with vscode specific layout and configurations
  - Usage: `codemux <workspace-name>`. This launches a vscode session named `<workspace-name>`. To use with vscode add the following to your vscode settings.json

    ```json
      "terminal.integrated.profiles.osx": {
          "tmux": {
              "path": "codemux",
              "args": [
                  "${workspaceFolderBasename}"
              ],
              "icon": "terminal-tmux"
          }
      }
    ```

## Enable completion for zsh

**autoload setting** (pre-requisite for enabling completion)

```zsh
autoload -U +X compinit && compinit
```

**kubectl**

```zsh
source <(kubectl completion zsh)
```

**aws**

```zsh
complete -C '$(command -v aws_completer)' aws
```

**helm**

```zsh
source <(helm completion zsh)
```

## Repo Structure

```bash
.
├── .config
│   ├── nvim
│   │   └── init.lua
│   ├── ripgrep
│   │   └── config
│   ├── tmux
│   │   ├── tmux.conf
│   │   └── vscode.conf
│   ├── utils
│   │   ├── agnoster-modifications.diff
│   │   ├── compose.yaml
│   │   └── kubernetes.yaml
│   └── yamllint
│       └── config
├── .gitconfig
├── .gitignore
├── .local
│   └── bin
│       ├── codemux
│       ├── dorker
│       ├── kubectl-dorker
│       ├── kubectl-kind
│       ├── kubectl-setns
│       ├── kubectl-shell
│       ├── mfa
│       ├── start_ssh_agent.sh
│       ├── tmux-battery-info
│       ├── tmux-spotify-info
│       └── tmux-system-info
├── .vim
│   └── vimrc
├── .zshrc
├── Brewfile
├── LICENSE
├── README.md
└── install.sh
```
