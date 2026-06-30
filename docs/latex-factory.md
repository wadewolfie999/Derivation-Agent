# LaTeX Factory

## Purpose

This factory turns approved content into reproducible academic reports. It
owns document structure, typography, bibliography processing, compilation,
and validation. It does not own the scientific meaning of the content.

## Production defaults

- Engine: LuaLaTeX
- Bibliography: BibLaTeX with Biber
- Output: `<report>/build/main.pdf`
- Fonts: TeX Live Latin Modern families for cross-platform reproducibility

XeLaTeX and PDFLaTeX are compatibility engines selected with `--engine`.
BibTeX is a documented legacy fallback for imported reports; the supplied
templates use BibLaTeX/Biber.

## Platform setup

Repository scripts never install dependencies. Install the toolchain through
the platform administrator, then run the environment check.

### macOS

MacTeX 2025 supplies the complete tested toolchain. Ensure
`/Library/TeX/texbin` is on `PATH`. Homebrew may supply `shellcheck` separately
when CI-equivalent shell validation is required.

### Ubuntu

The CI baseline uses Ubuntu 24.04 and these distribution packages:

```text
latexmk biber chktex shellcheck poppler-utils lmodern
texlive-luatex texlive-xetex texlive-latex-base
texlive-latex-recommended texlive-latex-extra texlive-bibtex-extra
texlive-fonts-recommended texlive-science
```

## Commands

```bash
# Inspect engines, bibliography tools, QA utilities, and TeX packages.
bash scripts/check-latex-env.sh
bash scripts/check-latex-env.sh --strict

# Create a report. Destination must be relative to the repository root.
bash scripts/new-report.sh basic reports/example-basic
bash scripts/new-report.sh physics reports/example-physics

# Lint and build. LuaLaTeX is the default.
bash scripts/lint-report.sh reports/example-physics
bash scripts/build-report.sh reports/example-physics
bash scripts/build-report.sh --engine xelatex reports/example-physics
bash scripts/build-report.sh --engine pdflatex reports/example-physics

# Remove only generated output for one report.
bash scripts/clean-latex.sh reports/example-physics

# Exercise the complete factory.
bash scripts/validate-factory.sh
```

## Report contract

- A report directory must contain `main.tex`.
- Included source, bibliography, and figure paths are relative to the report
  directory.
- The factory owns the report's `build/` directory and replaces it on each
  build.
- A successful build produces a nonempty `build/main.pdf` and has no unresolved
  citations or references.
- Lint warnings are review inputs, not permission to rewrite scientific
  meaning.

## Failure policy

Commands return nonzero and print diagnostics when required tools, packages,
inputs, references, citations, or outputs are missing. Compatibility-tool and
optional-QA gaps are reported explicitly. No command installs dependencies or
claims validation it did not perform.

## Dependency contract

`config/latex-packages.txt` is the machine-readable list of required TeX files.
The environment checker resolves every entry with `kpsewhich`. Update the
manifest only when a tracked template begins requiring or stops requiring a
package.
