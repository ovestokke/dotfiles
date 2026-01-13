# Fish shell configuration

# Disable greeting
set -g fish_greeting

# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim

# XDG Base Directory
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache

# Path additions
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# Initialize Oh My Posh prompt
if type -q oh-my-posh
    oh-my-posh init fish --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json | source
end

# Initialize zoxide (better cd)
if type -q zoxide
    zoxide init fish | source
end

# Aliases
alias vim="nvim"
alias v="nvim"
alias c="clear"
alias q="exit"

# eza (better ls)
if type -q eza
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -la --icons --group-directories-first"
    alias la="eza -a --icons --group-directories-first"
    alias lt="eza --tree --icons --group-directories-first"
    alias l="eza -l --icons --group-directories-first"
end

# bat (better cat)
if type -q bat
    alias cat="bat --style=plain"
    alias catp="bat"
end

# fd (better find) - handle both 'fd' and 'fdfind' names
if type -q fdfind
    alias fd="fdfind"
end

# ripgrep
if type -q rg
    alias grep="rg"
end

# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# Chezmoi aliases
alias ch="chezmoi"
alias chd="chezmoi diff"
alias chst="chezmoi status"
alias cha="chezmoi add"
alias chr="chezmoi re-add"
alias che="chezmoi edit"
alias chea="chezmoi edit --apply"
alias chcd="chezmoi cd"
alias chap="chezmoi apply"
alias chup="chezmoi update"
alias dotsync="chezmoi git add . && chezmoi git commit && chezmoi git pull --rebase && chezmoi git push"

# Catppuccin Mocha colors for Fish
set -l foreground cdd6f4
set -l selection 313244
set -l comment 6c7086
set -l red f38ba8
set -l orange fab387
set -l yellow f9e2af
set -l green a6e3a1
set -l purple cba6f7
set -l cyan 94e2d5
set -l pink f5c2e7

# Syntax highlighting
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
