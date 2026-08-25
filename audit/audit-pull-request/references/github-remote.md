# GitHub Remote Evidence and Actions

Use GitHub's remote primitives to inspect the exact PR state rather than approximating it from local Git alone. Prefer an authenticated GitHub connector or `gh`; use official REST/GraphQL APIs when a high-level command does not expose the required field.

## Core PR Metadata

With `gh`:

```bash
gh pr view "$PR" --json number,title,body,author,isDraft,state,baseRefName,baseRefOid,headRefName,headRefOid,mergeable,mergeStateStatus,commits,files,statusCheckRollup,closingIssuesReferences,reviews,reviewRequests,url
```

Record exact `baseRefOid` and `headRefOid` when available.

Also collect:

- complete changed-file list across pagination
- full diff/patch, not only the first page
- commits and authorship
- requested reviewers and submitted reviews
- top-level PR comments
- inline review threads, including resolved/unresolved state
- linked/closing issues
- labels and milestone when relevant to repository policy
- mergeability and merge-state status

## Exact-Head CI Evidence

Use the PR head SHA, not only the branch name.

Inspect:

- combined commit status
- check runs for the commit
- GitHub Actions workflow runs associated with the commit
- job/step state for failures
- failed job logs when they explain a gate failure
- artifacts only when they are part of the trusted verification process

With `gh`, useful commands include:

```bash
gh run list --commit "$HEAD_SHA"
gh run view <run-id> --log-failed
```

API equivalents include commit status/check-run endpoints and Actions workflow-run/job endpoints.

Represent `success`, `failure`, `cancelled`, `skipped`, `neutral`, `timed_out`, `action_required`, and `in_progress/pending` accurately. Do not flatten all non-red states into passing.

## Branch Protection and Rulesets

When merge readiness depends on repository policy, inspect the base branch's active protection/rulesets when permissions allow. Determine:

- required status checks
- required approving reviews
- code-owner review requirements
- conversation-resolution requirements
- signed-commit or linear-history rules
- merge queue requirements
- restrictions on force pushes or branch updates

A ruleset can replace or supplement classic branch protection. A 404 on a classic protection endpoint does not prove no policy exists.

## Review Threads

Read inline review threads and their resolution state. For each unresolved thread:

- verify whether the referenced code still exists on the current head
- determine whether the concern remains valid
- avoid resolving another reviewer's thread merely because the code changed
- reply or resolve only when the user requests it and repository practice permits it

Treat approvals/change requests as revision-specific context. Verify whether later commits invalidate them.

## Linked Issues

For `closingIssuesReferences` or manually linked issues:

- read the issue requirements independently
- verify the code actually satisfies them
- inspect blockers/dependencies when relevant
- do not treat the link itself as proof of completion

After an explicitly authorized merge, verify the expected issue transition instead of assuming automation worked.

## Remote Mutations

Only when explicitly authorized, use native GitHub actions rather than prose-only simulation:

- submit PR review: `APPROVE`, `COMMENT`, or `REQUEST_CHANGES`
- add inline file comments to precise diff lines
- add a top-level PR comment when appropriate
- request/remove reviewers
- add an existing label when repository policy uses one
- reply to, resolve, or unresolve review threads
- rerun a failed workflow/job when the user asks and retry is justified
- convert draft/ready state only when requested
- enable auto-merge only when explicitly requested and repository policy supports it
- merge only after explicit user authorization

For merge, protect against a moving head by supplying/validating the expected head SHA when the API permits it.

## Remote Verification After Mutation

Re-read the mutated object after any write. Confirm the requested review/comment/label/thread/merge state actually exists on the intended PR and revision.

Do not silently drop unsupported remote metadata or actions. Report the exact operation that could not be completed and continue independent verification where safe.
