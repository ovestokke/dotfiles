# Tool initializations

if status is-interactive
    # VS Code shell integration
    if test "$TERM_PROGRAM" = vscode
        source (code --locate-shell-integration-path fish)
    end

    # Initialize Oh My Posh prompt
    if type -q oh-my-posh
        oh-my-posh init fish --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json | source
    end

    # Initialize zoxide (better cd)
    if type -q zoxide
        zoxide init fish | source
    end
end
