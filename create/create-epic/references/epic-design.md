# Complete Epic Design

Use this reference to write and decompose delivery-ready epics. The epic should remain stable while implementation details evolve in child issues.

Do not leave bracketed template instructions in the final epic.

## Epic Design Principles

An epic is not a large issue body. It is a coordination boundary around one outcome and a set of independently trackable deliverables.

A strong epic answers:

- Why does this initiative exist?
- What changes when it is complete?
- What is explicitly excluded?
- Which deliverables compose the outcome?
- Which existing issues already cover those deliverables?
- What must happen first and what can proceed in parallel?
- How will integrated success be verified?
- What makes the epic complete even if follow-up work remains?

Keep implementation-specific acceptance criteria in child issues unless they describe a cross-cutting contract or integrated outcome.

## Core Template

```markdown
## Summary

[One short paragraph describing the initiative, expected outcome, and why it matters.]

## Context

### Problem or opportunity

[What user, product, engineering, operational, compliance, or business condition motivates this epic?]

### Current state

[How the relevant system or workflow works today, including material limitations.]

### Evidence

[Research, incidents, metrics, support volume, roadmap decisions, technical findings, customer requests, ADRs, or related work. Use N/A with a reason if no evidence exists.]

## Outcome

[The durable result that should be true when the epic is complete.]

## Success Signals

- [Observable product, engineering, reliability, operational, adoption, or business signal.]
- [Use concrete metrics when they already exist; do not invent targets.]

## Goals

- [Outcome or capability this epic must achieve.]

## Non-goals

- [Adjacent capability, migration, optimization, cleanup, or follow-up work explicitly excluded.]

## Scope

### In scope

- [Capability, system, migration, workflow, or cross-cutting requirement included in the epic.]

### Out of scope

- [Work intentionally excluded from this epic.]

## Affected Areas

- [Users, teams, services, packages, products, repositories, platforms, data domains, workflows, or operational surfaces.]

## Constraints and Cross-Cutting Requirements

- [Compatibility, security, privacy, accessibility, localization, performance, reliability, compliance, migration, observability, release, or architectural constraints.]
- [Use N/A with a reason for categories that are materially irrelevant.]

## Deliverables

### Workstream 1: [Outcome-oriented name]

[What this workstream delivers and how it contributes to the epic outcome.]

- Child item: [native issue/epic reference or planned child]
- Completion signal: [observable result]

### Workstream 2: [Outcome-oriented name]

[Repeat only for meaningful independent deliverables.]

## Sequencing and Dependencies

### Blocked by

- [Native blocker plus concise rationale, or N/A.]

### Blocking

- [Downstream work that depends on this epic, or N/A.]

### Internal sequence

1. [Foundation or prerequisite deliverable.]
2. [Dependent or integration deliverable.]
3. [Rollout, migration, or finalization deliverable.]

### Parallelizable work

- [Deliverables that can proceed concurrently, if useful.]

## Integration and Compatibility

- [Cross-service/API/data contracts, migration boundaries, backwards compatibility, feature flags, deprecations, or N/A with a reason.]

## Rollout and Migration

- [Deployment order, migration phases, backfill, feature flag, staged rollout, rollback, communication, or N/A with a reason.]

## Observability and Operations

- [Metrics, logs, traces, dashboards, alerts, SLOs, audit events, runbooks, support readiness, or N/A with a reason.]

## Epic Acceptance Criteria

- [ ] The integrated outcome described in `Outcome` is demonstrably achieved.
- [ ] All required child deliverables are complete or explicitly removed from scope with rationale.
- [ ] Cross-cutting requirements and compatibility constraints are verified.
- [ ] Dependencies required for completion are resolved.
- [ ] Rollout/migration and operational readiness are complete when applicable.
- [ ] Success signals can be measured or observed where applicable.

## Risks and Mitigations

- **Risk:** [Cross-cutting failure mode, dependency, uncertainty, or coordination risk.]
  **Mitigation:** [How it is prevented, reduced, detected, contained, or reversed.]

## Assumptions and Open Decisions

- **Assumption:** [Planning assumption that materially affects scope or sequencing.]
- **Open decision:** [Decision that cannot be discovered or safely inferred, owner if known.]

## Definition of Done

- [ ] Epic acceptance criteria are satisfied.
- [ ] Required child issues/epics are closed or intentionally removed from scope.
- [ ] Native parent-child relationships reflect the final decomposition.
- [ ] Native blocker/blocking relationships reflect the final dependency graph.
- [ ] Required project, milestone, date, status, health, and estimation metadata is correct.
- [ ] Integration, migration, rollout, compatibility, and operational requirements are complete when applicable.
- [ ] Documentation, runbooks, release notes, or stakeholder communication is complete when applicable.
- [ ] No known blocking work remains untracked.

## References

- [Product specs, ADRs, research, incidents, dashboards, designs, issues, PRs/MRs, or external references.]
```

## Decomposition Rules

Create a child item when the work has its own implementation boundary and verification result.

Good child boundaries include:

- one user-visible capability,
- one service or platform contract that can ship independently,
- one migration phase with a clear completion condition,
- one operational readiness deliverable,
- one integration boundary,
- one discovery item that gates later implementation.

Avoid child boundaries that are only:

- a single source file,
- frontend/backend split with no independent outcome,
- one developer's portion of the work,
- generic phases such as "coding" and "testing",
- duplicates of already-open issues.

If a candidate child itself coordinates multiple substantial deliverables, consider a nested epic when the platform and repository conventions support it.

## Child Item Table for Drafts

When useful, summarize proposed decomposition before remote creation:

```markdown
| Deliverable | Action | Existing/New | Depends on | Completion signal |
| --- | --- | --- | --- | --- |
| [Outcome] | Reuse/Create/Nested epic | [#123 or planned] | [#456 or N/A] | [Observable result] |
```

This table is a planning aid. The native remote hierarchy remains the source of truth after creation.

## Epic Acceptance Criteria Quality Rules

Epic-level criteria must:

- verify the integrated result across children,
- be objectively observable,
- describe cross-cutting contracts or release readiness when relevant,
- avoid restating every child issue criterion,
- avoid vague statements such as "all work is done" unless completion is defined by an explicit child set,
- distinguish required deliverables from optional follow-up work.

## Scope Change Rules

When the epic changes materially after creation:

1. update the parent outcome/scope first,
2. add, remove, or reparent children natively,
3. update dependencies and sequencing,
4. revisit planning metadata and dates,
5. record the rationale in the epic when the change affects stakeholder expectations,
6. verify the remote hierarchy after mutation.

Do not keep obsolete child issues attached merely to preserve historical progress counts.
