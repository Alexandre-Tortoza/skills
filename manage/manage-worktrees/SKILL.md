---
name: manage-worktrees
description: Use this skill when creating, inspecting, coordinating, integrating, removing, or pruning Git worktrees; when isolating risky, experimental, or parallel development; when delegating work to agents in separate branches; or when the user explicitly asks to use Git worktrees. Enforce preflight checks, explicit approval for Git mutations, lane ownership, diff validation, safe integration, and cleanup.
license: MIT
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "1.0.0"
---

# Manage Git Worktrees

Manage Git worktrees as safe, isolated development lanes for parallel work, risky changes, experiments, reviews, and delegated agent execution.

The coordinating agent owns the full worktree lifecycle: planning, base selection, branch and path selection, lane ownership, delegation, validation, integration, and cleanup. Delegated agents may work inside a lane, but must not independently create, integrate, remove, prune, or reassign worktrees unless the user has explicitly approved that operation.

## Core Contract

Use one lane per independent unit of work.

Default conventions:

```text
worktree path: .worktrees/<slug>/
branch:        worktree/<slug>
manifest:      .worktrees.json
```

Respect repository or user conventions when they already exist. Do not rename an established worktree directory, branch namespace, or manifest format merely to match these defaults.

Keep worktrees inside the repository root by default instead of creating sibling directories. If repository tooling does not tolerate nested worktrees, explain the conflict and use the repository's established location or ask the user to choose an alternative.

Never perform lane work in the main checkout when the task was assigned to a worktree. Builds, tests, edits, commits, and delegated-agent commands for that lane must execute with the worktree as the working directory.

## Progressive Disclosure

Read `references/safety.md` before any mutation when:

- creating or removing a worktree;
- creating, deleting, or renaming a branch;
- merging, rebasing, or cherry-picking;
- pruning worktree metadata;
- handling dirty worktrees, stale registrations, conflicts, or recovery;
- considering destructive commands.

Use the bundled scripts for repeatable preflight, creation, and cleanup operations:

```text
scripts/inspect-worktrees.sh
scripts/create-worktree.sh
scripts/cleanup-worktree.sh
```

The scripts are non-interactive. Approval flags are execution guards, not substitutes for obtaining user approval first.

## State Tracking

Use `.worktrees.json` as local workflow metadata when managing one or more lanes. Create it when the first lane is initialized if no repository-specific manifest already exists.

Recommended shape:

```json
{
  "version": "1.0.0",
  "updatedAt": "2026-08-25T00:00:00.000Z",
  "lanes": [
    {
      "slug": "feature-auth-v2",
      "branch": "worktree/feature-auth-v2",
      "path": ".worktrees/feature-auth-v2",
      "base": "main",
      "purpose": "refactor authentication flow to OAuth2",
      "owner": "coordinator",
      "status": "active",
      "areas": ["src/auth", "src/config"],
      "createdAt": "2026-08-25T00:00:00.000Z"
    }
  ]
}
```

Treat `.worktrees.json` as local metadata by default. Do not commit it unless the repository already treats worktree state as project configuration or the user explicitly requests that convention.

Allowed lane statuses should remain simple and meaningful, for example `planned`, `active`, `ready`, `integrated`, `blocked`, and `archived`.

Update the manifest when a lane is created, its ownership or scope changes, it becomes ready, it is integrated, or it is removed. Do not let the manifest override Git itself: `git worktree list --porcelain` is the source of truth for registered worktrees.

## Safety Rules

Before any Git mutation:

1. Confirm the current directory belongs to the intended Git repository.
2. Identify the repository root and current checkout.
3. Inspect the current branch and detached-HEAD state.
4. Inspect `git status --short` in every checkout affected by the operation.
5. Run `git worktree list --porcelain` and check for branch or path conflicts.
6. Resolve the intended base ref to an exact commit.
7. Verify the proposed branch does not already exist locally or on the relevant remote unless reuse is intentional.
8. Verify the proposed path is not already registered or occupied.
9. Confirm `.worktrees/` and `.worktrees.json` are ignored by Git before creating a nested lane.
10. Obtain explicit user approval for the exact mutation.

