# Codex Bootstrap Plan

## Accepted baseline

- Use LuaLaTeX for production and retain XeLaTeX/PDFLaTeX compatibility.
- Use BibLaTeX/Biber for production and retain BibTeX only for legacy imports.
- Support macOS and Ubuntu through repository scripts and an Ubuntu CI check.
- Keep content authority separate from LaTeX and repository authority.

## Bootstrap deliverables

1. Establish repository and derivation-packet governance.
2. Provide general and physics-report scaffolds without scientific content.
3. Provide deterministic environment, creation, lint, build, clean, and
   regression commands.
4. Validate a neutral smoke report locally and on Ubuntu CI.
5. Preserve generated PDFs as build artifacts rather than tracked sources.

## Acceptance criteria

- Every required tool and TeX package is detected without installation.
- The smoke report builds with LuaLaTeX/Biber and produces a nonempty PDF.
- XeLaTeX and PDFLaTeX compatibility builds complete from the same source.
- Citation and cross-reference resolution are verified from logs.
- Both templates can be scaffolded, linted, built, and cleaned.
- Invalid engine, unsafe destination, missing source, and existing destination
  cases fail clearly.
- Git shows only intentional source changes after generated artifacts are
  cleaned.

## Explicitly deferred

- Machine-readable derivation-packet validation
- Automatic packet-to-LaTeX conversion
- Institution-specific thesis classes or content
- Additional agents, Notion integration, deployment, and publication

The next bootstrap should implement only the derivation-packet validation gate
described in the Task 1 handoff.
