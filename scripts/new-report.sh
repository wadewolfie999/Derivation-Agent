#!/usr/bin/env bash
set -euo pipefail
set -f

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH='' cd -- "$script_dir/.." && pwd -P)

usage() {
  printf 'Usage: %s <basic|physics> <relative-destination>\n' "$0" >&2
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

[ "$#" -eq 2 ] || { usage; exit 64; }

template_name=$1
destination=$2

case "$template_name" in
  basic) template_dir="$repo_root/templates/report-basic" ;;
  physics) template_dir="$repo_root/templates/report-physics" ;;
  *) fail "unknown template '$template_name'; choose basic or physics" ;;
esac

case "$destination" in
  ''|.|..|/*|../*|*/../*|*/..) fail "destination must be a safe repository-relative path" ;;
esac

current=$repo_root
IFS=/ read -r -a components <<< "$destination"
for component in "${components[@]}"; do
  [ -n "$component" ] || fail "destination contains an empty path component"
  current="$current/$component"
  [ ! -L "$current" ] || fail "destination traverses a symlink: $current"
done

destination_path="$repo_root/$destination"
if [ -e "$destination_path" ] || [ -L "$destination_path" ]; then
  fail "destination already exists: $destination_path"
fi
[ -d "$template_dir" ] || fail "template directory is missing: $template_dir"

mkdir -p -- "$(dirname -- "$destination_path")"
cp -R -- "$template_dir" "$destination_path"

for required in main.tex sections/introduction.tex references.bib figures/.gitkeep; do
  [ -e "$destination_path/$required" ] || fail "scaffold is incomplete: $required"
done

printf 'Created %s report: %s\n' "$template_name" "$destination_path"
printf 'Next: bash scripts/build-report.sh %s\n' "$destination"
