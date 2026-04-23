#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
HOSTNAME_ARG="${1:-$(hostname)}"
HOST_DIR="$ROOT_DIR/hosts/$HOSTNAME_ARG"
TODAY="$(date +%F)"

mkdir -p "$HOST_DIR/raw/sources" "$HOST_DIR/raw/assets"
mkdir -p "$HOST_DIR/wiki/overview" "$HOST_DIR/wiki/topics" "$HOST_DIR/wiki/entities" "$HOST_DIR/wiki/sources" "$HOST_DIR/wiki/queries" "$HOST_DIR/wiki/lint"

if [[ ! -f "$HOST_DIR/index.md" ]]; then
  cat > "$HOST_DIR/index.md" <<EOF
# Host Index: $HOSTNAME_ARG

## Overview

- [[hosts/$HOSTNAME_ARG/wiki/overview/host-overview|Host Overview]]
EOF
fi

if [[ ! -f "$HOST_DIR/log.md" ]]; then
  cat > "$HOST_DIR/log.md" <<EOF
# Host Log: $HOSTNAME_ARG

## [$TODAY] setup | host scaffold initialized
- Created host structure under \`hosts/$HOSTNAME_ARG\`.
EOF
fi

if [[ ! -f "$HOST_DIR/wiki/overview/host-overview.md" ]]; then
  cat > "$HOST_DIR/wiki/overview/host-overview.md" <<EOF
# Host Overview: $HOSTNAME_ARG

Describe this host's purpose, operating system, major services, and key troubleshooting domains.
EOF
fi

if [[ ! -f "$ROOT_DIR/index.md" ]]; then
  cat > "$ROOT_DIR/index.md" <<EOF
# System Wiki Index

## Hosts
EOF
fi

if ! rg -q "\[\[hosts/$HOSTNAME_ARG/index\|$HOSTNAME_ARG\]\]" "$ROOT_DIR/index.md"; then
  printf "- [[hosts/%s/index|%s]]\n" "$HOSTNAME_ARG" "$HOSTNAME_ARG" >> "$ROOT_DIR/index.md"
fi

if [[ ! -f "$ROOT_DIR/log.md" ]]; then
  cat > "$ROOT_DIR/log.md" <<EOF
# System Wiki Log
EOF
fi

printf "\n## [%s] setup | added host %s\n- Bootstrapped host scaffold with llm-wiki-multihost script.\n" "$TODAY" "$HOSTNAME_ARG" >> "$ROOT_DIR/log.md"

echo "Bootstrapped: hosts/$HOSTNAME_ARG"
