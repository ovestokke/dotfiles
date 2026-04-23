# Workflows

## 1) Bootstrap host

- Run: `./.agents/skills/llm-wiki-multihost/scripts/bootstrap_host.sh`
- Optional: pass explicit name `bootstrap_host.sh my-hostname`

Creates required folders and starter pages.

## 2) Ingest source

1. Copy source file into `hosts/$hostname/raw/sources/`.
2. Create summary in `hosts/$hostname/wiki/sources/`.
3. Update related `overview/topics/entities` pages.
4. Update `hosts/$hostname/index.md`.
5. Append `hosts/$hostname/log.md`.

## 3) Query and file results

1. Read root index, then host index.
2. Synthesize with citations.
3. Save durable result to `hosts/$hostname/wiki/queries/`.
4. Append host log.

## 4) Lint

1. Detect contradictions, stale pages, orphan pages, weak linking.
2. Write report to `hosts/$hostname/wiki/lint/`.
3. Append host log.

## 5) Rebuild indexes

- Run: `python3 ./.agents/skills/llm-wiki-multihost/scripts/rebuild_indexes.py`

Regenerates root `index.md` and host `index.md` from discovered files.
