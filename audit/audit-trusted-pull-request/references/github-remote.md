# GitHub Remote Evidence

Collect remote evidence against the exact PR head whenever it affects merge readiness.

## Core evidence

Prefer retrieving:

- PR number, title, author, draft/state, base and head refs
- immutable base and head SHAs
- changed filenames and full patch
- mergeability and merge-state status
- exact-head commit status and checks
- workflow runs and failed job logs when relevant
- reviews and requested changes
- unresolved review threads
- requested reviewers and CODEOWNERS expectations when discoverable
- linked or closing issues
- branch protection and rulesets when they define required gates

With `gh`, useful commands include:

```bash
gh pr view "$PR" --json number,title,body,author,isDraft,state,baseRefName,baseRefOid,headRefName,headRefOid,mergeable,mergeStateStatus,files,statusCheckRollup,closingIssuesReferences,reviews,reviewRequests,url
gh pr diff "$PR"
gh pr checks "$PR"
```

Use REST or GraphQL when `gh pr view` does not expose review threads, rulesets, or another required field.

## Trusted-mode interpretation

Trusted mode can rely more heavily on established repository CI than a hostile audit, but only when the CI applies to the exact head and the PR does not materially redefine the check being trusted.

Old approvals, superseded workflow runs, or checks from another SHA are context, not current proof.

## Mutations

A review result is not permission to mutate GitHub.

Only when authorized:

- submit a review
- add comments
- request reviewers
- resolve threads
- rerun jobs
- push maintainer fixes
- merge

When merging through an API that supports it, provide the expected PR head SHA so a concurrent push cannot silently change what gets merged.
