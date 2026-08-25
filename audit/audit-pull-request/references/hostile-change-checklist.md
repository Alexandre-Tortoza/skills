# Hostile-Change Checklist

Complete this static gate before checking out or executing PR code.

## Inventory Every Change

Use pinned SHAs:

```bash
git diff --stat "$BASE_SHA...$HEAD_SHA"
git diff --name-status "$BASE_SHA...$HEAD_SHA"
git diff --numstat "$BASE_SHA...$HEAD_SHA"
git diff --check "$BASE_SHA...$HEAD_SHA"
git diff --summary "$BASE_SHA...$HEAD_SHA"
git diff --submodule=log "$BASE_SHA...$HEAD_SHA"
git ls-tree -r -l "$HEAD_SHA"
```

`scripts/inspect-diff.sh` runs a safe subset of these and prints review hints. Its output is not a verdict; inspect the actual hunks.

## File and Encoding Risks

Explicitly review:

- new executable bits or changed file modes
- symlinks and their targets
- submodules and submodule URL/commit changes
- binaries, archives, minified bundles, generated artifacts, vendored code, and large opaque blobs
- Unicode bidi controls, homoglyphs, zero-width characters, or misleading file extensions
- encoded/encrypted/compressed payloads without a clear repository reason
- `.gitattributes`, clean/smudge filters, Git LFS configuration, hooks, and attributes that affect checkout or diffs

## Execution Surfaces

Treat all code-execution surfaces as high risk, including:

- CI workflows and reusable workflows
- Dockerfiles, Compose files, container entrypoints
- package-manager lifecycle scripts and install hooks
- compiler plugins, proc macros, build backends, Gradle/Maven plugins, MSBuild targets
- `build.rs`, `go generate`, Makefiles, task runners, shell/PowerShell scripts
- test discovery/configuration, custom pytest plugins, Jest/Vitest setup, doctests, fixtures, benchmark harnesses
- migrations, seeders, generators, example code that is executed in CI
- release, signing, publishing, deployment, packaging, and artifact-upload logic

Do not execute these merely because a contributor says they are safe.

## Capability Expansion

Trace additions or changes to:

- network calls, webhooks, telemetry, DNS, sockets, package registries
- environment-variable and credential reads
- filesystem reads/writes outside expected project paths
- process execution, shells, dynamic loading, `eval`/reflection, plugin loading
- unsafe deserialization, archive extraction, template rendering, SQL/query construction
- authentication, authorization, impersonation, tenant scoping, permission checks
- cryptography, signature verification, token validation, trust stores
- privileged operations, sudo, setuid/capabilities, container privileges
- deletion, persistence, startup/autostart, scheduled tasks, or destructive cleanup

## Supply Chain

For every new or changed direct or transitive dependency, inspect:

- package name for typosquatting or namespace confusion
- registry/source changes
- git, URL, local path, workspace, or unpublished dependencies
- widened version ranges or unexpected downgrades
- newly enabled features/extras
- lifecycle/install/build scripts
- lockfile changes that do not correspond to manifest intent
- integrity/checksum changes
- new native binaries or post-install downloads
- dependency confusion risk in private package names

When practical, compare dependency diffs using the ecosystem's trusted tooling after static review.

## GitHub Actions and CI

Inspect workflow changes for:

- `pull_request_target` executing attacker-controlled checkout/content
- write permissions that are broader than necessary
- secrets available to untrusted code
- attacker-controlled interpolation into `run:` shells
- unpinned or mutable third-party actions
- action ref changes from commit SHA to tag/branch
- artifact substitution or unsafe cross-workflow artifact consumption
- cache poisoning across trust boundaries
- changed event triggers or branch filters
- skipped/reduced tests hidden behind conditionals
- release, package publish, signing, deployment, or environment expansion
- self-hosted runner exposure

A green workflow is only trustworthy if the workflow definition and its dependencies are also acceptable.

## Blocking Signals

Stop dynamic execution and report when you find unexplained or credible:

- credential/token/key access outside normal project behavior
- covert or unrelated network egress
- backdoor-like authentication/authorization bypass
- destructive persistence or data deletion
- privilege expansion
- obfuscation intended to hide behavior
- workflow secret exposure to contributor-controlled code
- dependency substitution or malicious install behavior
- release/deploy path expansion that can publish or execute unreviewed code

Use `[CRITICAL]` for severe readily exploitable malicious/security behavior and `[BLOCKING]` for unsafe behavior that must be corrected before merge.

## Safe Disposition

If suspicious behavior cannot be resolved statically:

- do not run the suspect code on the host
- preserve the exact head SHA and evidence
- explain the uncertain behavior and potential impact
- request a minimal clarifying change or trusted reproduction path
- use a stronger sandbox only when the user/project context makes dynamic analysis appropriate
