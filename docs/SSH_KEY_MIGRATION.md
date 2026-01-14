# SSH Key Management with Age Encryption

**Date:** 2026-01-14
**Goal:** Migrate from 1Password SSH/git signing to Age-encrypted keys in chezmoi
**Approach:** Option 1 - Key-based encryption (automatic decryption)

---

## Problem Statement

- Using 1Password for SSH agent and git signing (costs money)
- Need to share SSH/signing keys across devices (Linux, macOS, Windows)
- Proton Pass SSH agent is clunky (requires auth sessions, background service)
- Want elegant, cross-platform solution

## Solution: Age Encryption + Chezmoi

### Architecture

```
Age Identity Key (stored in Proton Pass)
    ↓
Encrypts SSH Private Keys
    ↓
Encrypted keys stored in chezmoi repo (git-tracked)
    ↓
Chezmoi auto-decrypts on each device
    ↓
Standard SSH/git signing just works
```

### Why This Works

1. **Cross-platform**: Age works on Linux/macOS/Windows
2. **Built-in**: Chezmoi has native Age support
3. **Automatic**: No passphrase prompts, no background services
4. **Secure**: Keys encrypted in git, only decrypted locally
5. **Simple**: One Age key syncs via Proton Pass (free)

### Security Model

- Age identity key protected by file permissions (like SSH keys)
- Encrypted keys safe in git repo (useless without Age key)
- Same threat model as storing SSH keys directly
- Added benefit: keys encrypted at rest in version control

---

## Implementation Steps

### Phase 1: Setup Age Encryption

#### 1.1 Install Age
```bash
# Linux (CachyOS/Arch)
sudo pacman -S age

# macOS
brew install age

# Windows
winget install FiloSottile.age
```

#### 1.2 Generate Age Identity Key
```bash
# Create chezmoi config directory
mkdir -p ~/.config/chezmoi

# Generate Age key
age-keygen -o ~/.config/chezmoi/key.txt

# Set proper permissions (Unix)
chmod 600 ~/.config/chezmoi/key.txt
```

Output will show:
```
# created: 2026-01-14T21:30:00+01:00
# public key: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AGE-SECRET-KEY-1XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**Important:** Save the public key - we'll need it for encryption

#### 1.3 Configure Chezmoi to Use Age
```bash
# Create/edit chezmoi config
cat >> ~/.config/chezmoi/chezmoi.toml << 'EOF'
encryption = "age"
[age]
    identity = "~/.config/chezmoi/key.txt"
    recipient = "age1xxxxxxxxxx"  # Your public key from step 1.2
EOF
```

### Phase 2: Encrypt SSH Keys

#### 2.1 Locate Current SSH Key
```bash
# Check for existing SSH key
ls -la ~/.ssh/id_ed25519

# View public key
cat ~/.ssh/id_ed25519.pub
```

Current signing key (from gitconfig):
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7yAfFk29GTdBYRYorVyYpDHVv/0cWwjtGrcnaqrAEm
```

#### 2.2 Add Private Key to Chezmoi (Encrypted)
```bash
# Add SSH private key - chezmoi will encrypt it automatically
chezmoi add --encrypt ~/.ssh/id_ed25519

# Verify it was encrypted
ls -la ~/.local/share/chezmoi/home/private_dot_ssh/

# Should see: private_encrypted_id_ed25519.age
```

#### 2.3 Add Public Key (No Encryption Needed)
```bash
# Public keys don't need encryption
chezmoi add ~/.ssh/id_ed25519.pub

# Add SSH config if you have one
chezmoi add ~/.ssh/config
```

### Phase 3: Update Git Configuration

#### 3.1 Update gitconfig Template
Remove 1Password signing, use standard SSH key:

```toml
[gpg]
    format = ssh
[gpg "ssh"]
    {{- if eq .chezmoi.os "windows" }}
    program = "C:/Windows/System32/OpenSSH/ssh-keygen.exe"
    {{- else }}
    program = /usr/bin/ssh-keygen
    {{- end }}
[commit]
    gpgsign = true
[user]
    signingkey = ~/.ssh/id_ed25519.pub
```

Location: `home/private_dot_gitconfig.tmpl`

#### 3.2 Remove 1Password Plugin from Zsh
Edit `home/dot_zshrc.tmpl`:
```diff
- plugins=(git 1password terraform)
+ plugins=(git terraform)
```

#### 3.3 Remove Proton Pass Systemd Service
```bash
# Disable the failing service
systemctl --user disable --now proton-pass-ssh-agent.service

# Remove from chezmoi
chezmoi forget ~/.config/systemd/user/proton-pass-ssh-agent.service
```

### Phase 4: Test on Current Device

#### 4.1 Apply Changes
```bash
# Preview changes
chezmoi diff

# Apply (keys will be decrypted)
chezmoi apply -v

# Verify SSH key permissions
ls -la ~/.ssh/id_ed25519
# Should be: -rw------- (600)
```

#### 4.2 Test SSH Connection
```bash
# Test SSH to Hetzner VM
ssh root@46.224.94.101

# Verify key is loaded
ssh-add -l
```

#### 4.3 Test Git Signing
```bash
# Test commit signing
cd /tmp
git init test-signing
cd test-signing
echo "test" > test.txt
git add test.txt
git commit -m "test signing"

# Verify signature
git log --show-signature
```

