# Finding Severity

Assign severity from impact and merge disposition, not from how strongly the reviewer feels about the code.

## Levels

### `[CRITICAL]`

Use for credible malicious behavior or a severe, readily exploitable vulnerability with major confidentiality, integrity, availability, supply-chain, or deployment impact.

Examples include confirmed credential exfiltration, a practical authentication bypass, workflow code exposing production secrets to untrusted PR code, or malicious dependency substitution.

Disposition: stop dynamic execution when relevant, contain exposure, and do not merge.

### `[BLOCKING]`

Use for defects that make the PR unsafe or incorrect to merge:

- correctness bug or regression in supported behavior
- security/privacy flaw that must be fixed
- backward-compatibility break that violates project policy
- unsafe migration or rollback path
- required tests missing when the behavior cannot be safely established otherwise
- CI/workflow weakening that invalidates required gates
- misleading implementation that does not actually satisfy the linked issue/specification
- unresolved hostile-change concern

Disposition: changes required before merge.

### `[SHOULD-FIX]`

Use for bounded quality, maintainability, test, documentation, observability, or design issues worth correcting before merge when practical, but not enough alone to make the current change unsafe.

Disposition: prefer correction, but repository policy and context can permit merge.

### `[NIT]`

Use only for cosmetic or very low-impact polish with no material correctness, safety, compatibility, or maintenance consequence.

Disposition: optional.

### `[UNCERTAIN]`

Use when a material merge-relevant question cannot be resolved from available evidence.

State exactly:

- what is unknown
- why current evidence is insufficient
- what evidence would resolve it
- whether the uncertainty blocks merge under project risk/policy

Do not silently treat uncertainty as success.

## Finding Quality Bar

Every non-nit finding should include:

1. exact location or affected surface
2. observed behavior or evidence
3. user/security/operational impact
4. failure or exploit path when relevant
5. smallest clean correction
6. test or verification needed to prove the correction

Avoid style-only findings unless repository policy makes the style rule behaviorally meaningful.

## Recommendation Mapping

Use the highest unresolved severity plus repository policy:

- unresolved `[CRITICAL]` -> `decline` / do not execute or merge
- unresolved `[BLOCKING]` -> `adjust before merge` or `ask author`
- material `[UNCERTAIN]` -> `insufficient evidence` unless the project explicitly accepts the risk
- only `[SHOULD-FIX]`/`[NIT]` -> `merge as-is` may be reasonable if required gates pass
- no findings -> `merge as-is` may be recommended, while still stating residual audit scope

A recommendation is not merge authorization.
