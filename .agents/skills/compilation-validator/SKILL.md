---
name: compilation-validator
description: Validate LaTeX reports with the repository toolchain and provide command-backed evidence for engines, packages, bibliography processing, cross-references, logs, and PDF output. Use when asked to compile, validate, diagnose, smoke-test, or confirm a report build on macOS or Ubuntu.
---

# Compilation Validator

## Trigger phrases

- "compile this report"
- "validate the LaTeX"
- "run the smoke test"
- "diagnose the build"
- "check citations and references"

## When to use

Use for environment inspection, report compilation, compatibility checks, log
analysis, and PDF artifact verification.

## When not to use

Do not use compilation success as evidence of scientific correctness. Do not
rewrite equations or claims to remove diagnostics.

## Inputs

- A report directory containing `main.tex`
- An optional engine: `lualatex`, `xelatex`, or `pdflatex`
- The repository dependency manifest and `.latexmkrc`

## Outputs

- Exact commands and exit results
- A verified PDF path when successful
- Missing tools/packages, fatal errors, unresolved references/citations, and
  nonfatal warnings when unsuccessful or incomplete

## Workflow

1. Run `scripts/check-latex-env.sh`.
2. Run `scripts/lint-report.sh` when lint validation is in scope.
3. Build through `scripts/build-report.sh` with the selected engine.
4. Inspect the generated log and PDF evidence.
5. Report facts separately from hypotheses and recommendations.

## Safety constraints

- Install no dependency.
- Build only inside the report's generated `build/` directory.
- Do not suppress failures or fabricate validation evidence.
- Do not change scientific meaning during diagnosis.

## Validation requirements

- Require zero build status, a nonempty PDF, and no unresolved citation or
  cross-reference diagnostics.
- Identify the engine and bibliography backend actually used.
- Report unavailable optional checks instead of claiming they ran.
