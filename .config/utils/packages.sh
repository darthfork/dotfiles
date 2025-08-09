#!/usr/bin/env bash

# Language tooling packages configuration

# shellcheck disable=SC2034  # Variables are used by install-language-tools script

GO_TOOLS=(
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
    "github.com/securego/gosec/v2/cmd/gosec@latest"
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
