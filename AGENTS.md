# Agent Guidelines for Dotfiles Repository

## Build/Lint/Test Commands
- **Deploy Configs**: `chezmoi apply` (Applies all configurations to the home directory.)
- **Preview Changes**: `chezmoi diff` (Shows what will change before deployment.)
- **Validate Templates**: `chezmoi execute --dry-run` (Checks Go template syntax validity.)
- **Single File Validation**: Use `chezmoi cat --dry-run <path>` for specific file checks.
- **Error Handling**: Configuration errors are typically caught by `chezmoi apply` or manual inspection post-deployment.

## Code Style & Conventions
- **File Naming**: `dot_` prefix for dotfiles (`dot_zshrc` → `~/.zshrc`), `private_` for secrets.
- **Templates**: Use `.tmpl` suffix for Go templates. Use OS conditionals: `{{ if eq .chezmoi.os "darwin" }}...{{- else }}...{{- end }}`.
- **Lua**: 2-space indent, `local` scope, `snake_case` variables, use `require()`.
- **Shell (Zsh)**: Oh My Zsh style, double-quote all paths, use `eval "$(cmd)"` for initialization.
- **Theme**: Catppuccin Mocha is the standard color scheme.
- **Keybinds**: Prefer vim-style navigation (hjkl).

## Agent Configuration Rules
- **Cursor**: No specific rules found in `.cursor/rules/`. Agents should adhere to the style above.
- **Copilot**: No specific instructions found in `.github/copilot-instructions.md`. Agents should prioritize idiomatic configuration file syntax (Lua, Shell, Go Template).