# Restoring Windows Support

Windows support is intentionally inactive. The old source-state files are kept in `_archive/` so support can be restored deliberately if needed.

## Archived Files

- `_archive/home/.chezmoidata/windows/` contains old winget and PowerShell package data.
- `_archive/home/.chezmoiscripts/*.ps1.tmpl` contains old Windows install and sync scripts.
- `_archive/home/.chezmoitemplates/powershell/profile.ps1` contains the shared PowerShell profile template.
- `_archive/home/Documents/PowerShell/` contains the Windows PowerShell target path.
- `_archive/home/AppData/Roaming/` contains Windows app config target paths.
- `_archive/.github/workflows/test-windows.yaml` contains the old manual Windows CI workflow.

## Restore Checklist

1. Copy archived source-state files back into `home/`, preserving their relative paths.
2. Restore `_archive/.github/workflows/test-windows.yaml` to `.github/workflows/test-windows.yaml`.
3. Add `windows-latest` back to `.github/workflows/test-weekly.yaml` only after `test-windows.yaml` passes manually.
4. Reintroduce the Windows branch in `home/.chezmoiignore` before applying on macOS or Linux, so restored Windows target paths do not deploy on the wrong OS.
5. Reintroduce Windows path branches in these active templates:
   - `home/.chezmoi.toml.tmpl`
   - `home/private_dot_gitconfig.tmpl`
   - `home/dot_config/opencode/opencode.json.tmpl`
   - `home/.chezmoiscripts/run_onchange_unix-install-vscode-extensions.sh.tmpl`, or replace it with separate Unix and PowerShell scripts.
   - `home/dot_wezterm.lua`, if WezTerm should launch PowerShell on Windows.
6. Update README badges, setup instructions, platform paths, and tool list to mark Windows as supported again.
7. Validate on Windows with:

```powershell
chezmoi init --apply --exclude encrypted <repo>
chezmoi managed
chezmoi doctor
```

8. Validate on macOS and Linux with `chezmoi diff` to ensure restored Windows files are ignored on non-Windows hosts.

## Notes for Agents

- Treat `_archive/` as restoration material, not active source.
- Do not partially restore Windows support. Restore source files, ignore rules, template branches, docs, and CI together.
- Keep secrets encrypted and never add raw tokens, passwords, or private keys while restoring.
