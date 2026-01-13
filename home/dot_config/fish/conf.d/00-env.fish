# Environment variables and paths

# Disable greeting
set -g fish_greeting

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# XDG Base Directory
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache

# Path additions
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
