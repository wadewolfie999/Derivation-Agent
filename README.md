# Derivation Agent

A controlled academic derivation handoff and LaTeX/report-production factory.
Scientific and mathematical correctness belongs to the content authority;
this repository owns safe scaffolding, typesetting, compilation, and
validation.

## Quick start

```bash
bash scripts/check-latex-env.sh
bash scripts/new-report.sh physics reports/example-report
bash scripts/lint-report.sh reports/example-report
bash scripts/build-report.sh reports/example-report
```

Production builds default to LuaLaTeX with BibLaTeX/Biber. Select a documented
compatibility engine with `--engine xelatex` or `--engine pdflatex`.

See [docs/latex-factory.md](docs/latex-factory.md) for setup, commands, and the
validation contract. Content handoffs must follow
[docs/derivation-packet-schema.md](docs/derivation-packet-schema.md).
