# Severity and Recommendation

Severity is based on impact and confidence, not author identity.

## Levels

### [BLOCKING]

Use when the PR should not merge in its current form because of a concrete correctness, compatibility, security, data-loss, migration, or required-gate problem.

Examples:

- reproducible regression
- failing required check caused by the PR
- broken public contract without an accepted migration/versioning plan
- unsafe or irreversible migration behavior
- authorization or data-isolation defect
- required review or repository gate is unsatisfied

### [SHOULD-FIX]

Use for a meaningful defect or maintainability problem that is real but may not justify blocking under repository policy.

Examples:

- missing negative test for a moderately risky path
- avoidable duplicated policy likely to diverge
- incomplete documentation for a non-breaking behavior change
- edge case with limited impact

### [NIT]

Use sparingly for small readability or consistency improvements that do not affect merge readiness.

### [UNCERTAIN]

Use when a material question cannot be resolved from available evidence. State what evidence would resolve it.

Do not use uncertainty as a disguised blocker unless the missing evidence is itself required by repository policy or the potential impact is too high to accept.

## Recommendations

- **merge as-is:** no unresolved blocker, applicable gates are satisfied, and residual uncertainty is acceptable for the risk profile
- **adjust before merge:** a small maintainer or author correction is clearly preferable
- **ask author:** intent or domain evidence is needed
- **decline:** the approach is materially wrong or incompatible with project direction
- **full audit required:** the trusted fast path encountered escalated or suspicious risk that needs the stricter posture
- **insufficient evidence:** a merge recommendation cannot be justified yet

A trusted author does not lower severity. Trust only changes which preventive steps are necessary before evidence can be collected.
