# Testing Gates

Trusted review should optimize verification cost without weakening merge confidence.

## Preferred order

1. Run the smallest focused test that exercises the changed behavior.
2. Run relevant static gates such as typecheck, lint, schema validation, or compile checks.
3. Run the repository-required merge suite on the final materially changed head.

Use project commands from established repository instructions or CI configuration. For a trusted routine PR, commands documented by the PR can be used when they are consistent with the repository's normal tooling.

## Regression verification

Base-versus-head verification is especially valuable when a PR claims to fix a reproducible bug, parser failure, migration problem, compatibility defect, or other regression.

Do not require base-versus-head execution for every routine change. Use it when it materially increases confidence.

## Hosted CI

Hosted CI is strong evidence when:

- it ran for the exact `HEAD_SHA`
- the relevant jobs actually executed
- the workflow or gate being trusted was not materially weakened or redirected by the PR
- environment differences do not invalidate the result

Inspect failed job logs when available. Distinguish pending, skipped, cancelled, neutral, stale, and passing states.

## Local execution

For low-risk trusted changes, the normal development environment or a clean worktree is acceptable if project policy permits it.

Isolation becomes important when the PR changes execution infrastructure, dependencies with lifecycle behavior, build plugins, scripts with host access, CI/CD, release tooling, or another escalated surface.

## Test adequacy

Check tests for behavior, not just line coverage. Depending on risk, consider:

- negative inputs
- failure paths
- defaults and omitted values
- boundaries
- concurrency or retries
- rollback or partial state
- old callers or old data
- platform/runtime differences

A green suite does not compensate for an obviously missing regression case when the bug is easy to encode as a test.
