#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd -P)

usage() {
  printf 'Usage: %s <report-directory>\n' "$0" >&2
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

[ "$#" -eq 1 ] || { usage; exit 64; }
[ -d "$1" ] || fail "report directory does not exist: $1"
command -v chktex >/dev/null 2>&1 || fail "ChkTeX is unavailable; run scripts/check-latex-env.sh"

report_dir=$(CDPATH= cd -- "$1" && pwd -P)
[ -f "$report_dir/main.tex" ] || fail "missing report entry point: $report_dir/main.tex"

printf 'Linting report with ChkTeX: %s\n' "$report_dir"
set +e
(
  cd -- "$report_dir"
  chktex -q -I1 -l "$repo_root/.chktexrc" main.tex
)
status=$?
set -e

case "$status" in
  0)
    printf 'RESULT: PASS - no ChkTeX diagnostics.\n'
    ;;
  2)
    printf 'RESULT: PASS WITH WARNINGS - review ChkTeX diagnostics without changing scientific meaning.\n'
    ;;
  *)
    fail "ChkTeX failed with status $status"
    ;;
esac
