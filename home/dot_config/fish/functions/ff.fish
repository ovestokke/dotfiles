function ff
    $EDITOR (fd --type f | fzf --preview 'bat --color=always --style=numbers {}')
end
