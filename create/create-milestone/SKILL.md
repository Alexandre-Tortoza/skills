---
name: create-milestone
description: Use this skill when the user asks to create, draft, plan, refine, reopen, close, or populate a GitHub or GitLab milestone; organize issues, pull requests, merge requests, epics, or work items around a release, launch, migration, delivery phase, or target date; convert a release plan into milestone scope and exit criteria; or manage milestone membership, dates, state, and release linkage. Inspect existing milestones and planning conventions first, then use native gh/glab and official APIs. Choose GitLab project vs group scope deliberately, avoid duplicate or conflicting milestones, and never invent dates or silently create work items.
license: MIT
compatibility: Requires a Git repository. Remote mutations require authenticated GitHub CLI (gh), GitLab CLI (glab), or equivalent API access with sufficient repository or group permissions.
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.2"
---

# Create Milestone

Create outcome-oriented milestones whose scope, schedule, membership, and completion state are represented by native remote capabilities rather than only by prose.

## Core Rules

1. **Inspect before creating.** Detect the platform, repository or group scope, existing milestones, release conventions, iterations, roadmap/project usage, naming patterns, and nearby work before choosing a title or dates.
2. **Milestones represent delivery boundaries.** A milestone should group coherent work around a finite outcome such as a release, launch, migration, or delivery phase. Do not use a milestone as a generic backlog bucket.
3. **Choose the correct planning primitive.** Do not substitute a milestone for an epic, issue, project, iteration, sprint, or release when another primitive better represents the user's intent.
4. **Use the strongest native capability.** Prefer dedicated CLI commands, then official APIs, then a textual fallback only when the platform cannot represent the concept natively.
5. **Do not invent planning data.** Reuse repository naming and scheduling conventions. Never fabricate a start date, due date, release date, owner, estimate, or membership.
6. **Do not silently create work items.** A request to create a milestone does not imply permission to create issues, pull requests, merge requests, or epics. Assign existing work when requested or clearly identified; create new work items only when the user asks for them.
7. **Keep native membership authoritative.** The remote milestone association is the source of truth. Description links may explain scope but must not replace native assignment.
8. **Treat destructive lifecycle changes carefully.** Prefer closing a completed or abandoned milestone over deleting it. Delete only when the user explicitly requests deletion or repository policy clearly requires it.
9. **Use non-interactive commands.** Never depend on editors, confirmation prompts, or TTY input.
10. **Preserve draft-only intent.** If the user requests a draft or plan only, do not mutate the remote.
11. **Verify the final remote state.** Re-read the milestone and its assigned work after mutation. Command success text is not sufficient.

## Progressive Disclosure

Read supporting files only when needed:

- Read `references/milestone-design.md` whenever defining milestone scope, naming, dates, exit criteria, or deciding whether a milestone is the correct primitive.
- Read `references/github.md` for GitHub repositories or when using `gh`.
- Read `references/gitlab.md` for GitLab repositories or when using `glab`.
- Run `scripts/validate_milestone.py` against the final Markdown description when shell execution is available.

## Workflow

### 1. Resolve Target and Platform

Determine the target from the user-provided URL or the current repository.

When working locally:

```bash
git remote get-url origin
git rev-parse --show-toplevel
```

Infer GitHub vs GitLab from the remote. Do not ask for repository information that can be discovered.

For GitLab, determine whether the milestone belongs at project or group scope before drafting.

### 2. Inspect Planning Conventions

Before drafting or mutating:

- list open and closed milestones
- inspect milestone titles, descriptions, dates, states, and membership
- inspect release/tag naming conventions
- inspect iterations or sprint usage
- inspect roadmaps, projects, or planning boards when relevant
- inspect recent releases and high-quality milestones with similar purpose
- search candidate issues, pull requests, merge requests, epics, or work items
- detect whether a matching milestone already exists

Reuse conventions without copying weak historical content.

### 3. Confirm the Milestone Is the Correct Primitive

Read `references/milestone-design.md`.

Use a milestone when the requested work has:

- a coherent delivery outcome
- a bounded set of work
- meaningful completion or exit criteria
- an optional but justified target window or due date

Prefer another primitive when:

- the user needs a single implementation task or bug: use an issue
- the user needs hierarchical initiative scope across multiple delivery boundaries: use an epic or parent work item
- the user needs a recurring timebox: use an iteration or sprint when the platform supports it
- the user needs a shipped artifact, tag, or release record: use a release
- the user needs an ongoing backlog or cross-cutting dashboard: use a project or board

A release milestone may coordinate a release, but the milestone and release are separate objects.

### 4. Choose Scope

For GitHub, milestones are repository-scoped.

For GitLab, choose deliberately:

- **Project milestone:** work belongs to one project.
- **Group milestone:** work spans projects in a group, or group-level planning semantics are required.

Do not promote a GitLab project milestone to a group milestone as an inferred optimization. Promotion can merge same-named project milestones and is irreversible.

### 5. Define Outcome, Scope, and Exit Criteria

Draft the description using `references/milestone-design.md`.

The milestone should make clear:

- outcome and why it matters
- in-scope and out-of-scope boundaries
- completion or exit criteria
- known dependencies and sequencing
- material risks and mitigations
- delivery or release linkage when relevant
- authoritative references

Do not duplicate every issue body inside the milestone description.

### 6. Resolve Dates

Dates must come from one of these sources:

1. explicit user instruction
2. an existing release or launch date
3. a repository or group scheduling rule
4. a clearly established planning cadence

Do not derive a due date from issue count, weight, points, estimates, or the current date.

Platform differences matter:

- GitHub milestones have a native due date but no native start-date field.
- GitLab project and group milestones support start and due dates.

If a requested field has no native representation, do not pretend otherwise. Use a documented repository convention only when one exists.

### 7. Build the Membership Plan

Classify candidate work as:

- committed to this milestone
- explicitly excluded
- deferred to another milestone or iteration
- optional/stretch only when the repository uses that concept

Before reassigning an item, inspect its current milestone. Moving an item changes planning state and must not happen accidentally.

Do not assign loosely related work merely to increase completeness.

### 8. Create or Update the Milestone

Read the platform reference.

Creation and enrichment may require multiple operations:

1. create or update the milestone
2. capture its stable ID/number and URL
3. assign explicitly selected issues, pull requests, merge requests, epics, or work items
4. link the milestone to a release when the platform and requested workflow support it
5. close or reopen the milestone when requested
6. verify the final state

If one optional mutation fails, continue applying independent changes, then report the exact unapplied field or membership change and reason.

### 9. Validate Before Completion

The final milestone must pass these checks:

- title follows repository or group convention
- no conflicting or accidental duplicate milestone exists
- outcome is specific enough to decide whether work belongs
- scope and exclusions do not conflict
- exit criteria are objectively checkable
- dates have a discoverable justification
- platform scope is correct
- no item was moved from another milestone unintentionally
- native membership matches the intended committed work
- lifecycle state is correct
- no unresolved placeholders remain
- the milestone is re-read from the remote after mutation

When available:

```bash
python scripts/validate_milestone.py /path/to/milestone.md
```

Fix validation errors before creating or materially updating the milestone.

## Output Contract

For a draft request, return:

1. proposed title
2. complete Markdown description
3. proposed platform scope
4. proposed start/due dates with their source
5. proposed member work items and exclusions
6. unresolved decisions that cannot be discovered

For a creation or update request, return:

1. milestone reference and URL
2. applied scope, state, and dates
3. assigned issues, pull requests, merge requests, epics, or work items
4. release linkage when applied
5. only remaining unapplied changes, if any

Do not dump discovery logs or every command unless the user asks for them.
