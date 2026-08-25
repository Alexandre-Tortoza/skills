# Risk Escalation

The trusted fast path is optimized for benign routine engineering changes. Escalate because of impact or evidence, not because of contributor identity.

## Low-risk examples

Typical low-risk changes include:

- documentation and examples
- narrow UI behavior
- localized application logic
- tests that do not introduce new execution infrastructure
- small internal refactors with stable public behavior
- straightforward bug fixes with bounded blast radius

Review these completely, but use focused tests and concise reporting.

## Moderate-risk examples

Increase review depth for:

- public API changes
- schemas and serialization
- database migrations
- parsers and validators
- concurrency and async control flow
- retry, caching, transactional, or idempotency logic
- network protocols and external integrations
- persistent state and upgrade paths
- broad cross-module refactors

For these, verify negative paths, compatibility, rollback or migration assumptions, and regression behavior proportionally.

## Escalated surfaces

Adopt the strict gates from `audit-pull-request` when a PR materially changes any of these:

- authentication, authorization, tenant isolation, session handling, cryptography, or secret access
- GitHub Actions, CI/CD, release, deployment, infrastructure, or repository permissions
- dependency source, package registry configuration, lifecycle hooks, install scripts, compiler plugins, build plugins, or executable toolchain code
- binaries, native artifacts, vendored executables, submodules, symlinks, executable-bit changes, or opaque generated payloads
- code that reads credentials, shells out, modifies the host, writes outside the repository, or expands network access unexpectedly
- destructive or irreversible migrations
- artifact provenance, signing, publishing, package release, or container publishing
- suspicious obfuscation, encoded payloads, Unicode controls, unexplained minified code, or behavior that contradicts the stated purpose

Escalation does not automatically mean the PR is unsafe. It means the lightweight assumptions are no longer adequate.

## Escalation behavior

When escalation occurs:

1. keep the same pinned `BASE_SHA` and `HEAD_SHA`
2. state the reason for escalation
3. inspect the affected surface using the stricter full-audit rules
4. use isolation before executing PR-controlled hooks, builds, plugins, or dependency installation when appropriate
5. verify supply-chain, credential, workflow, provenance, and permission implications as applicable
6. report `full audit required` when the risk is cross-cutting or cannot be bounded confidently

Do not downgrade an escalated finding because the author is trusted.
