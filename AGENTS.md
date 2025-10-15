# Agent Guidelines for Dotfiles Repository

## Repository Type
This is a **chezmoi dotfiles repository** managing personal configuration files for macOS.

## Commands
- Apply changes: `chezmoi apply`
- View diff: `chezmoi diff`
- Edit file: `chezmoi edit ~/.zshrc` (edits dot_zshrc)
- Add new file: `chezmoi add ~/.newfile`
- No build/test/lint commands - manual verification required

## File Naming Convention
- `dot_` prefix = `.` in home directory (e.g., `dot_zshrc` → `~/.zshrc`)
- Files are Lua (`.lua`) and TOML (`.toml`) configs, plus shell scripts

## Code Style
- **Lua**: 2-space indent, snake_case variables, local scope preferred
- **Shell**: Follow existing Oh My Zsh conventions, use `eval` for path setup
- **TOML**: Follow AeroSpace config format, use comments for section headers
- Use existing color schemes (Catppuccin Mocha for WezTerm)
- Maintain vim-style hjkl navigation keybinds where applicable

## Key Tools in Use
- Terminal: WezTerm with Powerlevel10k prompt
- Shell: zsh with Oh My Zsh, plugins: git, 1password, terraform
- Window manager: AeroSpace (tiling WM for macOS)
- Utils: eza (ls replacement), zoxide (cd replacement)
