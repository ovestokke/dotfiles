function frg -d "Search file contents with rg + fzf and open the selected match"
    if not type -q rg
        echo "frg: rg is not installed"
        return 1
    end

    set -l query (string join ' ' -- $argv)
    if test -z "$query"
        echo "usage: frg <search text>"
        return 1
    end

    set -l bat_cmd bat
    if not type -q bat
        if type -q batcat
            set bat_cmd batcat
        else
            set bat_cmd cat
        end
    end

    set -l preview "$bat_cmd --color=always --style=numbers --highlight-line {2} {1}"
    if test "$bat_cmd" = cat
        set preview "sed -n '1,200p' {1}"
    end

    set -l result (
        rg --line-number --column --no-heading --smart-case \
            --glob '!.git/**' \
            --glob '!Library/**' \
            -- "$query" 2>/dev/null | \
        fzf --delimiter : \
            --prompt 'rg> ' \
            --height 80% \
            --layout reverse \
            --border \
            --info inline \
            --preview "$preview" \
            --preview-window 'right:60%:+{2}-/2'
    )
    test -z "$result"; and return

    set -l parts (string split -m 3 : -- $result)
    set -l file $parts[1]
    set -l line $parts[2]

    set -l editor $EDITOR
    test -z "$editor"; and set editor nvim

    command $editor +$line -- $file
end
