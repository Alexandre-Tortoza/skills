# Git Worktree Safety Reference

Read this reference before any worktree mutation, integration operation, cleanup, stale-registration repair, or destructive recovery.

## Safety Invariants

These invariants override convenience:

1. Never destroy uncommitted user work.
2. Never infer approval for a destructive operation from approval for an earlier operation.
3. Never remove a dirty worktree.
4. Never force-delete a branch merely to complete cleanup.
5. Never integrate a lane without reviewing its full diff against the intended base.
6. Never trust `.worktrees.json` over Git's registered worktree state.
7. Never run a mutation against a repository, branch, or path that has not been identified explicitly.
8. Never assume the current checkout is the correct integration checkout.

## Preflight Commands

Use read-only inspection first:

```bash
git rev-parse --show-toplevel
git rev-parse --is-inside-work-tree
git symbolic-ref --quiet --short HEAD || git rev-parse --short HEAD
git status --short
git worktree list --porcelain
git remote -v
git branch --all --verbose --no-abbrev
```

For an intended base ref:

```bash
git rev-parse --verify '<base>^{commit}'
```

For a proposed local branch:

```bash
git show-ref --verify --quiet 'refs/heads/<branch>'
```

For a proposed path:

```bash
test -e '<path>'
```

If a remote exists and remote uniqueness matters:

```bash
git ls-remote --exit-code --heads <remote> '<branch>'
```

A failing `git ls-remote --exit-code` may mean either no matching branch or a transport/authentication problem. Distinguish those cases before concluding the branch is available.

## Approval Boundaries

Obtain explicit user approval immediately before each class of mutation.

### Worktree creation

Approval must cover:

- base ref;
- new branch name if a branch will be created;
- worktree path;
- the fact that `git worktree add` will run.

Do not interpret "use a worktree" as approval for an arbitrary base, path, or branch name if those choices materially affect the repository.

### Worktree removal

Approval must cover the exact lane/path being removed.

Before asking:

```bash
git -C '<worktree-path>' status --short
```

If output is non-empty, stop. Surface the changes and preserve the lane.

### Branch deletion

Branch deletion is separate from worktree removal. Ask separately unless the user's instruction explicitly included both operations.

Prefer:

```bash
git branch -d '<branch>'
```

Do not use `git branch -D` unless the user explicitly authorizes forced deletion after being shown why Git considers the branch unmerged.

### Integration

Merge, rebase, and cherry-pick are distinct mutations. State the intended strategy before asking for approval.

Before integration, show enough information to evaluate the result:

```bash
git diff --stat '<base>...<branch>'
git diff '<base>...<branch>'
git log --oneline --decorate '<base>..<branch>'
```

If the base has moved, explain whether the plan is to merge the updated base, rebase the lane, or integrate without rewriting the lane.

### Pruning

`git worktree prune` removes stale administrative records for worktrees Git believes are no longer present. It is not equivalent to removing a live worktree.

Inspect first:

```bash
git worktree list --porcelain
git worktree prune --dry-run --verbose
```

Only run actual pruning after approval:

```bash
git worktree prune --verbose
```

Treat `git prune` as a separate, broader object-database maintenance operation. Do not substitute it for `git worktree prune`.

## Ignore Rules

Nested worktrees must not appear as ordinary untracked content in the main checkout.

Preferred `.gitignore` block:

```gitignore
# BEGIN manage-worktrees
.worktrees/
.worktrees.json
# END manage-worktrees
```

When `.ignore` is used for search or agent visibility:

```ignore
# BEGIN manage-worktrees
!.worktrees.json
!.worktrees/
!.worktrees/**
# END manage-worktrees
```

When updating managed blocks:

1. If both begin and end markers are absent, append the block.
2. If both are present once, replace only the contents of that managed block.
3. If only one marker is present, stop and repair manually rather than guessing.
4. If duplicate managed blocks exist, stop and normalize deliberately.
5. Preserve unrelated ignore entries exactly.
6. If equivalent project-specific rules already exist, prefer them over redundant additions.

## Branch and Path Collisions

A branch already checked out in another worktree cannot be checked out normally in a new one.

Inspect registrations:

```bash
git worktree list --porcelain
```

Never solve a collision by forcing checkout or modifying worktree metadata manually.

For path collisions:

- if the directory exists and is not a registered worktree, inspect it before doing anything;
- if it contains files, do not overwrite or delete them;
- if it is an abandoned empty directory, removal still requires confidence that it contains no user data;
- prefer choosing a different slug/path over destructive cleanup.