Explicit approval is required before:

- `git worktree add`;
- `git worktree remove`;
- branch creation, deletion, or renaming;
- merge, rebase, or cherry-pick;
- `git worktree prune` or `git prune`;
- `git reset --hard`, `git clean`, force pushes, forced branch deletion, forced worktree removal, or deletion of a dirty worktree directory.

Approval for one operation does not imply approval for a later destructive operation.

Never discard, overwrite, clean, reset, or delete uncommitted user work.

## Ignore File Setup

Before creating or cleaning nested lanes, inspect `.gitignore` and `.ignore` at the repository root.

Maintain this exact managed block in `.gitignore`:

```gitignore
# BEGIN manage-worktrees
.worktrees/
.worktrees.json
# END manage-worktrees
```

When `.ignore` is present or the repository uses it for agent/search visibility, maintain this allowlist block:

```ignore
# BEGIN manage-worktrees
!.worktrees.json
!.worktrees/
!.worktrees/**
# END manage-worktrees
```

If a managed block already exists, update that block in place. Otherwise append it. Do not duplicate entries and do not rewrite unrelated ignore rules.

If the repository already has equivalent ignore rules, preserve them rather than adding redundant managed entries.

## Workflow

### Phase 1: Decide Whether a Worktree Is Appropriate

Use a worktree when at least one of these is true:

- the task is risky or potentially destabilizing;
- multiple tasks or agents must proceed in parallel;
- the user needs rapid context switching without stashing unfinished work;
- the work is exploratory and may be discarded;
- an upgrade, migration, refactor, or integration needs isolation;
- the user explicitly requests a worktree.

Avoid creating a worktree for trivial documentation edits, tiny single-file changes, or work that does not benefit from isolation.

Be cautious with repositories that have unsupported or tightly coupled submodule, generated-file, filesystem, or tooling assumptions. Inspect repository instructions before proceeding.

### Phase 2: Plan the Lane

Define:

- `slug`: short, filesystem-safe identifier;
- `purpose`: one-sentence task boundary;
- `base`: branch, tag, or commit from which the lane starts;
- `branch`: default `worktree/<slug>` unless repository conventions differ;
- `path`: default `.worktrees/<slug>`;
- `owner`: coordinating agent or delegated worker;
- `areas`: files or directories the lane is expected to own.

For parallel lanes, minimize overlapping ownership. If overlap is unavoidable, record it and plan integration order before delegation.

Inspect first:

```bash
bash scripts/inspect-worktrees.sh
```

Then show the proposed lane, base, branch, path, and purpose to the user and obtain approval before creation.

### Phase 3: Create the Lane

After approval, prefer the guarded helper:

```bash
bash scripts/create-worktree.sh \
  --slug <slug> \
  --base <base-ref> \
  --confirm
```

Specify a custom branch when necessary:

```bash
bash scripts/create-worktree.sh \
  --slug <slug> \
  --base <base-ref> \
  --branch <branch-name> \
  --confirm
```

Equivalent Git command:

```bash
git worktree add -b <branch-name> .worktrees/<slug> <base-ref>
```

After creation:

1. Verify the lane appears in `git worktree list --porcelain`.
2. Verify its HEAD and branch are the expected values.
3. Register the lane in `.worktrees.json`.
4. Set delegated tools or agents to the lane path as their working directory.

### Phase 4: Execute and Delegate

For every lane:

1. Keep edits, build artifacts, tests, package-manager operations, and commits inside the lane.
2. Give delegated agents the exact worktree path, task boundary, owned areas, base, and expected validation commands.
3. Do not let one lane edit files owned by another lane without re-planning ownership.
4. Re-inspect status before and after significant delegated work.
5. Commit only when the user requested commits or approved checkpoint commits.
6. Never use a worktree as permission to bypass repository instructions, hooks, tests, branch protection, or review requirements.