### Phase 5: Store Age Key in Proton Pass

#### 5.1 Copy Age Key
```bash
# Display Age private key
cat ~/.config/chezmoi/key.txt
```

#### 5.2 Store in Proton Pass
1. Open Proton Pass
2. Create new secure note: "Chezmoi Age Identity Key"
3. Paste contents of `key.txt`
4. Add tags: `chezmoi`, `ssh`, `dotfiles`

#### 5.3 Add Bootstrap Instructions
In the same note, add:
```
## Bootstrap on New Device

1. Install chezmoi:
   - Linux: pacman -S chezmoi age
   - macOS: brew install chezmoi age
   - Windows: winget install twpayne.chezmoi FiloSottile.age

2. Create config directory:
   mkdir -p ~/.config/chezmoi

3. Copy Age key to ~/.config/chezmoi/key.txt
   chmod 600 ~/.config/chezmoi/key.txt (Unix only)

4. Initialize chezmoi:
   chezmoi init https://github.com/ovestokke/dotfiles.git
   chezmoi apply

5. Done! SSH keys are decrypted and ready.
```

### Phase 6: Commit and Push

```bash
cd ~/.local/share/chezmoi

# Check status
git status

# Commit changes
git add -A
git commit -m "feat: migrate to Age-encrypted SSH keys

- Remove 1Password SSH agent dependency
- Encrypt SSH private keys with Age
- Update gitconfig to use standard SSH signing
- Remove 1Password zsh plugin
- Remove Proton Pass SSH agent systemd service

Keys now encrypted in repo, synced via chezmoi"

# Push to remote
git push
```

---

## Testing on Other Devices

### Linux / macOS

```bash
# 1. Install dependencies
# Linux: sudo pacman -S chezmoi age
# macOS: brew install chezmoi age

# 2. Copy Age key from Proton Pass
mkdir -p ~/.config/chezmoi
# Paste key content into:
nano ~/.config/chezmoi/key.txt
chmod 600 ~/.config/chezmoi/key.txt

# 3. Initialize chezmoi
chezmoi init https://github.com/ovestokke/dotfiles.git
chezmoi apply

# 4. Test
ssh root@46.224.94.101
```

### Windows

```powershell
# 1. Install dependencies
winget install twpayne.chezmoi FiloSottile.age

# 2. Copy Age key from Proton Pass
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\chezmoi"
# Paste key content into:
notepad "$env:USERPROFILE\.config\chezmoi\key.txt"

# 3. Initialize chezmoi
chezmoi init https://github.com/ovestokke/dotfiles.git
chezmoi apply

# 4. Test
ssh root@46.224.94.101
```

---

## Troubleshooting

### Keys Not Decrypting
```bash
# Check Age key is in place
cat ~/.config/chezmoi/key.txt

# Check chezmoi config
cat ~/.config/chezmoi/chezmoi.toml

# Try manual decryption test
age -d -i ~/.config/chezmoi/key.txt ~/.local/share/chezmoi/home/private_encrypted_id_ed25519.age
```

### Wrong Permissions
```bash
# Unix: Fix SSH key permissions
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Windows: Use icacls
icacls %USERPROFILE%\.ssh\id_ed25519 /inheritance:r
icacls %USERPROFILE%\.ssh\id_ed25519 /grant:r "%USERNAME%:F"
```

### Git Signing Fails
```bash
# Test SSH signing directly
echo "test" | ssh-keygen -Y sign -n file -f ~/.ssh/id_ed25519

# Check git config
git config --get gpg.format  # Should be: ssh
git config --get user.signingkey  # Should be: ~/.ssh/id_ed25519.pub
```

---

## Benefits of This Approach

✅ **No monthly costs** (vs 1Password)
✅ **Cross-platform** (Linux, macOS, Windows)
✅ **No background services** (vs Proton Pass SSH agent)
✅ **Automatic decryption** (no passphrase prompts)
✅ **Version controlled** (encrypted keys in git)
✅ **Simple bootstrap** (copy one key, run chezmoi)
✅ **Standard tools** (SSH, git, age, chezmoi)
✅ **Offline-capable** (no cloud service required after setup)

---

## Files Modified

- `home/private_dot_gitconfig.tmpl` - Updated git signing config
- `home/dot_zshrc.tmpl` - Removed 1Password plugin
- `home/private_encrypted_dot_ssh/private_encrypted_id_ed25519.age` - Encrypted SSH key (new)
- `home/dot_ssh/id_ed25519.pub` - Public key (new)
- `~/.config/chezmoi/chezmoi.toml` - Age configuration (new)
- `~/.config/chezmoi/key.txt` - Age identity key (NOT in repo, stored in Proton Pass)

---

## Next Steps

- [ ] Install age
- [ ] Generate Age identity key
- [ ] Configure chezmoi for Age encryption
- [ ] Encrypt SSH private key
- [ ] Update gitconfig template
- [ ] Remove 1Password/Proton Pass dependencies
- [ ] Test SSH connection
- [ ] Test git signing
- [ ] Store Age key in Proton Pass
- [ ] Commit and push changes
- [ ] Test on macOS
- [ ] Test on Windows
