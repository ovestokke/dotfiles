# Catppuccin Mocha colors for Fish

if status is-interactive
    set -l foreground cdd6f4
    set -l selection 313244
    set -l comment 6c7086
    set -l red f38ba8
    set -l orange fab387
    set -l yellow f9e2af
    set -l green a6e3a1
    set -l purple cba6f7
    set -l cyan 94e2d5
    set -l pink f5c2e7

    # Syntax highlighting
    set -g fish_color_normal $foreground
    set -g fish_color_command $cyan
    set -g fish_color_keyword $pink
    set -g fish_color_quote $yellow
    set -g fish_color_redirection $foreground
    set -g fish_color_end $orange
    set -g fish_color_error $red
    set -g fish_color_param $purple
    set -g fish_color_comment $comment
    set -g fish_color_selection --background=$selection
    set -g fish_color_search_match --background=$selection
    set -g fish_color_operator $green
    set -g fish_color_escape $pink
    set -g fish_color_autosuggestion $comment
    set -g fish_pager_color_progress $comment
    set -g fish_pager_color_prefix $cyan
    set -g fish_pager_color_completion $foreground
    set -g fish_pager_color_description $comment
end
