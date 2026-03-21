# Raspberry Pi Setup Script

This repository contains a simple setup script for Raspberry Pi OS (64-bit).

The script installs a few tools I regularly use and tweaks the shell configuration.

## What it does

- Updates and upgrades apt packages
- Installs:
  - neovim
  - lazygit (latest release, linux arm64)
  - lazydocker (latest release, Linux arm64)
   - OpenCode CLI (`opencode-ai` latest via npm)
  - Supporting tools: `curl`, `git`, `unzip`, `docker.io`, `nodejs`, `npm`, `tar`, `gzip`, `ca-certificates`
- Enables bash vi-mode by adding `set -o vi` to the user `.bashrc`
- Sets `EDITOR` and `VISUAL` to `nvim` in common shell profile files

## Requirements

- Raspberry Pi OS (64-bit) or another Debian-based arm64 system
- Internet access for apt, GitHub, and npm

## Usage

Clone the repository and run the script as root (or via sudo):

```bash
git clone <this-repo-url> rpinit
cd rpinit
chmod +x setup-rpi.sh
sudo ./setup-rpi.sh
```

**One-liner:**
```bash
curl -fsSL https://gitlab.com/b.engineer/rpinit/-/raw/master/setup-rpi.sh | sudo bash
```

After it finishes, open a new shell session so the vi-mode and editor settings take effect.
