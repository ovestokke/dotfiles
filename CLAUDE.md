# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a chezmoi dotfiles repository managing personal configurations for macOS, Windows, and Linux (WSL). Chezmoi is a dotfile manager that uses Go templates to handle cross-platform configurations.

## Essential Commands

### Apply Changes
```bash
chezmoi apply                 # Deploy configs to home directory
chezmoi apply -v              # Verbose output showing what's being applied
chezmoi diff                  # Preview changes before applying
chezmoi status                # Show modified/untracked files
```

### Edit Workflow
```bash
chezmoi edit <file>           # Edit source file in chezmoi directory
chezmoi edit --apply <file>   # Edit and immediately apply
chezmoi re-add <file>         # Re-add file after manual edits
```

### Testing Changes
After applying configs:
- Open new terminal session to test shell configs
- Restart application to test app configs
- No automated testing - verification is manual

### Sync with Git
```bash
dotsync                       # Shortcut function that: git add, commit, pull --rebase, push
```

## File Naming Conventions

Chezmoi uses special prefixes to transform filenames:

- `dot_` → `.` in home directory
  - Example: `dot_zshrc` → `~/.zshrc`
- `private_` → Exclude from template expansion
  - Example: `private_dot_gitconfig.tmpl` → `~/.gitconfig` (literal, no template processing for git-managed data)
- `.tmpl` → Go template file with variable interpolation
- `run_onchange_` → Script runs when file hash changes

## Architecture

### Template System

**Shared Templates**: `.chezmoitemplates/`
- `powershell/profile.ps1` - Shared PowerShell configuration
- `vscode/settings.json` - Shared VS Code settings
- `vscode/extensions.txt` - Extension list for auto-install

**Platform-Specific Deployment via `.chezmoiignore`**:
Conditional ignores ensure platform-appropriate files:
- macOS: Ignores `Documents/`, `AppData/`, `.config/powershell/`
- Windows: Ignores `Library/`, `.config/powershell/`
- Linux: Ignores `Library/`, `Documents/`, `AppData/`, `dot_wezterm.lua`

**Platform Detection in Templates**:
```go
{{- if eq .chezmoi.os "darwin" }}
  macOS-specific config
{{- else if eq .chezmoi.os "linux" }}
  Linux-specific config
{{- else if eq .chezmoi.os "windows" }}
  Windows-specific config
{{- end }}
```

Available template variables:
- `.chezmoi.os` - "darwin", "linux", "windows"
- `.chezmoi.username` - Current username
- `.chezmoi.hostname` - Machine hostname

### Package Management

**Data Source**: `.chezmoidata/packages.yaml`

Declarative package lists organized by platform:
- `packages.darwin.brews` - Homebrew formulae
- `packages.darwin.casks` - Homebrew casks
- `packages.linux.apt` - APT packages

**Auto-Install Scripts**: `.chezmoiscripts/`
- `run_onchange_darwin-install-packages.sh.tmpl` - Runs `brew bundle` on macOS
- `run_onchange_linux-install-packages.sh.tmpl` - Runs `apt-get install` + installs Oh My Zsh and plugins
- `run_onchange_install-vscode-extensions.sh.tmpl` - Installs VS Code extensions on Unix
- `run_onchange_install-vscode-extensions.ps1.tmpl` - Installs VS Code extensions on Windows

Scripts include hash of source data in comment so they re-run when packages.yaml or extensions.txt changes.

### Directory Structure

**Platform-Specific Paths**:
- `Library/Application Support/Code/User/` - macOS VS Code
- `AppData/Roaming/Code/User/` - Windows VS Code
- `dot_config/Code/User/` - Linux VS Code
- `Documents/PowerShell/` - Windows PowerShell
- `dot_config/powershell/` - macOS/Linux PowerShell (but macOS ignores this via `.chezmoiignore`)

**Shell Configs**:
- `dot_zshrc.tmpl` - Zsh config for macOS/Linux (Oh My Zsh + Powerlevel10k + zoxide + eza)
- `dot_zprofile.tmpl` - Sets up Homebrew PATH on macOS
- Template includes in PowerShell profiles use custom left delimiter:
  ```
  # chezmoi:template:left-delimiter=#{{
  #{{- includeTemplate "powershell/profile.ps1" . | trim }}
  ```

**Application Configs**:
- `dot_wezterm.lua` - WezTerm terminal config (macOS only, uses Catppuccin Mocha)
- `komorebi.json`, `komorebi.bar.json` - Windows tiling window manager
- `applications.json` - Windows application launcher config
- `dot_config/nvim/` - Neovim config (LazyVim based)

## Code Style Guidelines

### Go Templates (`.tmpl` files)
- Trim whitespace with `{{-` and `-}}`
- Use `{{ if eq .chezmoi.os "darwin" }}` pattern for platform conditionals
- Quote variables in shell output: `{{ . | quote }}`

### Shell Scripts (Bash)
- Oh My Zsh style conventions
- Use `eval "$(command)"` for shell integration
- Double-quote paths and variables
- Include hash of source data in generated scripts for change detection

### PowerShell
- Use `Invoke-Expression` for command output
- Pipe to `Out-String` when needed: `(zoxide init powershell | Out-String)`
- Function naming: lowercase (e.g., `dotsync`)
- Aliases: `-Name` and `-Value` parameters

### JSON Configs
- 2-space indentation
- Trailing commas acceptable

### Lua (WezTerm, Neovim)
- 2-space indentation
- `snake_case` naming
- `local` scope by default
- `require()` for modules

## Theme Consistency

All configs use **Catppuccin Mocha** theme:
- Oh My Posh PowerShell prompt
- WezTerm terminal
- VS Code editor
- Consistent color scheme across platforms

## Common Tasks

### Adding a New Dotfile
```bash
chezmoi add ~/.newfile        # Add to chezmoi management
chezmoi edit ~/.newfile       # Edit in chezmoi directory
```

### Making Platform-Specific Changes
1. Edit the `.tmpl` file
2. Add conditional: `{{ if eq .chezmoi.os "darwin" }}...{{ end }}`
3. Test with `chezmoi diff` then `chezmoi apply`

### Adding New Packages
1. Edit `.chezmoidata/packages.yaml`
2. Add to appropriate section (darwin.brews, linux.apt, etc.)
3. Apply with `chezmoi apply` - the `run_onchange_` script will auto-run

### Updating VS Code Extensions
1. Edit `.chezmoitemplates/vscode/extensions.txt`
2. Apply with `chezmoi apply` - extensions auto-install via script
