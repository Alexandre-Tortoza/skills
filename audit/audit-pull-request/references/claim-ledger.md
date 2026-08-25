# Claim Ledger

Create a claim ledger for every material statement that could change the merge decision.

## Procedure

1. Extract claims from the PR body, linked issues, commits, reviews, and discussion.
2. Rewrite each claim into a falsifiable statement.
3. Identify independent evidence required to confirm or reject it.
4. Collect evidence from the pinned base/head code, trusted tests, remote checks, primary documentation, and runtime verification when safe.
5. Assign a verdict without upgrading missing evidence to success.

## Standard Ledger

| Claim | Independent evidence required | Typical verdicts |
|---|---|---|
| Fixes issue/regression X | Reproduce or identify the exact base failure/code path; preferably show a regression test fails on base and passes on head | confirmed / partial / unsupported |
| Preserves backward compatibility | Compare public APIs, config/CLI/env, schemas, persisted data, migrations, defaults, behavior, and supported runtimes | confirmed / breaking / uncertain |
| Follows specification Y | Check the primary specification or official docs, including relevant version/date | confirmed / mismatch / uncertain |
| Tests pass | Run trusted project gates on the exact head and inspect hosted checks for the exact head | confirmed / failed / not run / stale |
| Coverage is sufficient | Map tests to changed behavior, negative/failure paths, boundaries, and regression surface | sufficient / gap / uncertain |
| No security impact | Trace changed trust boundaries, capabilities, data flows, dependencies, build/CI, and permissions | confirmed within scope / finding / not established |
| Migration is safe | Inspect forward/backward migration behavior, partial failure, rollback, old/new reader compatibility, and production assumptions | confirmed / unsafe / irreversible / uncertain |
| Improves performance | Reproduce representative benchmark with controlled inputs and inspect algorithmic/resource tradeoffs | confirmed / no material change / regression / unsupported |
| Does not change behavior | Compare reachable code paths, defaults, serialization, side effects, error behavior, and runtime configuration | confirmed / behavior changed / uncertain |
| Documentation is complete | Map changed user-facing surfaces to repository-required docs, examples, changelog, migration notes, and release metadata | complete / incomplete / not required |

## Evidence Quality

Prefer evidence in roughly this order:

1. direct inspection of pinned base/head code and repository state
2. deterministic reproduction or trusted regression test
3. exact-head local/hosted checks whose definitions are themselves trusted
4. primary specifications, official docs, upstream source, or authoritative compatibility notes
5. repository historical evidence that is still applicable
6. contributor narrative and discussion, which can identify intent but never prove it

## Regression Verification

When feasible for a claimed bug fix:

1. identify the failing base behavior
2. run or reason about the regression test against `BASE_SHA`
3. confirm the same test or scenario succeeds on `HEAD_SHA`
4. verify the test is not vacuous and actually reaches the changed behavior
5. inspect adjacent negative and failure cases proportional to risk

If running against base is unsafe or impractical, explain the alternative evidence and downgrade confidence accordingly.

## Compatibility Claims

For any compatibility claim, read `compatibility.md`. "Additive" does not automatically mean compatible. New required fields, changed defaults, altered overload resolution, stricter validation, different serialization, or irreversible migration can break existing callers without deleting an API.

## Security Claims

"No security impact" requires evidence. Look for changed authorization decisions, tenant scoping, parsing, templating, SQL/query construction, shell/process invocation, network egress, secret access, dependency execution, workflow permissions, and release/deploy scope.

## Verdict Discipline

Use `uncertain` or `not established` when evidence is missing. Do not use phrases such as "probably fine" as a substitute for a ledger verdict.

A final merge recommendation must be consistent with unresolved ledger items. A material claim that is required for safety or correctness and remains unsupported can itself be `[BLOCKING]` or `[UNCERTAIN]` depending on risk and repository policy.
