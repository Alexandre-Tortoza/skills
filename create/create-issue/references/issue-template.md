# Complete Issue Template

Use this template to produce implementation-ready issues. Keep the core sections even when short. Include conditional sections when they affect delivery, safety, compatibility, rollout, or verification.

Do not leave bracketed template instructions in the final issue.

## Core Template

```markdown
## Summary

[One short paragraph describing the problem or outcome and why the issue exists.]

## Context

### Problem

[What is wrong, missing, risky, inefficient, or needed?]

### Current behavior

[What happens today? Include concrete examples where useful.]

### Desired behavior

[What should happen instead?]

### Evidence

[Logs, screenshots, traces, metrics, support tickets, code references, incident links, research, or related issues. Use N/A with a reason if no evidence exists.]

## Goal

[The concrete outcome this issue must achieve.]

## Non-goals

- [Explicitly excluded behavior, refactors, migrations, adjacent features, or follow-up work.]

## Impact

[User, business, operational, developer-experience, reliability, cost, security, compliance, or accessibility impact. State N/A when genuinely irrelevant.]

## Scope

### In scope

- [Deliverable or behavior included in this issue.]

### Out of scope

- [Adjacent work intentionally excluded.]

## Requirements

### Functional

- [Required behavior, rule, API contract, workflow, or state transition.]

### Non-functional

- [Performance, reliability, security, privacy, accessibility, localization, compatibility, observability, or maintainability requirement.]
- [Use N/A with a reason for categories that are materially irrelevant.]

## Technical Context

### Affected surfaces

- [Packages, services, components, routes, commands, schemas, jobs, infrastructure, or user flows likely to be affected.]

### Interfaces and data

- [API contracts, events, database changes, migrations, cache behavior, file formats, or external integrations.]
- [State whether backward compatibility is required.]

### Constraints

- [Architectural constraints, platform limitations, rollout requirements, deadlines, dependencies, or compatibility constraints.]

## Implementation Notes

[Known implementation direction, existing abstractions to reuse, sequencing requirements, or important trade-offs. Keep proposals separate from hard requirements.]

## Acceptance Criteria

- [ ] Given [precondition], when [action/event], then [observable result].
- [ ] [A criterion covering the primary success path.]
- [ ] [A criterion covering the important failure or edge case.]
- [ ] [A criterion covering authorization/security when applicable.]
- [ ] [A criterion covering compatibility/performance/accessibility when applicable.]

## Test Plan

### Automated

- [Unit/component/integration/e2e/contract/regression tests to add or update.]

### Manual

- [Manual verification that cannot be represented reliably in automated coverage.]

### Regression

- [Existing behavior that must remain unchanged.]

## Rollout and Compatibility

- [Feature flag, staged rollout, migration, deployment order, fallback, rollback, deprecation, or N/A with a reason.]

## Observability

- [Logs, metrics, traces, dashboards, alerts, audit events, or N/A with a reason.]

## Dependencies and Relationships

### Parent

- [Native parent issue or N/A.]

### Blocked by

- [Native blocking issue(s) plus one-line rationale when useful, or N/A.]

### Blocking

- [Native downstream issue(s), or N/A.]

### Related

- [Related issues, PRs/MRs, discussions, incidents, ADRs, or N/A.]

## Risks and Mitigations

- **Risk:** [Failure mode or uncertainty.]
  **Mitigation:** [How it is prevented, detected, contained, or reversed.]

## Definition of Done

- [ ] Acceptance criteria are satisfied.
- [ ] Required automated tests are passing.
- [ ] Manual validation is complete where required.
- [ ] Documentation, examples, changelog, or runbooks are updated when applicable.
- [ ] Migration and rollback paths are validated when applicable.
- [ ] Observability is in place when applicable.
- [ ] Security, privacy, accessibility, and compatibility requirements are verified when applicable.
- [ ] Native issue metadata and relationships accurately represent the final plan.
- [ ] No known blocking work remains untracked.

## References

- [Specifications, code, docs, designs, logs, related work, or external references.]
```

## Bug Addendum

For a bug or regression, add these sections after `Context`:

```markdown
## Reproduction

### Preconditions

- [Required account state, feature flag, data, browser, version, environment, or configuration.]

### Steps

1. [First deterministic step.]
2. [Second deterministic step.]
3. [Step that exposes the defect.]

### Actual behavior

[Observed result.]

### Expected behavior

[Correct result.]

### Environment

- Version/commit:
- Environment:
- OS/browser/runtime:
- Feature flags/configuration:
- Relevant data shape:

### Regression information

- Last known good:
- First known bad:
- Reproducibility:
- Frequency:

### Evidence

- Logs:
- Stack trace:
- Screenshot/video:
- Trace/request ID:
- Metrics:
```

If a value is unknown and cannot be discovered, write `Unknown` rather than guessing.

## Feature Addendum

For a new capability, add or expand:

```markdown
## User Flow

1. [User/system enters the flow.]
2. [Primary interaction or event.]
3. [Expected completion state.]

## UX and API Contract

- Entry point:
- Inputs:
- Outputs:
- Validation:
- Error states:
- Permissions:
- Empty/loading states:
- Backward compatibility:

## Edge Cases

- [Boundary condition.]
- [Failure condition.]
- [Concurrency/idempotency condition when relevant.]
```

## Infrastructure or Operations Addendum

When the issue changes deployment, infrastructure, queues, storage, CI/CD, networking, observability, or operational behavior, add:

```markdown
## Operational Plan

### Capacity and cost

[Expected resource change, limits, quotas, or cost impact.]

### Failure modes

- [Failure mode and expected system behavior.]

### Deployment order

1. [Safe sequencing step.]

### Rollback

[Concrete rollback trigger and procedure.]

### Monitoring

- [Metric/log/trace/dashboard.]
- [Alert threshold or symptom when known.]
```

## Security-Sensitive Addendum

When authentication, authorization, secrets, personal data, trust boundaries, permissions, billing, or externally supplied input is involved, add:

```markdown
## Security and Privacy

### Threats and abuse cases

- [Relevant threat or abuse path.]

### Authorization

- [Who can perform the action and how enforcement is verified.]

### Data handling

- [Sensitive data collected, stored, logged, transmitted, retained, or deleted.]

### Validation

- [Input validation, output encoding, rate limiting, audit logging, or other controls.]
```

Do not include exploit instructions that are unnecessary to complete the engineering task.

## Acceptance Criteria Quality Rules

Acceptance criteria must:

- describe observable outcomes, not vague intentions such as "works correctly"
- be independently verifiable
- cover the primary success path
- cover material failure and boundary behavior
- include permissions, security, compatibility, accessibility, or performance only when those dimensions matter
- avoid prescribing an implementation unless the implementation itself is a requirement
- use concrete values when the product contract defines them

Prefer Given/When/Then for behavior-heavy work. Use direct checkboxes for structural or operational requirements.
