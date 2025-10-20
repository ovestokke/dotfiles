# GitHub Actions Workflows

This directory contains automated tests for the dotfiles repository.

## Workflows

### 🔍 `validate.yaml` - Quick Validation
**Triggers:** Every push and pull request  
**Platforms:** Ubuntu, Windows, macOS  
**Purpose:** Fast validation that dotfiles can be initialized without errors

- Installs chezmoi
- Initializes from source
- Runs `chezmoi doctor`
- Performs dry-run of `chezmoi apply`

### 🐧 `test-linux.yaml` - Linux E2E Test
**Triggers:** Push/PR to main/master affecting `home/**`  
**Platform:** Ubuntu Latest  
**Purpose:** Full end-to-end test of Linux dotfiles

- Applies all dotfiles
- Verifies critical files exist (.zshrc, .gitconfig, nvim config)
- Checks install scripts are valid

### 🪟 `test-windows.yaml` - Windows E2E Test
**Triggers:** Push/PR to main/master affecting `home/**`  
**Platform:** Windows Latest  
**Purpose:** Full end-to-end test of Windows dotfiles

- Applies all dotfiles
- Verifies PowerShell profile, VS Code settings, komorebi configs
- Checks install scripts are valid

### 📅 `test-weekly.yaml` - Weekly Full Setup
**Triggers:** Every Sunday at midnight UTC + manual dispatch  
**Platforms:** Ubuntu, Windows  
**Purpose:** Tests the complete user experience with one-liner setup

- Simulates actual user setup from GitHub
- Tests `chezmoi init --apply <username>`
- Catches issues with external dependencies

## Local Testing

Before pushing, you can validate locally:

```bash
# Validate configuration
chezmoi doctor

# Test dry-run
chezmoi apply --dry-run --verbose

# Test actual apply in a safe way
chezmoi diff
```

## Adding New Tests

When adding new dotfiles or scripts:

1. Update the relevant `test-*.yaml` workflow
2. Add verification steps to check new files exist
3. Test locally first with `chezmoi apply --dry-run`
