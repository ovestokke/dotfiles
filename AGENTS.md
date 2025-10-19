# Agent Guidelines for Dotfiles Repository

## Repository Type
Chezmoi dotfiles repository managing personal configs for macOS, Windows, and Linux (WSL).

## Commands
- **Deploy**: `chezmoi apply` (applies configs to home directory)
- **Preview**: `chezmoi diff` (view changes before applying)
- **Verify**: Open new terminal/app session to test
- **No build/test/lint** - configs are declarative, verify manually

## File Naming
- `dot_` → `.` in home dir (`dot_zshrc` → `~/.zshrc`)
- `private_` → excluded from template expansion
- `.tmpl` → Go template (vars: `.chezmoi.os`, `.chezmoi.username`)

## Cross-Platform
- Shared templates in `.chezmoitemplates/`
- Conditionals: `{{ if eq .chezmoi.os "darwin" }}...{{- else if eq .chezmoi.os "linux" }}...{{- end }}`
- `.chezmoiignore` filters platform-specific paths
- macOS → `Library/`, Windows → `AppData/`, `Documents/`, Linux → `dot_config/`

## Code Style
- **Lua**: 2-space indent, snake_case, `local` scope, `require()` for modules
- **Zsh**: Oh My Zsh style, `eval "$(cmd)"`, double-quote paths
- **PowerShell**: `Invoke-Expression`, pipe to `Out-String`
- **JSON**: 2-space indent, trailing commas OK
- **Theme**: Catppuccin Mocha everywhere
- **Keybinds**: vim-style hjkl, CMD (macOS) / CTRL (Windows) leader
