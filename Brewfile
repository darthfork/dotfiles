# Brewfile - Brewfile for setting up and managing packages

# Tap additional repositories
tap 'homebrew/bundle'
tap 'homebrew/services'
tap 'hashicorp/tap'

# GUI Apps from cask
cask 'balenaetcher'
cask 'chatgpt'
cask 'cursor'
cask 'discord'
cask 'docker'
cask 'google-chrome'
cask 'iterm2'
cask 'microsoft-teams'
cask 'multiviewer-for-f1'
cask 'obsidian'
cask 'ollama'
cask 'qflipper'
cask 'postman'
cask 'rectangle'
cask 'signal'
cask 'slack'
cask 'spotify'
cask 'steam'
cask 'utm'
cask 'viscosity'
cask 'whatsapp'
cask 'yubico-authenticator'
cask 'zoom'

# Homebrew packages
brew 'awscli'
brew 'bash'
brew 'bazelisk'
brew 'ctlptl'
brew 'curl'
brew 'docker-compose'
brew 'fzf'
brew 'gh'
brew 'git'
brew 'gnu-sed' if OS.mac?
brew 'gnupg'
brew 'goenv'
brew 'golangci-lint', ignore_deps: true
brew 'grip'
brew 'hadolint'
brew 'hashicorp/tap/terraform-ls'
brew 'helm'
brew 'htop'
brew 'huggingface-cli'
brew 'imagemagick' if OS.mac?
brew 'jq'
brew 'kind'
brew 'kubernetes-cli'
brew 'luarocks'
brew 'mas' if OS.mac?
brew 'neovim'
brew 'nodenv'
brew 'pcre'
brew 'pinentry-mac' if OS.mac?
brew 'pyenv'
brew 'redis', restart_service: :changed
brew 'rbenv'
brew 'ripgrep'
brew 'shellcheck'
brew 'tfenv'
brew 'tflint'
brew 'tilt'
brew 'tmux'
brew 'tree'
brew 'tree-sitter'
brew 'universal-ctags'
brew 'watch'
brew 'wget'
brew 'yamllint'
brew 'ykman'
brew 'yq'

# Mac App Store Apps
if OS.mac?
    mas 'Amphetamine', id: 937984704
    mas "Goodnotes", id: 1444383602
end

# VSCode Extensions
vscode 'bazelbuild.vscode-bazel'
vscode 'bierner.github-markdown-preview'
vscode 'bierner.markdown-checkbox'
vscode 'bierner.markdown-emoji'
vscode 'bierner.markdown-footnotes'
vscode 'bierner.markdown-mermaid'
vscode 'bierner.markdown-preview-github-styles'
vscode 'bierner.markdown-yaml-preamble'
vscode 'coder.coder-remote'
vscode 'emily-curry.base16-tomorrow-dark-vscode'
vscode 'file-icons.file-icons'
vscode 'github.copilot'
vscode 'github.copilot-chat'
vscode 'golang.go'
vscode 'hashicorp.terraform'
vscode 'ms-azuretools.vscode-docker'
vscode 'ms-python.debugpy'
vscode 'ms-python.pylint'
vscode 'ms-python.python'
vscode 'ms-python.vscode-pylance'
vscode 'ms-vscode-remote.remote-containers'
vscode 'ms-vscode-remote.remote-ssh'
vscode 'ms-vscode-remote.remote-ssh-edit'
vscode 'ms-vscode.makefile-tools'
vscode 'openai.openai-chatgpt-adhoc'
vscode 'peterj.proto'
vscode 'pomdtr.excalidraw-editor'
vscode 'tamasfe.even-better-toml'
vscode 'tilt-dev.tiltfile'
vscode 'tim-koehler.helm-intellisense'
vscode 'timonwong.shellcheck'
vscode 'vscodevim.vim'
