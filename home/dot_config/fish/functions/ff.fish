function ff -d "Find files with fd + fzf and open the selected file"
    set -l finder fd
    if not type -q fd
        if type -q fdfind
            set finder fdfind
        else if type -q find
            set finder find
        else
            echo "ff: fd/fdfind/find is not installed"
            return 1
        end
    end

    set -l bat_cmd bat
    if not type -q bat
        if type -q batcat
            set bat_cmd batcat
        else
            set bat_cmd cat
        end
    end

    set -l preview "$bat_cmd --color=always --style=numbers --line-range :300 {}"
    if test "$bat_cmd" = cat
        set preview "sed -n '1,200p' {}"
    end

    set -l file
    if test "$finder" = find
        set file (
            find . -type f \
                -not -path './.git/*' \
                -not -path './Library/*' \
                2>/dev/null | \
            fzf --prompt 'files> ' \
                --height 80% \
                --layout reverse \
                --border \
                --info inline \
                --preview "$preview" \
                --preview-window 'right:60%'
        )
    else
        set file (
            $finder --type f \
                --hidden \
                --follow \
                --exclude .git \
                --exclude Library \
                2>/dev/null | \
            fzf --prompt 'files> ' \
                --height 80% \
                --layout reverse \
                --border \
                --info inline \
                --preview "$preview" \
                --preview-window 'right:60%'
        )
    end
    test -z "$file"; and return

    set -l editor $EDITOR
    test -z "$editor"; and set editor nvim

    command $editor -- $file
end
