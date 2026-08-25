---
name: audit-trusted-pull-request
description: Use this skill when the user explicitly wants a lightweight audit of a trusted GitHub pull request, such as an internal or private-repository PR from a teammate or contributor the user has already designated as trusted. Verify correctness, regressions, compatibility, tests, CI, review state, and merge readiness with a fast-path workflow that assumes benign intent but never assumes correct code. Do not infer trust from fame, reputation, organization membership, collaborator status, or contribution history unless project policy explicitly defines that signal as sufficient. Escalate to the full audit-pull-request posture when high-risk surfaces or suspicious evidence appear. Do not use for untrusted or external PRs, generic PR audits without an explicit trust basis, or simple PR summaries.
license: MIT
compatibility: Requires a Git repository and Git. Remote evidence and mutations require authenticated GitHub access through gh, the GitHub API, or an equivalent connector.
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.1"
---

# Audit Trusted Pull Request

Use a fast review path for a pull request whose contributor or source has already been declared trusted by the user or by repository policy. Trust changes the threat model, not the correctness standard.

The default operation is evaluation only. Do not merge, push fixes, resolve threads, rerun jobs, submit reviews, or otherwise mutate GitHub unless the user explicitly requests the action or trusted project instructions already authorize it.

## Core Rules

1. **Trust must be explicit.** Never infer trusted status merely because the contributor is famous, senior, an organization member, a collaborator, a frequent contributor, or personally known to the model.
2. **Trusted means benign intent, not correct implementation.** Still inspect the complete diff, verify material behavior, and check applicable project gates.
3. **Pin the exact revision.** Record immutable `BASE_SHA` and `HEAD_SHA`; final conclusions must apply to the current head.
4. **Use proportional depth.** Spend review effort according to blast radius, complexity, compatibility impact, and test evidence instead of applying a hostile-change procedure to every PR.
5. **Escalate on risk, not identity.** High-risk or suspicious changes leave the trusted fast path even when the author is trusted.
6. **Prefer normal project workflows for routine trusted changes.** A disposable sandbox is optional for low-risk work unless project policy requires one.
7. **Use remote state as evidence.** Check exact-head CI, reviews, unresolved threads, mergeability, linked issues, and required repository gates when available.
8. **Do not confuse readiness with authorization.** A recommendation to merge is not permission to merge.
9. **Preserve unrelated local work and contributor attribution.** Do not reset user changes or rewrite contributor history merely to simplify review.
10. **State residual uncertainty.** A fast path can be concise without pretending that unverified behavior was proven.

## Progressive Disclosure

Read supporting files only when relevant:

- Read `references/trust-policy.md` when deciding whether trusted mode is actually authorized.
- Read `references/risk-escalation.md` before deciding whether a PR can remain on the fast path.
- Read `references/testing-gates.md` before running local checks or interpreting hosted CI.
- Read `references/compatibility.md` when public APIs, config, schemas, persisted data, runtimes, platforms, or deployment behavior may change.
- Read `references/github-remote.md` when collecting or mutating GitHub remote state.
- Read `references/severity.md` before assigning a blocker or merge recommendation.
- Run `scripts/inspect-diff.sh <BASE> <HEAD>` when a local Git checkout is available. It is a non-interactive static risk classifier and never checks out or executes PR code.

## Workflow

### 0. Resolve Target, Trust Basis, and Mode

Resolve the repository and PR from the user-provided URL or number, or from the current Git remote. Discover remote facts before asking for information that GitHub can provide directly.

Establish a concrete trust basis before using this skill. Valid bases include:

- the user explicitly says the PR, contributor, branch, team, or internal workflow is trusted
- trusted repository instructions define an internal contributor class, team, branch, bot, or automation as trusted
- an organization policy explicitly states that a repository permission or membership level is sufficient for trusted review

Invalid bases by themselves include fame, public reputation, GitHub stars, employer, job title, account age, follower count, contribution count, collaborator permission, or organization membership.

