function theme-random -d "Apply a random Oh My Posh theme from the repo"
    if not type -q oh-my-posh
        echo "oh-my-posh is not installed"
        return 1
    end

    echo "Fetching themes from GitHub..."

    set -l theme_list (curl -sf "https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/contents/themes" \
        | string match -r '"name"\s*:\s*"[^"]+\.omp\.json"' \
        | string replace -r '"name"\s*:\s*"(.+)\.omp\.json"' '$1')
    if test (count $theme_list) -eq 0; or test -z "$theme_list[1]"
        echo "Failed to fetch themes from GitHub"
        return 1
    end

    set -l pick $theme_list[(random 1 (count $theme_list))]
    set -l base_url "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes"

    set -U OMP_THEME $pick
    oh-my-posh init fish --config "$base_url/$pick.omp.json" | source
    echo "Theme set to: $pick"
end
