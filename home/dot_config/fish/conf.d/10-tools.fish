# Tool initializations

# Initialize Oh My Posh prompt
if status is-interactive
    if type -q oh-my-posh
        oh-my-posh init fish --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json | source
    end

    # Initialize zoxide (better cd)
    if type -q zoxide
        zoxide init fish | source
    end
end
