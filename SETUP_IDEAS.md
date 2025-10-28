# Setup Ideas & Concepts

This document contains ideas and concepts for improving the dotfiles setup experience, inspired by various dotfiles repositories.

## 1Password Integration (Inspired by jgoguen/dotfiles)

### Current State
- Secrets and keys are managed manually
- SSH keys are stored directly in filesystem
- No centralized secret management

### Proposed Improvement

**Pre-chezmoi Setup Script** that runs before `chezmoi init`:

1. **Install 1Password CLI (`op`)**
   - Auto-detect OS and install appropriate package
   - macOS: `brew install 1password-cli`
   - Linux (RPM): Add 1Password repo, install via dnf/yum
   - Linux (Debian): Add 1Password repo, install via apt
   - Windows: `winget install 1Password.CLI`

2. **Configure 1Password**
   - Interactive: Open 1Password app, wait for user to enable CLI integration + SSH agent
   - Headless: Use `op signin` for CLI-only authentication
   - Set `SSH_AUTH_SOCK` to 1Password agent socket

3. **Fetch Secrets from 1Password**
   ```bash
   # Fetch SSH keys
   op item get <item-id> --fields 'label=public key' > ~/.ssh/git.pub
   
   # Fetch Age encryption key for chezmoi
   op document get <doc-id> --out-file ~/.config/age-chezmoi.txt
   chmod 0600 ~/.config/age-chezmoi.txt
   ```

4. **Initialize chezmoi**
   ```bash
   # With biometric unlock on GUI systems
   OP_BIOMETRIC_UNLOCK_ENABLED=true chezmoi apply --init
   ```

### Benefits
- **No secrets in git**: All sensitive data (SSH keys, encryption keys, API tokens) stored in 1Password vault
- **Cross-device sync**: 1Password handles syncing secrets across machines
- **Secure by default**: Secrets fetched on-demand, not stored in plain text
- **SSH agent integration**: Use 1Password as SSH agent (no local SSH key files needed)
- **Age encryption**: chezmoi templates can use Age encryption with key stored in 1Password

### Implementation Considerations
- Requires 1Password subscription
- Need to document 1Password item/document IDs for secret retrieval
- Setup script would need to be run before `chezmoi init` (breaks one-liner install)
- Could provide both paths:
  - Simple: `chezmoi init --apply` (current method, no 1Password)
  - Advanced: `curl -fsSL <setup-script-url> | sh` (full 1Password integration)

### Alternative: chezmoi's Built-in 1Password Support
chezmoi has native 1Password integration via templates:
```go
{{ (onepasswordRead "op://vault/item/field").value }}
```

This could be used in templates without a pre-setup script, but requires:
- 1Password CLI already installed
- User signed in to `op`
- Biometric unlock configured (for GUI systems)

## 2. Age Encryption for Sensitive Files

### Concept
Use [Age encryption](https://age-encryption.org/) to encrypt sensitive chezmoi templates:

1. **Generate Age key pair** (or store in 1Password)
2. **Configure chezmoi encryption**:
   ```toml
   # ~/.config/chezmoi/chezmoi.toml
   encryption = "age"
   [age]
       identity = "~/.config/age-chezmoi.txt"
       recipient = "age1..."
   ```
3. **Encrypt sensitive files**:
   - Add `.age` suffix to encrypted templates
   - Example: `private_dot_ssh/private_id_ed25519.age`

### Benefits
- Sensitive files (SSH keys, API tokens, passwords) encrypted in git
- Safe to commit to public repository
- Decrypted only on `chezmoi apply`

## 3. Bootstrap Script Structure

### Proposed Flow
```
setup.sh
├── Install system dependencies (git, curl, gnupg)
├── Install 1Password (app + CLI)
├── Configure 1Password (interactive or sign-in)
├── Fetch secrets from 1Password
│   ├── Age encryption key → ~/.config/age-chezmoi.txt
│   ├── SSH keys → ~/.ssh/
│   └── Git signing key
├── Install chezmoi
├── Clone dotfiles repo (using 1Password SSH agent)
└── Run chezmoi init --apply (with encryption support)
```

### Multi-Stage Approach
- **Stage 1**: Minimal setup script (install deps, 1Password, chezmoi)
- **Stage 2**: chezmoi scripts (run_once_*, run_onchange_*) handle package installation
- Keeps setup.sh focused on bootstrapping, lets chezmoi handle everything else

## 4. Git Configuration via 1Password

### Current
- Git config hardcoded in templates with conditionals

### Proposed
- Store git user info in 1Password
- Fetch during setup:
  ```bash
  git config --global user.name "$(op item get git-config --fields name)"
  git config --global user.email "$(op item get git-config --fields email)"
  git config --global user.signingkey "$(op item get git-signing-key --fields 'public key')"
  ```

## 5. Machine-Specific Profiles

### Concept
- Use chezmoi data file to define machine profiles
- Example: `.chezmoidata.yaml`:
  ```yaml
  profile: "work"  # or "personal", "gaming", etc.
  ```
- Scripts install packages based on profile:
  ```go
  {{ if eq .profile "work" }}
  # Install work packages (azure-cli, terraform, etc.)
  {{ else if eq .profile "personal" }}
  # Install personal packages
  {{ end }}
  ```

### Current Implementation
- Separate YAML files per category (basic, work, terminal)
- Separate scripts per category
- All categories installed by default

### Alternative
- Single data file with profile flag
- Single script that reads profile and installs matching packages
- Trade-off: More complex templates vs. more files

## Resources

- [chezmoi 1Password Integration](https://www.chezmoi.io/user-guide/password-managers/1password/)
- [chezmoi Age Encryption](https://www.chezmoi.io/user-guide/encryption/age/)
- [jgoguen/dotfiles setup.sh](https://github.com/jgoguen/dotfiles/blob/main/setup.sh)
- [Age Encryption Tool](https://age-encryption.org/)
