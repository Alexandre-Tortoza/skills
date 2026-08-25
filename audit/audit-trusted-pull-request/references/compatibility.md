# Compatibility Review

Read this reference when the PR can affect consumers outside the edited function or file.

## Surfaces

Check compatibility for:

- public functions, types, events, routes, and APIs
- CLI commands, flags, exit codes, and output consumed by scripts
- configuration keys, defaults, environment variables, and precedence
- JSON, GraphQL, protobuf, database, message, or other wire schemas
- persisted data and migrations
- package exports and module paths
- supported runtimes, browsers, operating systems, database versions, or deployment platforms
- upgrade and downgrade behavior

## Trusted fast-path rule

Do not demand exhaustive compatibility analysis for a clearly internal change. Do require explicit compatibility evidence when the diff changes a consumer-facing contract or persisted state.

## Questions

- Can an existing caller continue working unchanged?
- Did a default value or omission behavior change?
- Are old and new versions expected to coexist during rollout?
- Can old data still be read?
- Does the migration tolerate partially upgraded environments?
- Is rollback possible after new data is written?
- Did generated clients, docs, fixtures, or examples need updating?

## Severity guidance

An undocumented breaking change to a stable public contract is normally blocking unless the repository explicitly permits it for the target release.

A deliberate breaking change with correct versioning, migration guidance, and repository approval may be acceptable. Audit whether the change is intentional and complete rather than rejecting breaking changes categorically.
