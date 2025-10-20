# Dotfiles

![macOS](https://img.shields.io/badge/macOS-supported-success?style=flat-square&logo=apple)
![Windows](https://img.shields.io/badge/Windows-supported-success?style=flat-square&logo=windows)
![Linux](https://img.shields.io/badge/Linux-supported-success?style=flat-square&logo=linux)
![License](https://img.shields.io/github/license/ovestokke/dotfiles?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/ovestokke/dotfiles?style=flat-square)

![chezmoi](https://img.shields.io/github/v/release/twpayne/chezmoi?label=chezmoi&style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0iI2ZmZiIgZD0iTTEyIDJMMiA3bDEwIDUgMTAtNXoiLz48cGF0aCBmaWxsPSIjZmZmIiBkPSJNMiA3djEwbDEwIDVWMTJ6Ii8+PHBhdGggZmlsbD0iI2ZmZiIgZD0iTTIyIDd2MTBsLTEwIDVWMTJ6Ii8+PC9zdmc+)
![WezTerm](https://img.shields.io/github/v/release/wez/wezterm?label=WezTerm&style=flat-square)
![komorebi](https://img.shields.io/github/v/release/LGUG2Z/komorebi?label=komorebi&style=flat-square)
![Neovim](https://img.shields.io/github/v/release/neovim/neovim?label=Neovim&style=flat-square&logo=neovim)
![Oh My Zsh](https://img.shields.io/badge/Oh%20My%20Zsh-latest-blue?style=flat-square&logo=gnu-bash)
![Powerlevel10k](https://img.shields.io/badge/Powerlevel10k-latest-blue?style=flat-square)

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Setup

One-line install (recommended):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

Or install manually:

```bash
# Install chezmoi
brew install chezmoi

# Initialize and apply dotfiles
chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git
```

```pwsh
# Install chezmoi
winget install chezmoi
# Initialize and apply dotfiles
chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git
```

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
- **VS Code**: Settings and extensions (auto-installs on `chezmoi apply`)
- **PowerShell**: Profile with Oh My Posh and zoxide integration
- **Tools**: zoxide for smart directory navigation

### macOS
- **WezTerm**: Terminal emulator with Catppuccin Mocha theme
- **Zsh**: Shell configuration with Oh My Zsh, Powerlevel10k theme
- **Tools**: eza (ls replacement), 1Password CLI
- **Packages**: Declarative package management via Homebrew (auto-installs git, terraform, etc.)

### Windows
- **PowerShell**: Profile with Oh My Posh prompt

## Platform-Specific Paths

Configs are deployed to the correct location per OS:
- **PowerShell**: `~/.config/powershell/` (macOS) or `~/Documents/PowerShell/` (Windows)
- **VS Code**: `~/Library/Application Support/Code/User/` (macOS) or `%APPDATA%/Code/User/` (Windows)

## Documentation

Full chezmoi documentation: https://www.chezmoi.io/

## Acknowledgments

Thanks to [shunk031/dotfiles](https://github.com/shunk031/dotfiles) for inspiration.
