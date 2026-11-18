#!/usr/bin/env bash
# Build examples/sample.md from another folder and fail on any WeasyPrint warning or a missing PDF.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPO
OUT="$(mktemp -d -t swiss-doc-test)"
readonly OUT
trap 'rm -rf "${OUT:?}"' EXIT

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

# From outside the kit, with a relative output folder: the pinned tools and paths must still resolve.
cd "$OUT"
"$REPO/bin/swiss-doc" -o pdf "$REPO/examples/sample.md" >/dev/null 2>stderr || fail "swiss-doc exited non-zero: $(cat stderr)"
[[ ! -s stderr ]] || fail "warnings while building: $(cat stderr)"
[[ "$(head -c 5 pdf/sample.pdf)" == "%PDF-" ]] || fail "pdf/sample.pdf is not a PDF"
echo "ok: sample.pdf"
