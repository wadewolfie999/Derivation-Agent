#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH='' cd -- "$script_dir/.." && pwd -P)
engine=lualatex

usage() {
  printf 'Usage: %s [--engine lualatex|xelatex|pdflatex] <report-directory>\n' "$0" >&2
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

if [ "${1:-}" = "--engine" ]; then
  [ "$#" -ge 2 ] || { usage; exit 64; }
  engine=$2
  shift 2
fi

[ "$#" -eq 1 ] || { usage; exit 64; }

case "$engine" in
  lualatex) engine_flag=-lualatex ;;
  xelatex) engine_flag=-xelatex ;;
  pdflatex) engine_flag=-pdf ;;
  *) fail "unsupported engine '$engine'; choose lualatex, xelatex, or pdflatex" ;;
esac

report_input=$1
[ -d "$report_input" ] || fail "report directory does not exist: $report_input"
report_dir=$(CDPATH='' cd -- "$report_input" && pwd -P)
[ "$report_dir" != "/" ] || fail "refusing to use the filesystem root as a report directory"
[ -f "$report_dir/main.tex" ] || fail "missing report entry point: $report_dir/main.tex"

for tool in latexmk "$engine" biber; do
  command -v "$tool" >/dev/null 2>&1 || fail "required tool is unavailable: $tool"
done

if ! bash "$repo_root/scripts/check-latex-env.sh" >/dev/null; then
  bash "$repo_root/scripts/check-latex-env.sh" || true
  fail "production environment check failed"
fi

build_dir="$report_dir/build"
printf 'Building report\n'
printf '  report: %s\n' "$report_dir"
printf '  engine: %s\n' "$engine"
printf '  bibliography: BibLaTeX/Biber\n'
printf '  output: %s/main.pdf\n' "$build_dir"

rm -rf -- "$build_dir"
mkdir -p -- "$build_dir"

if ! (
  cd -- "$report_dir"
  latexmk -silent -r "$repo_root/.latexmkrc" "$engine_flag" \
    -outdir="$build_dir" -auxdir="$build_dir" main.tex
); then
  fail "LaTeX compilation failed; inspect $build_dir/main.log"
fi

pdf="$build_dir/main.pdf"
log="$build_dir/main.log"
blg="$build_dir/main.blg"

[ -s "$pdf" ] || fail "build completed without a nonempty PDF: $pdf"
[ -f "$log" ] || fail "build completed without the expected log: $log"

if grep -Eiq 'undefined references|Citation.+undefined|There were undefined references|Please \(re\)run Biber|undefined citations' "$log"; then
  fail "unresolved citation or cross-reference diagnostics remain in $log"
fi

if [ -f "$blg" ] && grep -Eq '^ERROR - ' "$blg"; then
  fail "Biber reported an error in $blg"
fi

printf 'RESULT: PASS - %s\n' "$pdf"
if command -v pdfinfo >/dev/null 2>&1; then
  pdfinfo "$pdf" | awk -F: '/^(Pages|Page size|PDF version):/ { sub(/^[[:space:]]+/, "", $2); printf "  %s: %s\n", $1, $2 }'
else
  printf '  PDF metadata check skipped: pdfinfo is unavailable\n'
fi
