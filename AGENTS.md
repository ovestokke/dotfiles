# Agent Guidelines for This Dotfiles Repo

This repository is managed by [chezmoi](https://www.chezmoi.io/). Treat it as a **source state** for files that will be rendered and applied into the user’s home directory.

## How chezmoi Works Here

- The repo contains a `.chezmoiroot` file with `home`, so chezmoi’s source root is:
  - repo path: `home/`
  - target root: `$HOME`
- Files under `home/` are not copied literally by filename. chezmoi decodes source-state attributes into real target paths.
- Common filename transforms:
  - `dot_config/foo` → `~/.config/foo`
  - `dot_zshrc` → `~/.zshrc`
  - `private_dot_ssh/config` → `~/.ssh/config` with private permissions
  - `executable_script.sh` → executable target file
  - `encrypted_private_key.age` → decrypted private target file when age is configured
  - `*.tmpl` → Go template rendered before writing the target file
- Example: `home/dot_config/ghostty/config.tmpl` renders to `~/.config/ghostty/config`.
- `.chezmoiignore` controls which files are ignored per OS/host. A file can exist in `home/` but not be managed on the current machine.

## Templates, Data, and Secrets

- Templates use Go template syntax in files ending with `.tmpl`.
- Use whitespace trimming in templates (`{{- ... -}}`) where possible to avoid accidental blank lines.
- Active platform checks usually use:
  - `{{ if eq .chezmoi.os "darwin" }}`
  - `{{ if eq .chezmoi.os "linux" }}`
- Windows support is archived, not active. Do not add Windows template branches unless the task is explicitly restoring Windows support.
- Data files live under `home/.chezmoidata/` and are exposed to templates as structured data.
- Package lists should stay declarative in `.chezmoidata` YAML where possible.
- Secrets and private keys must stay encrypted or private. Never commit raw tokens, API keys, passwords, or unencrypted private keys.
- Age-encrypted files (`*.age`) are decrypted by chezmoi on apply when the local age identity is configured.

## Windows Archive

- `_archive/` intentionally keeps old Windows source-state files for possible future restoration.
- Files under `_archive/` are not active chezmoi source because `.chezmoiroot` points at `home/`.
- If Windows support needs to come back, follow `docs/WINDOWS_RESTORE.md` and restore source files, ignore rules, template branches, docs, and CI together.
- Do not delete `_archive/` as cleanup; it is the recovery path for the darkest timeline.

## Scripts

chezmoi scripts live in `home/.chezmoiscripts/`.

- `run_once_*` runs once per machine.
- `run_onchange_*` runs when the script content changes.
- `run_after_*` runs after files are applied.
- Scripts may be templates (`.tmpl`) and can use data from `.chezmoidata`.
- Shell scripts should use `set -uo pipefail`, quote paths, continue through package install failures when practical, and report a summary.
- For package install scripts, include a hash comment based on the package data so `run_onchange_*` re-runs when package lists change.

## Common Commands

Use these from the repository root unless noted otherwise.

```bash
# Show what chezmoi would change in $HOME
chezmoi diff

# Apply all managed files/scripts to $HOME
chezmoi apply

# List currently managed target paths
chezmoi managed

# Show rendered target content for a managed file
chezmoi cat ~/.config/ghostty/config

# Validate/render a template directly
chezmoi execute-template < home/dot_config/ghostty/config.tmpl

# Diagnose chezmoi setup and encryption/config problems
chezmoi doctor

# Find the active source root and target root
chezmoi source-path
chezmoi target-path
```

When changing templates, prefer `chezmoi diff` and `chezmoi cat <target-path>` before `chezmoi apply`.

## Repo Conventions

- Keep changes cross-platform unless the file is intentionally OS-specific.
- Use `.chezmoiignore` or template conditionals for OS/host-specific behavior.
- Prefer declarative data in `.chezmoidata` over hard-coded package lists in scripts.
- Keep themes consistent with the repo’s Catppuccin/Noctalia-style terminal setup unless asked otherwise.
- Vim-style navigation/keybinds are preferred where practical.
- For terminal configs, update both the source template and, if the user wants the change immediately, the live target file or run `chezmoi apply`.

## Debugging Discipline

- Reproduce before editing.
- Do not invent config errors from a command typo.
- Do not make speculative cleanup changes.
- Edit only files proven to cause the reported issue.
- If the cause is unclear, explain and ask before changing anything.

## Safe Change Workflow for Agents

1. Identify the source file under `home/` that maps to the desired target path.
2. Edit the source file, not only the already-applied file in `$HOME`.
3. If the file is templated, render/check it with `chezmoi cat <target-path>` or `chezmoi execute-template`.
4. Run `chezmoi diff` to confirm the expected target changes.
5. Only run `chezmoi apply` when the user explicitly wants changes deployed.
6. After validation, update git awareness with `git status --short` and review `git diff` for the touched files.
7. Stage/commit only when the user asks for it; stage only the relevant validated files.
8. Before committing, check for secrets and avoid committing machine-local generated files.