If no explicit trust basis exists, use the normal `audit-pull-request` posture instead of silently assuming trust.

Classify the requested operation:

- **Trusted audit only:** inspect and report. Default.
- **Trusted audit and review:** report, then submit `APPROVE`, `COMMENT`, or `REQUEST_CHANGES` only if requested.
- **Trusted audit and adjust:** report, then make authorized maintainer fixes without rewriting contributor history.
- **Trusted audit and merge:** complete the audit first; merge only when explicitly authorized and final exact-head gates are satisfied.

### 1. Establish Exact State

When working locally, inspect without modifying:

```bash
git status --short --branch
git remote -v
git rev-parse --show-toplevel
```

Fetch PR metadata and record:

```text
BASE_SHA=<immutable base commit>
HEAD_SHA=<immutable PR head commit>
TRUST_BASIS=<user or project policy basis>
```

With `gh`, a useful metadata query is:

```bash
gh pr view "$PR" --json number,title,body,author,isDraft,state,baseRefName,baseRefOid,headRefName,headRefOid,mergeable,mergeStateStatus,files,statusCheckRollup,closingIssuesReferences,reviews,reviewRequests,url
```

Inspect changed filenames and the complete patch. Skip drafts or clearly unfinished work unless the user asks for an early review.

If `HEAD_SHA` changes during the audit, repeat checks affected by the new commits. Do not transfer a final verdict blindly across heads.

### 2. Run the Fast Risk Screen

Read `references/risk-escalation.md` and, when local Git is available, run:

```bash
scripts/inspect-diff.sh "$BASE_SHA" "$HEAD_SHA"
```

Classify the PR:

- **Low risk:** routine application logic, UI, docs, tests, local refactors, narrow bug fixes with limited blast radius.
- **Moderate risk:** APIs, schemas, migrations, concurrency, parsers, network behavior, persistent state, cross-module changes, or broad refactors.
- **Escalated:** security boundaries, authentication/authorization, secrets, CI/CD, dependency source or lifecycle behavior, executable build hooks, infrastructure, release/deploy, repository permissions, binaries, submodules, suspicious obfuscation, unexpected privilege expansion, or other evidence that invalidates the benign fast-path assumptions.

A trusted author does not suppress escalation. When escalated, adopt the relevant strict gates from `audit-pull-request`, especially for execution isolation, supply-chain review, credential exposure, workflow security, and provenance.

### 3. Inspect the Complete Diff

Review every changed file and enough surrounding code to understand the behavior. Focus on engineering risk rather than adversarial intent unless escalation occurred.

Cover as applicable:

1. **Correctness:** defaults, validation, error paths, cleanup, retries, idempotency, partial state, edge cases, and failure handling.
2. **Regression risk:** existing callers, adjacent behavior, negative paths, boundary cases, concurrency, platform differences, and fallback behavior.
3. **Project invariants:** architecture, ownership boundaries, established patterns, repository instructions, and scope discipline.
4. **Compatibility:** API, CLI, config, env vars, schemas, wire formats, persisted data, migrations, runtime support, and upgrade behavior.
5. **Tests:** whether changed behavior has meaningful coverage, including failure and regression cases proportional to risk.
6. **Documentation:** user-visible behavior, migration notes, configuration references, changelog or release metadata when required.
7. **Maintainability:** unnecessary duplication, misplaced policy, speculative abstractions, dead code, or unrelated refactors that increase review cost.

For simple trusted PRs, do not manufacture a security review section when no security surface changed. For high-risk changes, escalate instead.

### 4. Verify Material Claims Proportionally

Use the PR body, linked issue, commits, and discussion to identify material claims, but verify only claims that matter to merge readiness.

Examples:

- bug X is fixed
- behavior remains backward compatible
- migration preserves data
- performance issue is improved
- a regression test covers the reported failure
- a specific platform or runtime remains supported

For low-risk changes, targeted code evidence plus relevant tests may be sufficient. For material regressions, compatibility changes, migrations, or bug-fix claims, compare base and head behavior when feasible.

