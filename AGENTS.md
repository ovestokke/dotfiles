# Agent Guidelines for Dotfiles Repository

## Repository Type
This is a **chezmoi dotfiles repository** managing personal configuration files for macOS and Windows.

## Commands
- **Apply changes**: `chezmoi apply` (deploys configs to home directory)
- **View diff**: `chezmoi diff` (preview changes before applying)
- **Manual verification**: Test configs by opening new terminal/app session
- **No build/test/lint** - configs are declarative, verify manually after `chezmoi apply`

## File Naming Convention
- `dot_` prefix = `.` in home directory (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_` prefix = file excluded from version control template expansion
- `.tmpl` suffix = Go template file (variables: `.chezmoi.os`, `.chezmoi.username`)
- Files are Lua, shell scripts, JSON, TOML - NO compilation needed

## Cross-Platform Strategy
- **Templates**: Shared configs in `.chezmoitemplates/` (e.g., `vscode/settings.json`)
- **Conditionals**: Use `{{ if eq .chezmoi.os "windows" }}...{{- else }}...{{- end }}` in `.tmpl` files
- **Ignore rules**: `.chezmoiignore` uses conditionals to exclude wrong-platform dirs
- **Deploy to OS-specific paths**: macOS uses `Library/`, Windows uses `AppData/`

## Code Style
- **Lua**: 2-space indent, snake_case vars, `local` scope, use `require()` for modules
- **Shell (zsh)**: Follow Oh My Zsh style, use `eval "$(cmd)"` for init, double-quote paths
- **PowerShell**: Use `Invoke-Expression` for init, pipe to `Out-String` when needed
- **JSON**: 2-space indent, trailing commas allowed in VS Code settings
- **Comments**: Use `--` (Lua), `#` (shell), `//` not valid in JSON
- **Color scheme**: Catppuccin Mocha theme everywhere (WezTerm, VS Code, oh-my-posh)
- **Keybinds**: Prefer vim-style hjkl navigation, CMD (macOS) / CTRL (Windows) as leader

## Key Tools & Aliases
- **Terminal**: WezTerm (font: MesloLGS Nerd Font Mono, opacity: 0.98)
- **Prompt**: Powerlevel10k (zsh), oh-my-posh (PowerShell)
- **Utils**: eza (`ls`), zoxide (`cd`), chezmoi (`ch`, `chd`, `chap`)
- **Editor**: VS Code, auto-installs extensions via run_onchange scripts
