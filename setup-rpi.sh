#!/usr/bin/env bash

set -euo pipefail

# Simple Raspberry Pi OS (64-bit) setup script.
# Installs: neovim, lazygit, lazydocker, opencode (npm, v1.1.53)
# and enables vi-mode for bash.

if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root (use sudo)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "[1/6] Updating and upgrading apt packages..."
apt-get update -y
apt-get upgrade -y

echo "[2/6] Installing base packages (curl, git, unzip, docker, nodejs, npm, neovim)..."
apt-get install -y \
  curl git unzip docker.io nodejs npm neovim ca-certificates tar gzip

echo "[3/6] Enabling vi mode for bash (set -o vi)..."
default_user="${SUDO_USER:-pi}"
user_home="$(eval echo ~"${default_user}")"
bashrc_path="${user_home}/.bashrc"
if [[ -f "${bashrc_path}" ]]; then
  if ! grep -q '^set -o vi' "${bashrc_path}"; then
    echo 'set -o vi' >> "${bashrc_path}"
    echo "Added 'set -o vi' to ${bashrc_path}"
  else
    echo "'set -o vi' already present in ${bashrc_path}"
  fi
else
  echo "set -o vi" > "${bashrc_path}"
  chown "${default_user}:${default_user}" "${bashrc_path}"
  echo "Created ${bashrc_path} with 'set -o vi'"
fi

echo "[4/6] Installing lazygit (latest release for linux arm64)..."
LAZYGIT_VERSION="$(
  curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
  | awk -F '"' '/"tag_name": "v/ {print $4; exit}'
)"

curl -fsSL \
  "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_arm64.tar.gz" \
  -o /tmp/lazygit.tar.gz

tar -C /usr/local/bin -xzf /tmp/lazygit.tar.gz lazygit
rm -f /tmp/lazygit.tar.gz

echo "[5/6] Installing lazydocker (latest release for Linux arm64)..."
LAZYDOCKER_VERSION="$(
  curl -fsSL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest \
  | awk -F '"' '/"tag_name": "v/ {print $4; exit}'
)"

curl -fsSL \
  "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_arm64.tar.gz" \
  -o /tmp/lazydocker.tar.gz

tar -C /usr/local/bin -xzf /tmp/lazydocker.tar.gz lazydocker
rm -f /tmp/lazydocker.tar.gz

echo "[6/6] Installing OpenCode CLI (opencode-ai@1.1.53) via npm..."
npm install -g opencode-ai@1.1.53

echo "\nDone. Installed: neovim, lazygit, lazydocker, opencode-ai@1.1.53."
echo "Open a new shell for vi-mode in bash to take effect."