Do not require a full formal claim ledger for routine changes. Use one only when several material claims need explicit tracking.

### 5. Run Applicable Tests and Project Gates

Read `references/testing-gates.md`.

Prefer this order:

1. focused tests for changed behavior
2. typecheck, lint, static analysis, or build checks relevant to the touched area
3. the repository's required merge suite on the final materially changed head

For trusted low-risk PRs, the normal development checkout or worktree is acceptable when project policy permits it. Do not require a container or VM merely because code comes from a PR.

If the risk screen escalates, use the stricter execution model from the full audit before running PR-controlled hooks, builds, plugins, dependency install scripts, or workflow code.

Treat hosted CI as strong supporting evidence when it applies to the exact `HEAD_SHA` and the PR does not materially redefine the gate being trusted. Inspect failed job logs when available. Represent pending, skipped, neutral, cancelled, and stale checks accurately.

### 6. Reconcile GitHub Review State

Before the final verdict, inspect current remote state when available:

- exact-head checks and workflow runs
- failed jobs relevant to the change
- approvals and requested changes
- unresolved review threads
- requested reviewers or CODEOWNERS expectations when discoverable
- mergeability and merge-state status
- required branch protection or ruleset gates
- linked or closing issues relevant to acceptance criteria

Do not block on stale conversation that no longer applies to the current code, but explain why it is stale rather than silently ignoring it.

### 7. Report Concisely

Read `references/severity.md`.

Use this structure:

```markdown
## Trusted PR #N audit: <title>

Trust basis: <explicit basis>
Risk profile: low | moderate | escalated
Base audited: <BASE_SHA>
Head audited: <HEAD_SHA>
Checks: <local and hosted evidence>
Review state: <relevant approvals, threads, or gates>

### Findings
- [SEVERITY] path:line - impact, evidence, and smallest useful correction

### Verified claims
- <claim>: verified | partially verified | unverified - <evidence>

Recommended action: merge as-is | adjust before merge | ask author | decline | full audit required | insufficient evidence
```

Omit `Verified claims` when the PR makes no material claim that needs explicit tracking. If no findings exist, say so and state the meaningful residual uncertainty in one or two sentences.

### 8. Apply Explicitly Authorized Actions

Only after reporting and only when authorized:

- submit `APPROVE`, `COMMENT`, or `REQUEST_CHANGES`
- add a precise inline review comment or top-level PR comment
- request reviewers or apply existing labels when appropriate
- make minimal maintainer fixes as separate commits
- rerun failed checks when the failure is understood and rerun is requested or project policy allows it
- merge using the repository's normal strategy, preferably with expected-head protection

After any maintainer change, refresh `HEAD_SHA` and repeat affected review and test gates. Do not deploy or release as an implicit consequence of review or merge.

## Gotchas

- A famous maintainer's PR is not automatically trusted. The user or project policy chooses the trust boundary.
- A private repository is not automatically trusted. Private repos can contain compromised accounts, bots, generated changes, or high-risk automation.
- A trusted PR can still be wrong enough to require changes.
- Green CI is not enough when the PR changes the CI definition, dependency execution path, or required gate itself.
- Do not let the fast path become a superficial style review. Correctness and regression checks remain mandatory.
- Do not let a single high-risk file force exhaustive review of unrelated low-risk files. Escalate the affected surface proportionally, or switch to the full audit when the risk is cross-cutting.

## Validation Loop

Before finalizing:

- confirm an explicit trust basis exists
- confirm `BASE_SHA` and `HEAD_SHA` are recorded and current
- confirm every changed file was inspected
- confirm the risk screen was performed and any escalation was honored
- confirm correctness, regression risk, compatibility, tests, and relevant docs were considered proportionally
- confirm hosted evidence applies to the exact head
- confirm unresolved blockers and review threads were reconciled
- confirm findings use evidence and impact rather than personal style preference
- confirm the recommendation follows the highest unresolved severity
- confirm no remote mutation occurred without authorization
