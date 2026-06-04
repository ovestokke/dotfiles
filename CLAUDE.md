# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Repository Overview

This is a chezmoi dotfiles repository for macOS and Linux. Windows support is not active; historical Windows source-state files and the old Windows CI workflow are kept under `_archive/`. Use `docs/WINDOWS_RESTORE.md` before reintroducing Windows behavior.

## Essential Commands

```bash
chezmoi diff                  # Preview target changes
chezmoi apply                 # Deploy configs to the home directory
chezmoi managed               # List managed target paths
chezmoi doctor                # Diagnose chezmoi setup
chezmoi cat <target-path>     # Render one managed file
chezmoi execute-template < file.tmpl
```

When changing templates, prefer `chezmoi diff` and `chezmoi cat <target-path>` before `chezmoi apply`.

## Source Layout

- `.chezmoiroot` contains `home`, so `home/` is the chezmoi source root and `$HOME` is the target root.
- `.chezmoidata/macos/` and `.chezmoidata/linux/` contain declarative package data.
- `.chezmoitemplates/` contains shared template fragments such as VS Code settings and extension lists.
- `.chezmoiscripts/` contains macOS/Linux scripts only.
- `_archive/` contains inactive Windows source-state files for possible future restoration.

## Platform Rules

Active support is macOS and Linux.

- Use `{{ if eq .chezmoi.os "darwin" }}` for macOS-only template branches.
- Use `{{ if eq .chezmoi.os "linux" }}` for Linux-only template branches.
- Do not add Windows branches to active templates unless restoring Windows support as a deliberate task.
- Use `.chezmoiignore` for OS-specific target paths such as macOS `Library/Application Support/` versus Linux `.config/`.

## Code Style

- Keep Go template whitespace tight with `{{- ... -}}` where practical.
- Keep package lists declarative in `.chezmoidata`.
- Shell scripts should use `set -uo pipefail`, quote paths, and report useful progress.
- Lua configs use local variables and existing formatting.
- JSON uses 2-space indentation.

## Common Tasks

### Adding a New Dotfile

```bash
chezmoi add ~/.newfile
chezmoi edit ~/.newfile
```

### Adding Packages

1. Edit the relevant file under `.chezmoidata/macos/` or `.chezmoidata/linux/`.
2. Ensure the matching `run_onchange_*` script includes a hash comment for that data.
3. Validate with `chezmoi diff`.

### Updating VS Code Extensions

1. Edit `.chezmoitemplates/vscode/extensions.txt`.
2. Validate with `chezmoi diff`.

### Restoring Windows Support

Start with `docs/WINDOWS_RESTORE.md`. Do not guess from memory; the archived files are the source of truth for the old Windows setup.
