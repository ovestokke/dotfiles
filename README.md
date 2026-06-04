# Dotfiles

![macOS](https://img.shields.io/badge/macOS-supported-success?style=flat-square&logo=apple)
![Linux](https://img.shields.io/badge/Linux-supported-success?style=flat-square&logo=linux)
![License](https://img.shields.io/github/license/ovestokke/dotfiles?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/ovestokke/dotfiles?style=flat-square)

![macOS Tests](https://img.shields.io/github/actions/workflow/status/ovestokke/dotfiles/test-macos.yaml?style=flat-square&logo=apple&label=macOS)
![Linux Tests](https://img.shields.io/github/actions/workflow/status/ovestokke/dotfiles/test-linux.yaml?style=flat-square&logo=linux&label=Linux)

![chezmoi](https://img.shields.io/github/v/release/twpayne/chezmoi?label=chezmoi&style=flat-square)
![WezTerm](https://img.shields.io/github/v/release/wez/wezterm?label=WezTerm&style=flat-square)
![Neovim](https://img.shields.io/github/v/release/neovim/neovim?label=Neovim&style=flat-square&logo=neovim)
![Oh My Zsh](https://img.shields.io/badge/Oh%20My%20Zsh-latest-blue?style=flat-square&logo=gnu-bash)
![Powerlevel10k](https://img.shields.io/badge/Powerlevel10k-latest-blue?style=flat-square)

Personal macOS and Linux dotfiles managed with [chezmoi](https://www.chezmoi.io/).

Windows support is intentionally archived, not deleted. See [docs/WINDOWS_RESTORE.md](docs/WINDOWS_RESTORE.md) if it needs to come back.

## Setup

### Prerequisites

This dotfiles repo uses Age encryption for SSH keys and secrets. Before initializing, you need:

1. Age encryption tool
2. Age identity key, stored in Proton Pass as "Chezmoi Age Identity Key"

### Installation

```bash
# Install chezmoi and age
brew install chezmoi age  # macOS
# OR
sudo pacman -S chezmoi age  # Arch Linux
# OR
sudo apt install chezmoi age  # Debian/Ubuntu

# Create config directory
mkdir -p ~/.config/chezmoi

# Copy Age key from Proton Pass to ~/.config/chezmoi/key.txt
chmod 600 ~/.config/chezmoi/key.txt

# Initialize and apply dotfiles
chezmoi init --apply https://github.com/ovestokke/dotfiles.git
```

## What Gets Decrypted

On `chezmoi apply`, Age automatically decrypts:

- SSH private keys for personal, GitHub, signing, and server access
- SSH config for multi-key management
- Encrypted private files only on machines with the local Age identity

## Usage

```bash
# Edit a dotfile
chezmoi edit ~/.zshrc

# View what would change
chezmoi diff

# Apply changes
chezmoi apply

# Add new dotfile
chezmoi add ~/.newfile
```

## What's Included

### Shared

- Age encryption for private keys and secrets
- SSH keys and SSH-based git commit signing
- VS Code settings and extensions
- Neovim LazyVim configuration with Catppuccin Mocha theme
- Git config with SSH signing
- WezTerm terminal config with vim-style pane and tab keybinds

### macOS

- Fish shell with zoxide and supporting CLI tools
- Zsh alternative with Oh My Zsh and Powerlevel10k
- Declarative Homebrew packages from `.chezmoidata/macos/`
- App configs under `~/Library/Application Support/` where required

### Linux

- Fish shell with zoxide and supporting CLI tools
- Zsh alternative where not ignored for the current host
- Declarative package data from `.chezmoidata/linux/`
- Desktop configs for Niri, Ghostty, Alacritty, Cava, Satty, and related tools

## Platform-Specific Paths

Configs are deployed to the current supported OS paths:

- VS Code: `~/Library/Application Support/Code/User/` on macOS, `~/.config/Code/User/` on Linux
- Tealdeer: `~/Library/Application Support/tealdeer/` on macOS, `~/.config/tealdeer/` on Linux
- Neovim: `~/.config/nvim/`
- Git: `~/.gitconfig`

## Documentation

Full chezmoi documentation: https://www.chezmoi.io/

## Acknowledgments

me!
Thanks to [shunk031/dotfiles](https://github.com/shunk031/dotfiles) for inspiration.
