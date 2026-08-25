# Testing and Verification Gates

Testing is evidence, not a ritual. Decide what evidence is needed from the changed surfaces, then run the smallest trusted checks that establish it and the complete applicable gate on the final candidate.

## Before Running Anything

Complete the hostile-change gate first. Builds and tests can execute code through install hooks, build plugins, test discovery, fixtures, generators, macros, migrations, and setup scripts.

Use a disposable isolated environment when practical. Do not expose secrets, the Docker socket, cloud metadata, or unrelated host data.

## Classify the Change

Identify whether the PR changes:

- runtime source
- build/test execution
- dependencies or lockfiles
- migrations or persisted data
- public API/schema/config/CLI behavior
- workflows/release/deployment plumbing
- generated code/assets
- docs/metadata only

The classification determines which previous results remain valid and which gates are required.

## Detect the Project Profile

Prefer trusted project instructions and existing CI over generic commands. Typical signals:

| Signal | Typical gates to confirm from the project |
|---|---|
| `Cargo.toml` | `cargo fmt --all -- --check`, configured clippy, tests, dependency policy tooling |
| `package.json` | committed package manager's format/lint/typecheck/test/build scripts |
| `pyproject.toml`, `setup.cfg`, `setup.py` | configured formatter/linter/type checker and pytest; inspect build backend/plugins first |
| `go.mod` | formatting, `go vet`, `go test ./...`; run `go generate` only when trusted and required |
| `Gemfile` | repository test/lint/security tasks through Bundler |
| `pom.xml`, `build.gradle*` | repository wrapper test/lint tasks after plugin review |
| `.sln`, `*.csproj` | configured `dotnet` format/build/test gates |
| `mix.exs` | configured format/lint/test tasks |

If several profiles exist, run root gates plus touched-component gates. Do not force ecosystem-specific checks onto a project that does not use that stack.

## Focused Regression Evidence

For claimed bug fixes, prefer evidence that distinguishes base from head:

1. reproduce or identify the base failure
2. confirm the new regression test fails on base when feasible
3. confirm it passes on head
4. inspect whether the test actually reaches the changed behavior
5. add/inspect negative, boundary, rollback, failure, concurrency, and platform cases proportional to risk

## Reusing Previous Results

Reuse a prior successful result only when all are recorded and true:

- the run belongs to an immutable commit
- relevant file/tree inputs are byte-identical to current head
- toolchain, features, lockfile, test configuration, and material environment are equivalent
- later changes cannot affect the reused gate
- current-head focused checks cover every changed surface
- the audit identifies which previous run supplied reused evidence

Do not reuse a green result across changed runtime/build code, dependencies, security policy, schemas, migrations, workflows, fixtures, generated inputs, or test configuration.

A docs-only follow-up can sometimes reuse behavioral gates if input equivalence is demonstrated. A version-only change still needs packaging/metadata resolution and an appropriate compile/package smoke when those surfaces can fail.

## Hosted CI

A hosted green result supports the audit only when:

- it ran on the exact head being audited
- the workflow definition is trusted or its changes were audited
- required jobs were not skipped/cancelled
- branch/ruleset requirements are satisfied
- the job actually exercises the claimed behavior

Inspect failed job logs for actionable evidence. Distinguish infrastructure/flaky failure from a code failure only when evidence supports that distinction.

## Final Candidate Rule

Run the complete applicable trusted gate once on the final materially changed candidate. During maintainer adjustments, use focused checks for iteration, then repeat the full gate after the final material change.

If a later docs/metadata-only change reuses a complete gate, record why the relevant inputs are equivalent.

For multi-PR batches, each PR needs its own risk-focused evidence. After merges change the base, refresh downstream PRs. The last integration candidate should complete the exact-main/merge-specific gate required by repository policy rather than inheriting a stale green result.
