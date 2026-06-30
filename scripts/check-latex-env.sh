#!/usr/bin/env bash
set -u

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
strict=0

usage() {
  printf 'Usage: %s [--strict]\n' "$0" >&2
}

if [ "$#" -gt 1 ]; then
  usage
  exit 64
fi

if [ "$#" -eq 1 ]; then
  if [ "$1" = "--strict" ]; then
    strict=1
  else
    usage
    exit 64
  fi
fi

missing_production=0
missing_strict=0

print_tool() {
  category=$1
  tool=$2

  if command -v "$tool" >/dev/null 2>&1; then
    printf 'AVAILABLE  %-13s %-12s %s\n' "$category" "$tool" "$(command -v "$tool")"
  else
    printf 'MISSING    %-13s %s\n' "$category" "$tool"
    case "$category" in
      production) missing_production=1 ;;
      compatibility|qa) missing_strict=1 ;;
    esac
  fi
}

printf 'LaTeX environment check\n'
printf 'Repository: %s\n' "$repo_root"
printf 'OS: %s\n' "$(uname -s 2>/dev/null || printf unknown)"
printf 'Architecture: %s\n' "$(uname -m 2>/dev/null || printf unknown)"
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Mode: %s\n\n' "$(if [ "$strict" -eq 1 ]; then printf strict; else printf production; fi)"

for tool in latexmk lualatex biber kpsewhich; do
  print_tool production "$tool"
done

for tool in xelatex pdflatex bibtex makeindex; do
  print_tool compatibility "$tool"
done

for tool in chktex shellcheck pdfinfo; do
  print_tool qa "$tool"
done

for tool in bash git find; do
  print_tool utility "$tool"
done
print_tool optional tree

printf '\nRequired TeX files:\n'
manifest="$repo_root/config/latex-packages.txt"
if [ ! -f "$manifest" ]; then
  printf 'MISSING    manifest      %s\n' "$manifest"
  missing_production=1
elif ! command -v kpsewhich >/dev/null 2>&1; then
  printf 'SKIPPED    package resolution because kpsewhich is missing\n'
else
  while IFS= read -r tex_file || [ -n "$tex_file" ]; do
    case "$tex_file" in
      ''|\#*) continue ;;
    esac

    resolved=$(kpsewhich "$tex_file" 2>/dev/null || true)
    if [ -n "$resolved" ]; then
      printf 'AVAILABLE  %-13s %s\n' "$tex_file" "$resolved"
    else
      printf 'MISSING    package       %s\n' "$tex_file"
      missing_production=1
    fi
  done < "$manifest"
fi

if [ "$missing_production" -ne 0 ]; then
  printf '\nRESULT: FAIL - production LuaLaTeX/Biber requirements are missing.\n' >&2
  exit 1
fi

if [ "$strict" -eq 1 ] && [ "$missing_strict" -ne 0 ]; then
  printf '\nRESULT: FAIL - strict compatibility/QA requirements are missing.\n' >&2
  exit 1
fi

if [ "$missing_strict" -ne 0 ]; then
  printf '\nRESULT: PASS - production requirements are available; optional compatibility/QA gaps are listed above.\n'
else
  printf '\nRESULT: PASS - production, compatibility, and QA requirements are available.\n'
fi
