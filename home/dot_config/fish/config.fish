if status is-interactive
    # No greeting
    set fish_greeting

    # Use starship prompt
    if command -v starship &>/dev/null
        starship init fish | source
    end

    # Apply terminal color sequences (Material You from wallpaper)
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'" # fix: kitty doesn't clear scrollback properly
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    if command -v eza &>/dev/null
        alias ls 'eza --icons'
    end
    alias q 'qs -c ii'

    function claude-foundry --description 'Launch Claude Code against CapNordicLabs Foundry'
        if not command -q az
            echo 'Azure CLI (az) is not installed.' >&2
            return 1
        end

        set -l tenant aadb22c3-36ab-457d-bc2b-26ee6196220a
        set -l certs $HOME/.certs/cacerts.pem
        set -l current_tenant (az account show --query tenantId -o tsv 2>/dev/null)

        if test -z "$current_tenant"; or test "$current_tenant" != "$tenant"
            az login --tenant $tenant
            or return $status
        end

        if test -f $certs
            env \
                NODE_EXTRA_CA_CERTS=$certs \
                CLAUDE_CODE_USE_FOUNDRY=1 \
                ANTHROPIC_FOUNDRY_BASE_URL=https://foundry-ccaclaudefoundry-swe.services.ai.azure.com/anthropic/ \
                ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-latest \
                ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-latest \
                ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-latest \
                claude $argv
        else
            env \
                CLAUDE_CODE_USE_FOUNDRY=1 \
                ANTHROPIC_FOUNDRY_BASE_URL=https://foundry-ccaclaudefoundry-swe.services.ai.azure.com/anthropic/ \
                ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-latest \
                ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-latest \
                ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-latest \
                claude $argv
        end
    end

    function claude-personal --description 'Launch Claude Code with personal account settings'
        env \
            -u CLAUDE_CODE_USE_FOUNDRY \
            -u ANTHROPIC_FOUNDRY_BASE_URL \
            -u ANTHROPIC_DEFAULT_SONNET_MODEL \
            -u ANTHROPIC_DEFAULT_HAIKU_MODEL \
            -u ANTHROPIC_DEFAULT_OPUS_MODEL \
            claude $argv
    end
end
export PATH="$HOME/.local/bin:$PATH"