### Phase 5: Validate the Lane

Before integration:

1. Inspect `git status --short` inside the lane.
2. Run repository-required tests, linters, type checks, builds, or targeted verification proportional to the change.
3. Compare the lane to its recorded base.
4. Review the complete diff, not only the last commit.
5. Check for accidental generated files, secrets, unrelated edits, lockfile drift, and ownership violations.
6. Reconcile the lane with any base changes if necessary, but obtain approval before rebase, merge, or cherry-pick mutations.

Useful comparisons:

```bash
git -C .worktrees/<slug> status --short
git diff <base>...<branch>
git log --oneline --decorate <base>..<branch>
```

Present the validation result and integration plan before asking for approval to integrate.

### Phase 6: Integrate

Integration is a separate mutation from lane creation and requires explicit approval.

Use the repository's established strategy. Typical options are:

- merge the worktree branch;
- rebase the lane onto the integration base, then merge;
- cherry-pick selected commits;
- push the lane branch and open a pull request instead of integrating locally.

Perform local integration from the main checkout or another explicitly approved integration checkout, never from an unrelated lane.

After integration, verify the resulting history and run any final checks required by the repository.

### Phase 7: Cleanup and Prune

Before cleanup:

1. Confirm the lane is integrated, intentionally archived, or otherwise safe to remove.
2. Confirm `git status --short` inside the lane is empty.
3. Confirm no delegated process still uses the path.
4. Confirm the branch and commits remain recoverable if needed.
5. Obtain approval to remove the worktree.

Then use:

```bash
bash scripts/cleanup-worktree.sh \
  --slug <slug> \
  --confirm
```

Branch deletion is a separate action. Only request it after confirming the branch is no longer needed. The helper only uses safe `git branch -d` deletion:

```bash
bash scripts/cleanup-worktree.sh \
  --slug <slug> \
  --confirm \
  --delete-branch \
  --confirm-branch-delete
```

Pruning stale worktree metadata is also separate and requires explicit approval:

```bash
bash scripts/cleanup-worktree.sh \
  --prune \
  --confirm-prune
```

After cleanup, update `.worktrees.json` to archive or remove the lane record. Keep historical records only when useful to the workflow.

## Gotchas

- A branch can be checked out by only one worktree at a time. Do not reuse an active branch in another lane.
- Deleting a worktree directory manually does not correctly unregister it. Use `git worktree remove` or recover/prune according to `references/safety.md`.
- A dirty worktree must not be removed. Preserve and surface the changes first.
- A stale manifest entry does not prove a worktree exists. Verify with Git.
- A missing manifest entry does not mean an existing registered worktree is safe to delete.
- Do not assume `main` is the base. Detect or explicitly select the intended base.
- Do not assume `origin` exists. Remote branch checks are conditional on configured remotes.
- Do not force-delete branches merely to make cleanup succeed.
- Do not run integration commands from whichever checkout happens to be current. Identify the integration checkout deliberately.
- Do not allow parallel lanes with broad overlapping ownership unless the merge order and conflict strategy are explicit.

## Output Contract

When planning or reporting worktree operations, include the relevant facts concisely:

```text
Repository: <root>
Operation: <inspect|create|integrate|remove|prune>
Lane: <slug or n/a>
Base: <ref and resolved commit>
Branch: <branch>
Path: <path>
Status: <planned|active|ready|integrated|blocked|archived>
Dirty: <yes|no>
Validation: <checks run or pending>
Approval required: <exact next mutation or none>
```

For parallel work, also report ownership and dependencies between lanes.

## Validation Loop

Before finishing any worktree-management task:

1. Re-run `git worktree list --porcelain`.
2. Re-check the affected checkout statuses.
3. Confirm paths and branches match the intended lane records.
4. Confirm no user changes were lost or overwritten.
5. Confirm the manifest reflects the actual lifecycle state if it is in use.
6. Confirm every mutation performed had explicit user approval.
7. Report any remaining lane, branch, stale metadata, or integration follow-up clearly.
