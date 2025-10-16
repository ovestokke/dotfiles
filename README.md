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

- **WezTerm**: Terminal emulator with Catppuccin Mocha theme
- **AeroSpace**: Tiling window manager for macOS
- **Zsh**: Shell configuration with Oh My Zsh, Powerlevel10k theme
- **Tools**: eza, zoxide, and various plugins

## Documentation

Full chezmoi documentation: https://www.chezmoi.io/
