# Derivation Packet Schema, Version 1

## Purpose

A derivation packet is the authoritative content handoff from a Derivation
Agent or human reviewer to the LaTeX factory. It provides meaning; Codex may
change representation but not meaning.

## Required metadata

| Field | Contract |
|---|---|
| `schema-version` | Must equal `1`. |
| `packet-id` | Stable, unique identifier supplied by the content authority. |
| `title` | Approved report title. |
| `status` | One of `draft`, `requires-physics-review`, or `ready-for-typesetting`. |
| `content-authority` | Person or agent responsible for scientific correctness. |
| `revision` | Monotonic packet revision identifier. |

## Required sections

1. **Scope** — state what the packet covers and explicitly excludes.
2. **Assumptions** — list each approved assumption with a stable identifier.
3. **Notation and units** — define every symbol, convention, domain, and unit
   needed to typeset the content without inference.
4. **Approved content blocks** — provide ordered prose, equation, table, or
   figure blocks. Give every referenced block a stable identifier.
5. **Citations** — provide complete bibliographic data and map citation keys to
   content blocks. Codex must not invent missing sources.
6. **Assets** — list required figures or data files with paths, captions,
   provenance, and approved transformations.
7. **Unresolved issues** — identify missing or disputed content and name the
   authority that must resolve it. Use `none` when empty.

## Readiness rules

- Only `ready-for-typesetting` authorizes production typesetting.
- `draft` permits structural experimentation but not a production claim.
- `requires-physics-review` blocks typesetting of affected content.
- Missing definitions, inconsistent units, ambiguous equations, or incomplete
  citations must be returned to the content authority.

## Allowed transformations

Codex may escape LaTeX characters, apply approved macros, split files, add
labels matching stable identifiers, place floats, and adjust typography. Codex
must not change algebra, signs, factors, indices, limits, units, assumptions,
claims, citation meaning, or logical order without explicit content-authority
approval.
