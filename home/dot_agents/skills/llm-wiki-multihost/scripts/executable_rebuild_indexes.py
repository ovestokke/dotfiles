#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
HOSTS = ROOT / "hosts"


def rel(p: Path) -> str:
    return p.relative_to(ROOT).as_posix()


def host_index(host_dir: Path) -> str:
    h = host_dir.name
    lines = [f"# Host Index: {h}", "", "## Overview", ""]

    overview = host_dir / "wiki" / "overview" / "host-overview.md"
    if overview.exists():
        lines.append(f"- [[{rel(overview.with_suffix(''))}|Host Overview]]")

    lines += ["", "## Source summaries", ""]
    for p in sorted((host_dir / "wiki" / "sources").glob("*.md")):
        stem = rel(p.with_suffix(""))
        lines.append(f"- [[{stem}|{p.stem}]]")

    lines += ["", "## Topic pages", ""]
    for p in sorted((host_dir / "wiki" / "topics").glob("*.md")):
        stem = rel(p.with_suffix(""))
        lines.append(f"- [[{stem}|{p.stem}]]")

    lines += ["", "## Entity pages", ""]
    for p in sorted((host_dir / "wiki" / "entities").glob("*.md")):
        stem = rel(p.with_suffix(""))
        lines.append(f"- [[{stem}|{p.stem}]]")

    lines += ["", "## Raw sources", ""]
    for p in sorted((host_dir / "raw" / "sources").glob("*")):
        if p.is_file():
            lines.append(f"- `{rel(p)}`")

    return "\n".join(lines) + "\n"


def root_index(host_dirs: list[Path]) -> str:
    lines = ["# System Wiki Index", "", "## Hosts", ""]
    for h in sorted(host_dirs, key=lambda p: p.name):
        lines.append(f"- [[hosts/{h.name}/index|{h.name}]]")
    lines += ["", "## Shared docs", "", "- [[AGENTS]]", "- [[README]]"]
    return "\n".join(lines) + "\n"


def main() -> None:
    host_dirs = [p for p in HOSTS.iterdir() if p.is_dir()] if HOSTS.exists() else []

    (ROOT / "index.md").write_text(root_index(host_dirs), encoding="utf-8")
    for h in host_dirs:
        (h / "index.md").write_text(host_index(h), encoding="utf-8")

    print(f"Rebuilt root index + {len(host_dirs)} host index file(s)")


if __name__ == "__main__":
    main()
