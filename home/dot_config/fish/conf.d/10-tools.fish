# Tool initializations

if status is-interactive
    # VS Code shell integration
    if test "$TERM_PROGRAM" = vscode
        source (code --locate-shell-integration-path fish)
    end

    # Oh My Posh themes (user curated)
    set -g OMP_THEMES \
        catppuccin_mocha \
        powerlevel10k_rainbow \
        gruvbox \
        night-owl \
        blueish \
        atomic \
        negligible \
        quick-term \
        cert \
        iterm2 \
        jblab_2021 \
        wholespace \
        M365Princess \
        blue-owl \
        clean-detailed \
        easy-term \
        unicorn \
        if_tea \
        kushal \
        multiverse-neon \
        montys \
        mojada \
        microverse-power \
        paradox

    # Default theme (use universal variable to persist across sessions)
    if not set -q OMP_THEME
        set -U OMP_THEME catppuccin_mocha
    end

    # Function to switch themes
    function theme -d "Switch Oh My Posh theme"
        if test (count $argv) -eq 0
            echo "Current: $OMP_THEME"
            echo "Available themes:"
            for t in $OMP_THEMES
                if test "$t" = "$OMP_THEME"
                    echo "  * $t (active)"
                else
                    echo "    $t"
                end
            end
            echo ""
            echo "Usage: theme <name>  - switch to theme"
            echo "       theme next    - cycle to next theme"
            return
        end

        set -l new_theme $argv[1]

        # Handle 'next' to cycle through themes
        if test "$new_theme" = next
            set -l idx 1
            for i in (seq (count $OMP_THEMES))
                if test "$OMP_THEMES[$i]" = "$OMP_THEME"
                    set idx $i
                    break
                end
            end
            set idx (math $idx % (count $OMP_THEMES) + 1)
            set new_theme $OMP_THEMES[$idx]
        end

        set -U OMP_THEME $new_theme
        oh-my-posh init fish --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$new_theme.omp.json" | source
        echo "Switched to: $new_theme"
    end

    # Initialize Oh My Posh prompt
    if type -q oh-my-posh
        oh-my-posh init fish --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$OMP_THEME.omp.json" | source
    end

    # Initialize zoxide (better cd) — --cmd cd replaces cd and adds cdi for interactive fzf
    if type -q zoxide
        zoxide init fish --cmd cd | source
    end
end
