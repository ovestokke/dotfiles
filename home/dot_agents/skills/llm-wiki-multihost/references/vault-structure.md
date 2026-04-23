# Multi-Host Vault Structure

```text
.
├─ AGENTS.md
├─ index.md                    # root catalog across hosts
├─ log.md                      # root append-only log
├─ hosts/
│  └─ $hostname/
│     ├─ index.md              # host catalog
│     ├─ log.md                # host append-only log
│     ├─ raw/
│     │  ├─ sources/           # immutable source files
│     │  └─ assets/            # local attachments
│     └─ wiki/
│        ├─ overview/
│        ├─ topics/
│        ├─ entities/
│        ├─ sources/
│        ├─ queries/
│        └─ lint/
└─ .agents/skills/llm-wiki-multihost/
```

## Naming

- Host directory must equal literal `hostname` output.
- Query/lint filenames should use `YYYY-MM-DD-<slug>.md`.

## Source IDs (optional but recommended)

Use stable IDs in source-summary filenames:
- `SRC-YYYY-MM-DD-NNN-<slug>.md`

This improves provenance and makes cross-references reliable.
