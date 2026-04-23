---
name: llm-wiki-multihost
description: Use when maintaining a persistent Karpathy-style LLM wiki across multiple machines under hosts/$hostname, with immutable raw sources, per-host ingest/query/lint workflows, and strict secret hygiene (.env gitignored).
---

# LLM Wiki Multi-Host Skill

Multi-host adaptation of the Karpathy LLM wiki pattern.

## Trigger

Use this skill when the user asks to:
- bootstrap or maintain a wiki in `hosts/$hostname/`
- ingest sources into a host-specific knowledge base
- query/lint wiki health per host
- add new machine folders that mirror hostname

## Non-negotiable rules

1. Never edit `hosts/$hostname/raw/sources/` in place (immutable sources).
2. Never commit secrets. Keep local secrets in `.env` only.
3. `.env` must remain gitignored.
4. Every source gets a source-summary page before broad synthesis edits.
5. Update `hosts/$hostname/index.md` and `hosts/$hostname/log.md` on ingest/query/lint.
6. For cross-host relevance, also update root `index.md` / `log.md`.

## Structure

Per host:
- `hosts/$hostname/raw/{sources,assets}`
- `hosts/$hostname/wiki/{overview,topics,entities,sources,queries,lint}`
- `hosts/$hostname/index.md`
- `hosts/$hostname/log.md`

## Operations

### INGEST
1. Confirm target host path and source exists.
2. Summarize into `wiki/sources/`.
3. Update related `overview/topics/entities` pages.
4. Update host index.
5. Append host log entry (`## [YYYY-MM-DD] ingest | ...`).

### QUERY
1. Read root `index.md`, then host `index.md`.
2. Read relevant host pages and cite sources.
3. Save durable outputs to `wiki/queries/YYYY-MM-DD-<slug>.md`.
4. Append host log entry.

### LINT
1. Check contradictions, stale claims, orphans, missing links/pages.
2. Save report to `wiki/lint/YYYY-MM-DD-lint.md`.
3. Append host log entry.

## References
- `references/vault-structure.md`
- `references/workflows.md`
- `references/templates.md`

## Helpers
- `scripts/bootstrap_host.sh` — initialize host folder from hostname.
- `scripts/rebuild_indexes.py` — rebuild root + host indexes from filesystem.
