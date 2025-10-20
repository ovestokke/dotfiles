# Agent Guidelines for Dotfiles Repository

## Build/Lint/Test Commands
- **Deploy Configs**: `chezmoi apply` (Applies all configurations to the home directory.)
- **Preview Changes**: `chezmoi diff` (Shows what will change before deployment.)
- **Validate Templates**: `chezmoi execute-template --dry-run` (Checks Go template syntax validity.)
- **Single File Validation**: Use `chezmoi cat <path>` to preview rendered output of specific files.
- **Error Handling**: Configuration errors are caught by `chezmoi apply`; use `chezmoi doctor` to diagnose setup issues.

## Code Style & Conventions
- **File Naming**: `dot_` prefix for dotfiles (`dot_zshrc` → `~/.zshrc`), `private_` for secrets, `run_once_` or `run_onchange_` for scripts.
- **Templates**: Use `.tmpl` suffix for Go templates. OS conditionals: `{{ if eq .chezmoi.os "darwin" }}...{{- else }}...{{- end }}`. Always use `{{-` to trim whitespace.
- **Lua**: 2-space indent, `local` scope, `snake_case` variables, use `require()`, platform checks with `wezterm.target_triple`.
- **Shell (Zsh)**: Oh My Zsh style, double-quote all paths, use `eval "$(cmd)"` for initialization, check command exists with `[[ $+commands[cmd] ]]`.
- **PowerShell**: Template inclusion pattern: `#{{- includeTemplate "powershell/profile.ps1" . | trim }}`.
- **Packages**: Declare in YAML under `.chezmoidata/{os}/` directories, reference with `{{ range .packages.{os}.{manager} }}`.
- **Theme**: Catppuccin Mocha is the standard color scheme across all applications.
- **Keybinds**: Prefer vim-style navigation (hjkl) in all tools (WezTerm, Neovim).

## Important Notes
- **Never commit secrets**: Check for sensitive data before committing (API keys, tokens, passwords).
- **Cross-platform awareness**: Always test changes affect the intended OS using chezmoi conditionals.
- **Package hash tracking**: Scripts include `# packages.yaml hash: {{ include "..." | sha256sum }}` to trigger re-runs on changes.