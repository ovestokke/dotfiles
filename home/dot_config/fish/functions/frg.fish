function frg
    set -l query $argv
    set -l result (rg -n "$query" | fzf --delimiter : --preview 'bat --color=always --style=numbers --highlight-line {2} {1}')
    test -z "$result"; and return

    set -l file (string split -f1 : $result)
    set -l line (string split -f2 : $result)

    $EDITOR +$line $file
end
