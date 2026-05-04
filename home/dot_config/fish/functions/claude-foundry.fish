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

    if not test -f $certs
        echo "Warning: CA cert file not found at $certs" >&2
        echo "To create it, run:" >&2
        echo "  mkdir -p ~/.certs && security find-certificate -ap /Library/Keychains/System.keychain > ~/.certs/cacerts.pem" >&2
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
