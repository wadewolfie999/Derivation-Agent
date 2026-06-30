#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s <report-directory>\n' "$0" >&2
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

[ "$#" -eq 1 ] || { usage; exit 64; }
[ -d "$1" ] || fail "report directory does not exist: $1"

report_dir=$(CDPATH= cd -- "$1" && pwd -P)
[ "$report_dir" != "/" ] || fail "refusing to use the filesystem root as a report directory"
[ -f "$report_dir/main.tex" ] || fail "missing report entry point: $report_dir/main.tex"

build_dir="$report_dir/build"
if [ ! -e "$build_dir" ]; then
  printf 'Nothing to clean: %s\n' "$build_dir"
  exit 0
fi

[ ! -L "$build_dir" ] || fail "refusing to remove a symlinked build directory: $build_dir"
rm -rf -- "$build_dir"
printf 'Removed generated LaTeX output: %s\n' "$build_dir"
