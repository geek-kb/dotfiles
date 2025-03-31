#!/bin/bash
# install-npm-globals.sh

PACKAGES=(
  "@mermaid-js/mermaid-cli"
  "typescript"
  "eslint"
  "prettier"
  "eslint-config-prettier"
  "compare-versions"
  "neovim"
  "npm"
  "yarn"
  "typescript"
  "eslint-config-react-app"
)

for pkg in "${PACKAGES[@]}"; do
  npm install -g "$pkg"
done
