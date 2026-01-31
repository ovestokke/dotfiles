function theme-browse -d "Browse and preview all Oh My Posh themes interactively"
    # Require oh-my-posh and fzf
    if not type -q oh-my-posh
        echo "oh-my-posh is not installed"
        return 1
    end
    if not type -q fzf
        echo "fzf is not installed"
        return 1
    end

    # Save current theme to restore on cancel
    set -l original_theme $OMP_THEME

    echo "Fetching themes from GitHub..."

    # Fetch theme list from GitHub API and extract .omp.json filenames
    set -l theme_list (curl -sf "https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/contents/themes" \
        | string match -r '"name"\s*:\s*"[^"]+\.omp\.json"' \
        | string replace -r '"name"\s*:\s*"(.+)\.omp\.json"' '$1' \
        | sort)
    if test (count $theme_list) -eq 0; or test -z "$theme_list[1]"
        echo "Failed to fetch themes from GitHub"
        return 1
    end

    set -l base_url "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes"

    # Use fzf with live preview of each theme's prompt
    set -l pick (printf '%s\n' $theme_list | fzf \
        --ansi \
        --no-sort \
        --layout=reverse \
        --border \
        --prompt="Theme> " \
        --header="Arrow keys to browse | Enter to save | Esc to cancel | Current: $original_theme" \
        --preview="oh-my-posh print primary --config '$base_url/{}.omp.json' 2>/dev/null; echo; echo; oh-my-posh print secondary --config '$base_url/{}.omp.json' 2>/dev/null" \
        --preview-window="bottom,4,wrap")

    if test $status -ne 0; or test -z "$pick"
        echo "No changes made."
        return 0
    end

    # Apply selected theme
    set -U OMP_THEME $pick
    oh-my-posh init fish --config "$base_url/$pick.omp.json" | source
    echo "Theme set to: $pick"
end
