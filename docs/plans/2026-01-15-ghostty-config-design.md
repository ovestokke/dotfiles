# Ghostty Terminal Configuration

**Date**: 2026-01-15
**Status**: Approved

## Overview

Add Ghostty terminal emulator configuration to chezmoi dotfiles with Tokyo Night theme, MesloLGS Nerd Font, and cross-platform support for macOS and Linux.

## Architecture

### File Structure

**Configuration File**: `home/dot_config/ghostty/config`
- Deploys to: `~/.config/ghostty/config` (XDG standard)
- Format: Plain text key-value pairs (not templated)
- Platforms: macOS and Linux (excluded from WSL)

**Package Management**:
- macOS: Add `ghostty` cask to `home/.chezmoidata/macos/terminal.yaml`
- Arch Linux: Add `ghostty` to AUR packages in `home/.chezmoidata/linux/basic.yaml`
- Debian/Ubuntu: Manual install (not in standard repos yet)

**Platform Ignores**: Update `home/.chezmoiignore`
- WSL systems skip `.config/ghostty/` directory
- Matches existing WezTerm ignore pattern

## Configuration Details

### Visual Settings

**Theme**: Tokyo Night (built-in)
- Use `theme = tokyo-night` directive
- Provides purple/blue tones distinct from WezTerm's Catppuccin Mocha

**Font**: MesloLGS Nerd Font Mono
- Size: 14pt (matches WezTerm)
- Already installed via package management

**Window Appearance**:
- Opacity: 0.98
- Background blur: 10px radius
- Window decorations: enabled
- Padding: comfortable spacing

### Tab Bar Styling

**Configuration**:
- Position: top
- Style: matches Tokyo Night colors
- Shows tab titles and indices
- Integrated with theme

### Behavior

**Shell**: System default (no override)
- macOS: Uses login shell (Fish via default)
- Linux: Uses login shell (Fish via default)

**Interaction**:
- Confirm before closing with multiple tabs
- Standard clipboard integration
- No custom keybindings (keeping minimal)

## Implementation Tasks

1. Create `home/dot_config/ghostty/config` with Tokyo Night theme and settings
2. Add `ghostty` to macOS casks in `home/.chezmoidata/macos/terminal.yaml`
3. Add `ghostty` to AUR packages in `home/.chezmoidata/linux/basic.yaml`
4. Update `home/.chezmoiignore` to exclude `.config/ghostty/` on WSL
5. Test deployment with `chezmoi diff` and `chezmoi apply`

## Design Decisions

**Why XDG path over macOS native path?**
- Cross-platform consistency
- Cleaner directory structure
- Standard location for config files

**Why plain text config instead of template?**
- Ghostty doesn't support complex conditionals
- All settings work identically on macOS and Linux
- No platform-specific variations needed

**Why Tokyo Night instead of Catppuccin Mocha?**
- Visual distinction from WezTerm
- User preference for different theme per terminal
- Built-in Ghostty support (no custom color definitions)

**Why skip Debian/Ubuntu auto-install?**
- Ghostty not in standard repos yet
- Avoid failed installations
- User can manually install when available

## Success Criteria

- Ghostty config deploys to `~/.config/ghostty/config` on macOS and Linux
- WSL systems ignore Ghostty config
- Package auto-installs on macOS via Homebrew
- Package auto-installs on Arch via AUR helper (paru/yay)
- Config loads with Tokyo Night theme and proper font
- Window opacity and blur match WezTerm aesthetic
