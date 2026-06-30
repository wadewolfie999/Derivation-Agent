#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH='' cd -- "$script_dir/.." && pwd -P)
temp_rel=".factory-validation-$$"
temp_root="$repo_root/$temp_rel"
smoke_rel=examples/smoke-test-report

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

cleanup() {
  if [ -d "$temp_root" ] && [ ! -L "$temp_root" ]; then
    rm -rf -- "$temp_root"
  fi
  if [ -d "$repo_root/$smoke_rel/build" ] && [ ! -L "$repo_root/$smoke_rel/build" ]; then
    rm -rf -- "$repo_root/$smoke_rel/build"
  fi
}
trap cleanup EXIT HUP INT TERM

cd -- "$repo_root"
printf 'Validating LaTeX factory in %s\n' "$repo_root"

bash scripts/check-latex-env.sh
bash scripts/lint-report.sh "$smoke_rel"
bash scripts/build-report.sh "$smoke_rel"
bash scripts/clean-latex.sh "$smoke_rel"
bash scripts/clean-latex.sh "$smoke_rel"

if command -v xelatex >/dev/null 2>&1; then
  bash scripts/build-report.sh --engine xelatex "$smoke_rel"
  bash scripts/clean-latex.sh "$smoke_rel"
else
  printf 'SKIP: XeLaTeX compatibility build; xelatex is unavailable.\n'
fi

if command -v pdflatex >/dev/null 2>&1; then
  bash scripts/build-report.sh --engine pdflatex "$smoke_rel"
  bash scripts/clean-latex.sh "$smoke_rel"
else
  printf 'SKIP: PDFLaTeX compatibility build; pdflatex is unavailable.\n'
fi

bash scripts/new-report.sh basic "$temp_rel/basic"
bash scripts/new-report.sh physics "$temp_rel/physics"

if bash scripts/new-report.sh basic "$temp_rel/basic" >/dev/null 2>&1; then
  fail "new-report accepted an existing destination"
fi

if bash scripts/new-report.sh basic ../unsafe-report >/dev/null 2>&1; then
  fail "new-report accepted a traversal destination"
fi

if bash scripts/build-report.sh --engine invalid "$smoke_rel" >/dev/null 2>&1; then
  fail "build-report accepted an invalid engine"
fi

if bash scripts/build-report.sh "$temp_rel/missing" >/dev/null 2>&1; then
  fail "build-report accepted a missing report directory"
fi

for report in "$temp_rel/basic" "$temp_rel/physics"; do
  bash scripts/lint-report.sh "$report"
  bash scripts/build-report.sh "$report"
  bash scripts/clean-latex.sh "$report"
done

printf 'RESULT: PASS - factory regression validation completed.\n'
