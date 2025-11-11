# Agent Guidelines for Dotfiles Repository

## Build/Lint/Test Commands
- **Deploy All**: `chezmoi apply` (deploys all configs to home directory)
- **Preview Changes**: `chezmoi diff` (shows what will change before deployment)
- **Test Single File**: `chezmoi cat home/dot_zshrc.tmpl` (preview rendered output without applying)
- **Validate Templates**: `chezmoi execute-template < home/dot_zshrc.tmpl` (test Go template syntax)
- **Full Test**: `chezmoi init --apply <repo> --branch=<branch> && chezmoi managed && chezmoi doctor` (simulates CI workflow)
- **Diagnose Issues**: `chezmoi doctor` (checks setup, identifies configuration problems)

## Code Style & Conventions
- **File Naming**: `dot_` prefix for dotfiles (`dot_zshrc` → `~/.zshrc`), `private_` for secrets, `run_once_` for one-time scripts, `run_onchange_` for hash-tracked scripts that re-run on change
- **Go Templates**: Use `.tmpl` suffix. OS conditionals: `{{ if eq .chezmoi.os "darwin" }}...{{- else }}...{{- end }}`. Always use `{{-` to trim whitespace. Access data with `{{ .packages.darwin.brews }}`
- **YAML Data Files**: Declare packages in `.chezmoidata/{os}/*.yaml` with structure `packages.{os}.{manager}` (e.g., `packages.darwin.brews`, `packages.darwin.casks`)
- **Shell Scripts**: Use `set -uo pipefail`, double-quote all paths, track package changes with `# packages.yaml hash: {{ include "..." | sha256sum }}`, check errors with arrays: `failed=()`, `succeeded=()`
- **Zsh Config**: Check command exists: `[[ $+commands[cmd] ]]`, use `eval "$(cmd)"` for init, source completions: `source <(chezmoi completion zsh)`
- **PowerShell**: Include templates: `#{{- includeTemplate "powershell/profile.ps1" . | trim }}`, use `-ErrorAction SilentlyContinue` for module imports
- **Lua (WezTerm)**: 2-space indent, `local` scope, `snake_case` naming, platform detection: `wezterm.target_triple == 'x86_64-apple-darwin'`, cross-platform leader key handling
- **Theme Standard**: Catppuccin Mocha everywhere (WezTerm, Neovim, Oh My Posh, Powerlevel10k)
- **Keybind Philosophy**: Vim-style navigation (hjkl) preferred, cross-platform leader keys (CMD on macOS, CTRL elsewhere)

## Important Notes
- **Never commit secrets**: Always check for API keys, tokens, passwords before committing
- **Cross-platform testing**: Use OS conditionals (`{{ if eq .chezmoi.os "darwin" }}`) and test changes on target platforms
- **Error handling**: Scripts should track success/failure, continue on errors, report summary at end