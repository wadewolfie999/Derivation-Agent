---
name: latex-crafter
description: Craft or update controlled academic LaTeX reports from approved derivation packets and repository templates. Use when asked to create a report, typeset approved mathematical or physics content, apply the basic or physics template, or prepare a report for repository validation without changing scientific meaning.
---

# LaTeX Crafter

## Trigger phrases

- "craft a LaTeX report"
- "typeset this derivation packet"
- "create a basic report"
- "create a physics report"
- "format this approved content"

## When to use

Use for report scaffolding, LaTeX structure, typography, labels, bibliography
wiring, and presentation of content already approved by its authority.

## When not to use

Do not use to derive, correct, complete, or interpret physics or mathematics.
Do not treat draft or review-blocked packet content as production-ready.

## Inputs

- A derivation packet conforming to `docs/derivation-packet-schema.md`
- The requested `basic` or `physics` repository template
- Approved figures, citations, and presentation constraints

## Outputs

- A report directory containing maintainable LaTeX and bibliography sources
- Stable labels traceable to packet identifiers
- Build and lint evidence, or an exact blocker report

## Workflow

1. Inspect repository status and the packet readiness state.
2. Reject or isolate content requiring scientific review.
3. Scaffold with `scripts/new-report.sh` when creating a report.
4. Preserve equations, assumptions, notation, units, and claim meaning.
5. Run the repository lint and build scripts.
6. Report output paths, warnings, and unresolved blockers.

## Safety constraints

- Never invent content, citations, units, or assumptions.
- Never change scientific meaning to satisfy LaTeX or lint checks.
- Keep edits inside the requested report and shared infrastructure explicitly
  placed in scope.
- Follow `AGENTS.md` Git and file-safety rules.

## Validation requirements

- Require a successful environment check before claiming readiness.
- Require lint output to be reviewed.
- Require a successful build, nonempty PDF, and resolved citations/references
  before claiming compilation success.
