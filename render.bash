#!/usr/bin/env bash
set -euo pipefail

# Render open-source-qms.md to a PDF with citations resolved from refs.bib.
# Requires: pandoc and a PDF engine (tectonic).

cd "$(dirname "$0")"

SRC="open-source-qms.md"
BIB="refs.bib"
CSL="ieee.csl"  # numeric [1] citations, from citation-style-language/styles
OUT="open-source-qms.pdf"

# Preflight checks
command -v pandoc >/dev/null || {
  echo "error: pandoc not found on PATH" >&2
  exit 1
}
command -v tectonic >/dev/null || {
  echo "error: tectonic (PDF engine) not found. Install it, e.g." >&2
  echo "       'apt install tectonic' or see https://tectonic-typesetting.github.io" >&2
  exit 1
}

# The snap build of tectonic has a private /tmp and cannot see pandoc's default
# temp workdir. Use a non-hidden temp dir inside this project (reachable via
# snap's home interface) and clean it up on exit.
WORKDIR="$(mktemp -d "$PWD/render-tmp.XXXXXX")"
trap 'rm -rf "$WORKDIR"' EXIT
export TMPDIR="$WORKDIR"

pandoc "$SRC" \
  --citeproc \
  --bibliography="$BIB" \
  --csl="$CSL" \
  -M reference-section-title=References \
  --pdf-engine=tectonic \
  -V geometry:margin=1in \
  -o "$OUT"

echo "wrote $OUT"
