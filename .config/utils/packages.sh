#!/usr/bin/env bash

# Config file for mltix. Manage language specific system wide through dotfiles

# shellcheck disable=SC2034  # Variables are used by the mltix script

GO_TOOLS=(
    "github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.3.1"
    "github.com/securego/gosec/v2/cmd/gosec@v2.22.7"
    "golang.org/x/vuln/cmd/govulncheck@latest"
    "golang.org/x/tools/gopls@latest"
    "golang.org/x/tools/cmd/goimports@latest"
)

PYTHON_TOOLS=(
    "ruff"
    "python-lsp-server~=1.9.0"
    "uv"
)

NODE_TOOLS=(
    "@anthropic-ai/claude-code@latest"
    "eslint@latest"
)

RUBY_TOOLS=(
    "github_changelog_generator:1.16.4"
    "rubocop"
)

LUA_TOOLS=(
    "luacheck"
)
