# Compatibility Review

Use this reference whenever a PR can affect existing callers, persisted state, deployment, or supported environments.

## Compatibility Surfaces

Review all applicable surfaces:

- source API signatures, exported types, overloads, generics, trait/interface contracts
- binary/ABI compatibility when the ecosystem exposes it
- CLI flags, subcommands, exit codes, stdout/stderr formats, prompts, and shell completion
- configuration keys, defaults, validation, precedence, and environment variables
- HTTP/RPC/GraphQL endpoints, request/response schemas, status codes, headers, pagination, and error shapes
- serialization and wire formats, field names, enum values, nullability, ordering assumptions, and unknown-field behavior
- database schema, migrations, indexes, constraints, data backfills, and rollback
- persisted caches, files, queues, events, object storage, or job payloads consumed across versions
- plugin/hook contracts and extension points
- authentication/authorization semantics and permission defaults
- supported language/runtime versions, browsers, operating systems, architectures, and databases
- package names, module paths, import paths, feature flags, and dependency requirements
- deployment and rollback compatibility during mixed-version operation

## Breaking-Change Traps

An apparently additive PR can still break callers through:

- changing a default
- making an optional field required
- adding a new enum variant to consumers that assume exhaustiveness
- stricter validation
- changing error types or status codes
- changing serialization order/shape where consumers depend on it
- adding an overload or method that changes resolution
- changing timeout/retry behavior
- introducing new permissions or required environment variables
- irreversible migrations or backfills
- new dependency/runtime minimum versions
- changing feature-flag defaults

Do not equate "compiles here" with compatibility.

## Database and Migration Review

For persistence changes, verify:

1. old application against new schema when rolling deploys require it
2. new application against old/intermediate schema when deployment order requires it
3. forward migration on representative data
4. partial failure behavior and retry/idempotency
5. rollback or documented irreversibility
6. lock duration, index/build strategy, table rewrites, and production scale
7. data backfill observability and resumability
8. schema constraints versus existing production data

## API and Schema Review

Check both producer and consumer behavior. Verify versioning policy, deprecation requirements, unknown-field behavior, and whether generated clients or schemas must be refreshed.

For public APIs, compare trusted base and head declarations and search repository callers. When the project publishes a compatibility checker, API report, schema diff, ABI checker, or generated client test, use the repository's trusted tool.

## Runtime and Platform Review

Match changes against the repository's supported matrix. Look for:

- path/case sensitivity
- shell assumptions
- filesystem semantics
- locale/timezone behavior
- architecture-specific integer/endianness issues
- browser/runtime APIs
- database dialect/version behavior
- container/rootless behavior

Do not apply one ecosystem's assumptions to another project.

## Compatibility Verdict

Use one of:

- `confirmed`: evidence covers all material compatibility surfaces
- `breaking`: a concrete supported caller/state/environment breaks
- `uncertain`: a material surface lacks sufficient evidence
- `not applicable`: no compatibility surface is affected, with a short reason

If a breaking change is intentional, verify versioning, migration/deprecation, docs, and release policy rather than downgrading the finding merely because the break was planned.
