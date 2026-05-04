function claude-personal --description 'Launch Claude Code with personal account settings'
    env \
        -u CLAUDE_CODE_USE_FOUNDRY \
        -u ANTHROPIC_FOUNDRY_BASE_URL \
        -u ANTHROPIC_DEFAULT_SONNET_MODEL \
        -u ANTHROPIC_DEFAULT_HAIKU_MODEL \
        -u ANTHROPIC_DEFAULT_OPUS_MODEL \
        claude $argv
end