## Dirty Worktrees

A dirty lane is a preservation problem, not a cleanup target.

Inspect:

```bash
git -C '<path>' status --short
git -C '<path>' diff
git -C '<path>' diff --cached
```

Also inspect untracked files explicitly through `git status --short`.

Possible safe outcomes include:

- keep the lane intact;
- commit after explicit user request or approval;
- create a patch or other archive if the user requests it;
- move work through an approved integration strategy.

Do not auto-stash as an invisible cleanup mechanism unless the user explicitly asks for or approves that behavior.

## Stale or Missing Worktree Registrations

### Directory missing, registration remains

Inspect:

```bash
git worktree list --porcelain
git worktree prune --dry-run --verbose
```

If the registration is stale, use approved `git worktree prune`, not manual deletion inside `.git/worktrees/`.

### Directory exists, Git does not register it

Do not assume it is disposable. Inspect the directory and its `.git` file or directory before taking action.

A valid linked worktree normally has a `.git` file pointing to Git administrative metadata. If metadata is broken, prefer Git-supported repair commands available in the installed Git version over hand-editing administrative files.

Check capabilities locally:

```bash
git worktree --help
```

Do not assume `git worktree repair` exists on every Git version.

## Locked Worktrees

A worktree can be locked to prevent pruning or accidental administrative cleanup.

Inspect lock state through:

```bash
git worktree list --porcelain
```

If a worktree is locked, do not unlock it merely to continue cleanup. Determine why it is locked and obtain approval before changing that state.

Relevant commands may include:

```bash
git worktree lock '<path>'
git worktree unlock '<path>'
```

Treat lock and unlock as mutations requiring explicit intent.

## Submodules

Worktrees and submodules can create repository-specific constraints.

Before creating lanes in a repository with submodules:

```bash
git submodule status --recursive
```

Check project instructions for whether each worktree must initialize or update submodules independently. Never run recursive submodule update commands merely because a worktree was created.

## Hooks, LFS, Sparse Checkout, and Generated State

Worktrees share the same repository object database but may have checkout-specific state.

Inspect repository conventions before assuming that the following are lane-independent:

- Git LFS materialization;
- sparse-checkout configuration;
- package-manager caches;
- generated files;
- environment files;
- build output;
- hook behavior;
- IDE metadata;
- local databases or service ports.

When parallel lanes run applications or tests concurrently, avoid shared mutable resources such as the same dev-server port, database schema, temporary directory, or generated output location unless the project explicitly supports it.

## Integration Conflict Safety

If a merge, rebase, or cherry-pick conflicts:

1. Stop delegating new edits into the affected integration checkout.
2. Inspect conflict status.
3. Explain which operation is in progress.
4. Resolve only conflicts within the approved integration scope.
5. Do not abort or continue the operation automatically if that choice would discard conflict-resolution work already performed by the user or another agent.

Useful inspection:

```bash
git status
git diff --name-only --diff-filter=U
```

Abort commands such as `git merge --abort`, `git rebase --abort`, or `git cherry-pick --abort` are mutations. Use them only when their effect is understood and approved where user work could be affected.

## Destructive Commands

The following require exceptional care and explicit approval for the exact command/effect:

```text
git reset --hard
git clean -f / -fd / -fdx
git branch -D
git push --force / --force-with-lease
git worktree remove --force
rm -rf <worktree-path>
manual deletion under .git/worktrees/
```

Prefer a non-destructive alternative whenever one exists.

`--force-with-lease` is safer than `--force` for pushes, but it is still a history-rewriting remote mutation and must not be treated as routine cleanup.

## Recovery Checklist

When something is inconsistent:

1. Stop mutations.
2. Identify the repository root.
3. Capture `git worktree list --porcelain`.
4. Capture status from every relevant existing checkout.
5. Record branch-to-path mappings.
6. Resolve important branch tips to commit SHAs.
7. Preserve dirty worktrees.
8. Compare `.worktrees.json` with Git state if the manifest exists.
9. Use Git-supported repair or prune operations where appropriate.
10. Resume lifecycle operations only after the state is understood.

## Final Safety Validation

Before declaring cleanup or integration complete, confirm:

- every intended worktree is registered or removed as expected;
- every surviving worktree has the expected branch/HEAD;
- no affected checkout contains unexpected uncommitted changes;
- no branch was force-deleted;
- no unapproved destructive command ran;
- the integration result contains the intended commits and diff;
- local metadata matches Git state if `.worktrees.json` is used;
- no stale path or administrative record remains unless intentionally preserved.
