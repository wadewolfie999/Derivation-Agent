---
name: repo-governance
description: Govern changes in the Derivation Agent repository with preservation-first Git safety, explicit scope control, derivation-authority boundaries, and command-backed validation. Use for repository audits, bootstrap work, infrastructure changes, handoffs, status checks, or any task where safe file and Git operations matter.
---

# Repository Governance

## Trigger phrases

- "audit the repository"
- "bootstrap the repo"
- "check repository state"
- "prepare a handoff"
- "keep this change scoped"

## When to use

Use before and after repository changes to establish state, protect user work,
enforce allowed scope, and record validation evidence.

## When not to use

Do not use governance authority to approve scientific content, broaden scope,
or perform Git publication actions the user did not authorize.

## Inputs

- User-requested file and behavior scope
- Current Git branch, status, diff, and repository instructions
- Required validation and publication constraints

## Outputs

- A minimal intentional patch or a read-only audit
- Exact validation evidence and remaining blockers
- A concise handoff listing changed files and prohibited actions not taken

## Workflow

1. Inspect the branch, status, instructions, and relevant files.
2. Separate observed facts, inferred behavior, and hypotheses.
3. Preserve pre-existing changes and edit only authorized paths.
4. Validate behavior in proportion to risk.
5. Inspect the final diff and status before handoff.

## Safety constraints

- Do not discard user changes.
- Do not commit, push, force-push, reset, rewrite history, or delete branches
  without explicit authorization.
- Use explicit paths for staging when staging is authorized.
- Do not claim scientific approval or change physics meaning.

## Validation requirements

- Run `git status --short --branch` before and after meaningful work.
- Run applicable tests plus `git diff --check`.
- Confirm every changed path belongs to the approved scope.
- Report skipped or unavailable validation honestly.
