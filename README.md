# Dotfiles

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
- **AeroSpace**: Tiling window manager
- **Zsh**: Shell configuration with Oh My Zsh, Powerlevel10k theme
- **Tools**: eza (ls replacement)

### Windows
- **PowerShell**: Profile with Oh My Posh prompt

## Platform-Specific Paths

Configs are deployed to the correct location per OS:
- **PowerShell**: `~/.config/powershell/` (macOS) or `~/Documents/PowerShell/` (Windows)
- **VS Code**: `~/Library/Application Support/Code/User/` (macOS) or `%APPDATA%/Code/User/` (Windows)

## Documentation

Full chezmoi documentation: https://www.chezmoi.io/
