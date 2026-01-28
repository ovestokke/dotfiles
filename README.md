# Dotfiles

![macOS](https://img.shields.io/badge/macOS-supported-success?style=flat-square&logo=apple)
![Windows](https://img.shields.io/badge/Windows-supported-success?style=flat-square&logo=windows)
![Linux](https://img.shields.io/badge/Linux-supported-success?style=flat-square&logo=linux)
![License](https://img.shields.io/github/license/ovestokke/dotfiles?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/ovestokke/dotfiles?style=flat-square)

![macOS Tests](https://img.shields.io/github/actions/workflow/status/ovestokke/dotfiles/test-macos.yaml?style=flat-square&logo=apple&label=macOS)
![Linux Tests](https://img.shields.io/github/actions/workflow/status/ovestokke/dotfiles/test-linux.yaml?style=flat-square&logo=linux&label=Linux)
![Windows Tests](https://img.shields.io/github/actions/workflow/status/ovestokke/dotfiles/test-windows.yaml?style=flat-square&logo=windows&label=Windows)

![chezmoi](https://img.shields.io/github/v/release/twpayne/chezmoi?label=chezmoi&style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0iI2ZmZiIgZD0iTTEyIDJMMiA3bDEwIDUgMTAtNXoiLz48cGF0aCBmaWxsPSIjZmZmIiBkPSJNMiA3djEwbDEwIDVWMTJ6Ii8+PHBhdGggZmlsbD0iI2ZmZiIgZD0iTTIyIDd2MTBsLTEwIDVWMTJ6Ii8+PC9zdmc+)
![WezTerm](https://img.shields.io/github/v/release/wez/wezterm?label=WezTerm&style=flat-square)
![komorebi](https://img.shields.io/github/v/release/LGUG2Z/komorebi?label=komorebi&style=flat-square)
![Neovim](https://img.shields.io/github/v/release/neovim/neovim?label=Neovim&style=flat-square&logo=neovim)
![Oh My Zsh](https://img.shields.io/badge/Oh%20My%20Zsh-latest-blue?style=flat-square&logo=gnu-bash)
![Powerlevel10k](https://img.shields.io/badge/Powerlevel10k-latest-blue?style=flat-square)

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Setup

### Prerequisites

This dotfiles repo uses **Age encryption** for SSH keys and secrets. Before initializing, you need:

1. **Age encryption tool**
2. **Age identity key** (stored in Proton Pass as "Chezmoi Age Identity Key")

### Installation

**macOS/Linux:**
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
# Set permissions
chmod 600 ~/.config/chezmoi/key.txt

# Initialize and apply dotfiles
chezmoi init --apply https://github.com/ovestokke/dotfiles.git
```

**Windows:**
```pwsh
# Install chezmoi and age
winget install twpayne.chezmoi FiloSottile.age

# Create config directory
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\chezmoi"

# Copy Age key from Proton Pass to $env:USERPROFILE\.config\chezmoi\key.txt

# Initialize and apply dotfiles
chezmoi init --apply https://github.com/ovestokke/dotfiles.git
chezmoi init --apply git@github.com:ovestokke/dotfiles.git
```

### What Gets Decrypted

On `chezmoi apply`, Age automatically decrypts:
- **SSH private keys** (6 keys: general, GitHub, signing, demeter, hetzner, vultr)
- **SSH config** (multi-key management)
- All keys are encrypted in the repo, only decrypted locally

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

### Cross-Platform
- **Age Encryption**: SSH keys and secrets encrypted at rest, decrypted on apply
- **SSH Keys**: 6 encrypted keys (general, GitHub auth, git signing, servers)
- **Git Signing**: SSH-based commit signing (separate auth/signing keys)
- **VS Code**: Settings and extensions (auto-installs on `chezmoi apply`)
- **Neovim**: LazyVim configuration with Catppuccin Mocha theme
- **Git**: Global gitconfig with SSH signing configured
- **WezTerm**: Terminal emulator with Catppuccin Mocha theme and vim keybinds

### macOS
- **Fish**: Modern shell with Oh My Posh, zoxide, and syntax highlighting
- **Zsh**: Alternative shell with Oh My Zsh and Powerlevel10k theme
- **Tools**: eza, zoxide, fzf, ripgrep, fd, bat, gh, lazygit
- **Packages**: Declarative Homebrew management (git, terraform, neovim, etc.)

### Windows
- **PowerShell**: Profile with Oh My Posh and zoxide integration
- **komorebi**: Tiling window manager with autostart configuration
- **Packages**: Multiple package categories via winget (basic, developer, gaming, productivity, window-manager)
- **PowerShell Modules**: Terminal-Icons, PSReadLine, z, posh-git

### Linux
- **Fish**: Modern shell with Oh My Posh, zoxide, and syntax highlighting
- **Zsh**: Alternative shell with Oh My Zsh and Powerlevel10k theme
- **Tools**: eza, zoxide, fzf, ripgrep, fd, bat, gh, neovim
- **Packages**: Declarative apt package management

## Platform-Specific Paths

Configs are deployed to the correct location per OS:
- **PowerShell**: `~/.config/powershell/` (macOS/Linux) or `~/Documents/PowerShell/` (Windows)
- **VS Code**: `~/Library/Application Support/Code/User/` (macOS), `%APPDATA%/Code/User/` (Windows), or `~/.config/Code/User/` (Linux)
- **Neovim**: `~/.config/nvim/` (macOS/Linux) or `%LOCALAPPDATA%/nvim/` (Windows)

## Documentation

Full chezmoi documentation: https://www.chezmoi.io/

## Acknowledgments

me!
Thanks to [shunk031/dotfiles](https://github.com/shunk031/dotfiles) for inspiration.
