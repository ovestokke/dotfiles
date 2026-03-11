---
name: obsidian
description: "Documentation hub using Obsidian vault. Invoke with /obsidian."
version: 1.1.0
tools: Bash
user-invocable: true
disable-model-invocation: true
---

# Obsidian Documentation Hub

Interact with the user's Obsidian vault (`OveVault`) exclusively via the `obsidian` CLI.

**RULE: Never access vault files directly via the filesystem. Always use `obsidian` CLI commands.**

## Prerequisites

Before ANY operation, verify Obsidian is running:

```bash
obsidian vault info=name
```

If this fails, tell the user to open Obsidian and stop.

## CLI Reference

Key syntax rules:
- `file=<name>` resolves by name (like wikilinks)
- `path=<path>` is exact (e.g. `folder/note.md`)
- Quote values with spaces: `name="My Note"`
- Use `\n` for newline, `\t` for tab in `content=` values

## Commands

Parse the first argument after `/obsidian` as the command.

---

### `search <query>`

```bash
obsidian search:context query="QUERY"
```

Display results in a readable format with note names and matched context.

---

### `read <note>`

```bash
# By name (wikilink-style resolution):
obsidian read file="NOTE NAME"

# By exact path:
obsidian read path="Folder/Note.md"
```

---

### `write <path>`

Create or update a note. Path is relative to vault root.

- First check if it exists: `obsidian file path="PATH"`
- If it exists, **confirm with the user before overwriting**.

```bash
obsidian create path="PATH" content="CONTENT"
# Add 'overwrite' flag only after user confirms:
obsidian create path="PATH" content="CONTENT" overwrite
```

- Always include frontmatter (see convention below).

---

### `doc <topic>`

Create structured documentation from the current conversation context.

1. Determine the appropriate folder:
   - `Linux/` — system, CachyOS, kernel, packages, shell config
   - `Homelab/` — servers, networking, NFS, Docker, Unraid
   - `Gaming/` — gaming config, GPU, performance tuning
   - `Documentation/` — fallback for general reference

2. Generate a note title from the topic (Title Case, no special chars).

3. Use this template:

```markdown
---
created: YYYY-MM-DD
source: claude-code
tags:
  - <relevant-tag>
---

# Title

## Overview
Brief description of what this covers.

## Details
Main content and explanation.

## Commands / Configuration
Exact commands and config snippets in code blocks.

## Verification
How to verify it works.

## Related
[[wikilinks]] to related notes if applicable.
```

4. Create with:
```bash
obsidian create path="Folder/Note Title.md" content="ESCAPED_CONTENT"
```

5. If the topic relates to system changes, remind the user to also update `system-changes.md`.

---

### `daily <text>`

Append a timestamped entry to today's daily note.

```bash
# Append to today's daily note (Obsidian handles the path):
obsidian daily:append content="\n- **HH:MM** — TEXT"
```

If the daily note doesn't exist yet, open it first (Obsidian creates it from template):

```bash
obsidian daily
```

To read the current daily note:
```bash
obsidian daily:read
```

Get daily note path:
```bash
obsidian daily:path
```

---

### `list [folder]`

```bash
# List top-level folders:
obsidian folders

# List subfolders of a folder:
obsidian folders folder="FOLDER"

# List all markdown files:
obsidian files ext=md

# List files in a specific folder:
obsidian files folder="FOLDER" ext=md

# Get file count in a folder:
obsidian files folder="FOLDER" ext=md total

# Get info about a specific folder:
obsidian folder path="FOLDER" info=files
```

---

### `status`

Show a vault overview using CLI commands.

```bash
# Vault info
obsidian vault

# Total file count
obsidian files ext=md total

# Folder count
obsidian folders total

# Per top-level folder counts: run `obsidian folders` then
# `obsidian files folder="FOLDER" ext=md total` for each

# Recently opened files
obsidian recents

# Open tasks
obsidian tasks todo

# Tags sorted by usage
obsidian tags counts sort=count
```

Present as a formatted summary table.

---

## Frontmatter Convention

All notes created by this skill include:

```yaml
---
created: YYYY-MM-DD
source: claude-code
tags:
  - <relevant-tag>
---
```

Use today's date. Pick tags relevant to the content.

## Cross-References

Use `[[wikilinks]]` when referencing other notes. When creating `doc` notes, use `obsidian search query="TOPIC"` to find related notes and link to them.

## Creating Folders

The Obsidian CLI has no `mkdir` command. To create a new folder, create a note inside it (the folder is created automatically), then delete the placeholder if needed:

```bash
# Create folder by creating a note in it:
obsidian create path="New Folder/placeholder.md" content="placeholder"

# After moving/creating real notes, clean up:
obsidian delete path="New Folder/placeholder.md" permanent
```

The `move` command requires the target folder to exist first. Always create the folder before moving notes into it.

## Content Escaping

When using `obsidian create` or `obsidian append`:
- Newlines: `\n`
- Tabs: `\t`
- Quote values with spaces: `content="my content here"`
- For large content, prefer building the escaped string carefully before calling the command
