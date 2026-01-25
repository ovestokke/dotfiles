# Abbreviations (expanded on command line for better history and completions)

if status is-interactive
    # Editor
    abbr --add vim nvim
    abbr --add v nvim

    # Quick commands
    abbr --add c clear
    abbr --add q exit

    # eza (better ls)
    if type -q eza
        abbr --add ls 'eza --icons --group-directories-first'
        abbr --add ll 'eza -la --icons --group-directories-first'
        abbr --add la 'eza -a --icons --group-directories-first'
        abbr --add lt 'eza --tree --icons --group-directories-first'
        abbr --add l 'eza -l --icons --group-directories-first'
    end

    # bat (better cat)
    if type -q bat
        abbr --add cat 'bat --style=plain'
        abbr --add catp bat
    end

    # fd (better find) - handle both 'fd' and 'fdfind' names
    if type -q fdfind
        abbr --add fd fdfind
    end

    # ripgrep
    if type -q rg
        abbr --add grep rg
    end

    # Git
    abbr --add g git
    abbr --add gs 'git status'
    abbr --add ga 'git add'
    abbr --add gc 'git commit'
    abbr --add gp 'git push'
    abbr --add gl 'git pull'
    abbr --add gd 'git diff'
    abbr --add gco 'git checkout'
    abbr --add gb 'git branch'
    abbr --add glog 'git log --oneline --graph --decorate'

    # Chezmoi
    abbr --add ch chezmoi
    abbr --add chd 'chezmoi diff'
    abbr --add chst 'chezmoi status'
    abbr --add chdoc 'chezmoi doctor'
    abbr --add cha 'chezmoi add'
    abbr --add chr 'chezmoi re-add'
    abbr --add che 'chezmoi edit'
    abbr --add chea 'chezmoi edit --apply'
    abbr --add chcd 'chezmoi cd'
    abbr --add chap 'chezmoi apply'
    abbr --add chup 'chezmoi update'
    abbr --add chug 'chezmoi upgrade'
    abbr --add dotsync 'cd (chezmoi source-path) && git add . && git commit && git pull --rebase && git push'

    # Chezmoi completions
    if type -q chezmoi
        chezmoi completion fish | source
    end

    # Custum application abbr
    #
    if type -q flatpak
        alias gittyup='flatpak run com.github.Murmele.Gittyup'
    end

    # Zoxide: smart cd function (defined in 10-tools.fish)
    # Use 'z' for zoxide jumps, 'cd' works normally for paths

    # Python
    abbr --add python python3
end
