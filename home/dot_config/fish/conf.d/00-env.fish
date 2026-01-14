# Environment variables and paths

# Disable greeting
set -g fish_greeting

# Homebrew (macOS)
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
# Linuxbrew
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# 1Password SSH Agent
set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock

# XDG Base Directory
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache

# Path additions
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# Python 3.14 (macOS)
if test -d /Library/Frameworks/Python.framework/Versions/3.14/bin
    fish_add_path /Library/Frameworks/Python.framework/Versions/3.14/bin
end
