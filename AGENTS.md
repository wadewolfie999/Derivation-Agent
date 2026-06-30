# Derivation Agent Repository Instructions

## Mission

Maintain a controlled factory for academic derivation handoffs, LaTeX report
scaffolding, compilation, and validation. The repository infrastructure must
preserve the scientific meaning supplied by the Derivation Agent or human
author.

## Codex responsibilities

- Maintain repository governance, templates, scripts, documentation, and CI.
- Convert an approved derivation packet into structurally valid LaTeX.
- Preserve supplied equations, assumptions, notation, units, citations, and
  scientific claims.
- Validate compilation, bibliography generation, cross-references, and output
  artifacts with repository scripts.
- Report missing information and ambiguous content instead of inventing it.

## Forbidden responsibilities

- Do not derive, correct, simplify, reinterpret, or complete physics or
  mathematics unless the user explicitly supplies and approves that content.
- Do not invent thesis prose, results, citations, data, assumptions, units, or
  notation.
- Do not conceal compiler, bibliography, reference, or lint failures.
- Do not add unrelated integrations, automation, agents, or workflow layers.

## Derivation-packet boundary

- Treat `docs/derivation-packet-schema.md` as the handoff contract.
- Typeset content as production-ready only when its packet status is
  `ready-for-typesetting`.
- Preserve stable content identifiers so equations and references remain
  traceable to the packet.
- Treat `requires-physics-review` items as blockers. Ask the content authority
  to resolve them; never resolve them by inference.
- Formatting changes may alter presentation but must not alter scientific
  meaning.

## Git safety

- Inspect `git status --short --branch` before editing and before handoff.
- Preserve pre-existing user changes and keep patches limited to the requested
  scope.
- Stage only explicit paths when staging is requested.
- Do not commit, push, rewrite history, force-push, reset destructively, or
  delete branches unless the user explicitly authorizes that action.
- Never report a clean worktree or successful publication without command
  evidence.

## LaTeX validation

- Use LuaLaTeX and BibLaTeX/Biber for production reports by default.
- Treat PDFLaTeX and XeLaTeX as compatibility options and BibTeX as a legacy
  fallback.
- Run `scripts/check-latex-env.sh` before claiming the toolchain is ready.
- Build through `scripts/build-report.sh`; do not claim success unless the
  command exits successfully and creates a nonempty PDF.
- Fail production validation on missing dependencies, unresolved citations,
  unresolved references, or fatal LaTeX/Biber diagnostics.
- Report style and layout warnings separately. Do not silence them by changing
  scientific content.
- Do not install dependencies from repository scripts.
