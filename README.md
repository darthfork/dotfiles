![Dotfiles](https://dotfiles.github.io/images/dotfiles-logo.png "Dotfiles")

# Dotfiles

Vim/NeoVim, tmux, shell config files and utility scripts for macOS and Linux.

## Utility Scripts and Kubernetes Plugins

- [**prompt.zsh**](.config/utils/prompt.zsh)
  - Description: Custom zsh prompt with oh-my-zsh like styling and features without the performance penalty
  - Usage: `source $HOME/.config/utils/prompt.zsh`
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

## Repo Structure

```bash
.
├── .config
│   ├── claude
│   │   ├── CLAUDE.md
│   │   └── settings.json
│   ├── ghostty
│   │   └── config
│   ├── git
│   │   ├── config
│   │   └── ignore
│   ├── mise
│   │   └── config.toml
│   ├── nvim
│   │   ├── init.lua
│   │   ├── lua
│   │   │   ├── base.lua
│   │   │   ├── lsp.lua
│   │   │   └── plugins.lua
│   │   └── nvim-pack-lock.json
│   ├── ripgrep
│   │   └── config
│   ├── tmux
│   │   └── tmux.conf
│   ├── utils
│   │   ├── claude-statusline.sh
│   │   ├── common.sh
│   │   ├── compose.yaml
│   │   ├── kubernetes.yaml
│   │   └── prompt.zsh
│   └── yamllint
│       └── config
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
│       ├── tmux-music-info
│       └── tmux-system-info
├── .zprofile
├── .zshrc
├── Brewfile
├── LICENSE
└── README.md
```
