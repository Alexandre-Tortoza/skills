---
name: create-epic
description: Create or update delivery-ready GitHub or GitLab epics and equivalent parent initiatives, fully modeled on the remote. Use when the user asks to open, draft, plan, structure, decompose, or refine an epic, initiative, large feature, program increment, roadmap item, umbrella issue, or multi-issue body of work; when multiple deliverables need a native hierarchy; or when epic metadata, child items, dependencies, dates, projects, milestones, issue fields, health, progress, or estimation must be managed. Inspect repository conventions first, then prefer native parent/sub-issue or epic/work-item relationships and official CLI/API capabilities over Markdown-only tracking.
license: MIT
compatibility: Requires a Git repository. Remote mutations require authenticated GitHub CLI (gh), GitLab CLI (glab), or equivalent API access with sufficient repository or group permissions.
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.2"
---

# Create Epic

Create epics that define a coherent outcome, decompose it into independently trackable deliverables, and represent hierarchy, dependencies, planning metadata, and progress through native remote capabilities.

## Core Rules

1. **Inspect before creating.** Detect the platform, repository/group conventions, issue types, templates, labels, milestones, projects, custom fields, existing epic patterns, hierarchy, and nearby work before deciding the shape of the epic.
2. **Use an epic only for epic-sized work.** An epic should coordinate multiple meaningful deliverables toward one outcome. If the work is implementation-ready as a single issue, use an issue-specific skill instead.
3. **Model the hierarchy natively.** Prefer GitHub parent/sub-issues or GitLab epic/work-item hierarchy. Markdown checklists may summarize children but must not be the source of truth when a native hierarchy exists.
4. **Keep children independently executable.** Child issues should represent verifiable deliverables, not arbitrary slices of the epic description. Do not duplicate implementation detail that belongs in children.
5. **Use directional dependencies correctly.** If A cannot proceed until B completes, A is blocked by B and B is blocking A. Apply native dependency relationships whenever supported.
6. **Use the strongest remote primitive available.** Prefer `gh` or `glab`, then the official API, then a textual fallback only when the platform cannot represent the concept natively.
7. **Do not invent planning taxonomy.** Reuse existing issue types, labels, project fields, milestones, status values, health values, estimation scales, Golden Pounds/Points, target dates, and naming conventions.
8. **Separate outcome from schedule.** Epic scope, effort, child estimates, target dates, and release commitments are different concepts. Never derive a due date from size alone.
9. **Be complete without turning the epic into a design document.** Capture strategic context, scope, deliverables, interfaces, sequencing, risks, rollout, and success criteria. Push issue-level implementation detail into child work items.
10. **Use non-interactive commands.** Never depend on an editor, TTY prompt, or manual web flow when automating creation or enrichment.
11. **Preserve user intent.** Draft-only requests must not mutate the remote. Creation requests should create and enrich the epic, not merely return commands.

## Progressive Disclosure

Read supporting files only when needed:

- Read `references/epic-design.md` whenever composing, decomposing, or materially rewriting an epic.
- Read `references/github.md` for GitHub remotes or when using `gh`.
- Read `references/gitlab.md` for GitLab remotes or when using `glab`.
- Read `references/estimation.md` whenever assigning or proposing effort, weight, points, Golden Pounds/Points, start dates, target dates, due dates, milestones, iterations, health, or progress metadata.
- Run `scripts/validate_epic.py` against the final Markdown body when shell execution is available.

## Workflow

### 1. Resolve Repository, Group, and Platform

Determine the target from the user-provided URL or the current repository.

When local context is available, inspect:

```bash
git remote get-url origin
git rev-parse --show-toplevel
```

For GitLab epics, also resolve the owning group or subgroup. Do not ask for information that can be discovered from the repository, remote URL, or authenticated CLI.

### 2. Inspect Existing Planning Conventions

Before drafting:

- Read issue or work-item templates, contribution guidance, roadmap documents, and planning conventions.
- Inspect organization/group issue types, labels, milestones, projects, project fields, custom issue fields, health/status fields, iterations, and estimation conventions.
- Search open and closed epics, parent issues, and child issues for duplicates or overlapping initiatives.
- Inspect several recent high-quality epics or umbrella items to learn title, decomposition, metadata, and completion conventions.
- Detect the repository language and use it unless the user requests another language.

Historical convention controls vocabulary and remote taxonomy. This skill controls completeness and consistency.

### 3. Confirm Epic Scope

An epic is appropriate when most of these are true:

- it has one coherent outcome but multiple independently deliverable work items,
- delivery spans multiple components, services, teams, releases, or sequencing steps,
- progress must be tracked across child items,
- dependencies or rollout ordering matter,
- the parent item should remain useful after child implementation details change.

Do not create an epic solely because the issue body would be long.

If the requested work is one implementation-sized change, use an issue instead. If it contains several unrelated outcomes, propose separate epics rather than creating an artificial umbrella.

### 4. Discover Existing Work and Boundaries

Search for:

- an existing parent epic or roadmap item,
- candidate child issues that already implement part of the requested scope,
- duplicate epics,
- blockers and downstream dependencies,
- milestones, iterations, releases, or projects already coordinating the work,
- relevant PRs/MRs, incidents, ADRs, product specs, or design documents.

Reuse existing child issues where they match the intended deliverables. Do not create duplicate child issues to make the epic look complete.

### 5. Design the Epic

Read `references/epic-design.md`.

The epic should normally define:

- concise summary and strategic context,
- problem or opportunity,
- desired outcome and measurable success signals,
- goals and non-goals,
- in-scope and out-of-scope boundaries,
- users, systems, teams, or surfaces affected,
- constraints and cross-cutting requirements,
- deliverables or workstreams,
- sequencing and dependency model,
- rollout, migration, compatibility, observability, and operational considerations when relevant,
- risks, assumptions, and mitigations,
- epic-level acceptance criteria,
- completion rules for the parent item,
- references and evidence.

Epic acceptance criteria describe the integrated outcome. Issue-level behavior belongs in child issues.

### 6. Decompose Into Child Work Items

Each child should be:

- independently understandable,
- independently verifiable,
- small enough to be implementation-ready,
- large enough to represent a meaningful deliverable,
- owned by one clear scope boundary,
- linked natively to the epic.

Prefer decomposition by user-visible capability, system boundary, migration phase, or independently testable outcome. Avoid decomposition by arbitrary file, layer, or developer unless repository convention requires it.

For each candidate child, decide whether to:

1. reuse an existing issue,
2. create a new issue,
3. defer it as explicitly out of scope,
4. represent it as a nested epic when it is itself epic-sized and the platform/repository supports that hierarchy.

Use the issue-specific skill for detailed child issue bodies when creating implementation-ready children.

### 7. Establish Relationships and Sequencing

Classify related work as:

- parent epic or initiative,
- child epic,
- child issue,
- blocked by,
- blocking,
- related,
- duplicate candidate,
- milestone/release/iteration/project membership.

Do not encode sequence only as ordered Markdown. Apply native hierarchy and dependency relationships, then summarize the rationale in the epic body when it aids coordination.

### 8. Assign Planning Metadata

Read `references/estimation.md` before assigning:

- priority,
- effort or size,
- weight,
- story points,
- Golden Pounds or Golden Points,
- start date,
- target/due date,
- milestone,
- iteration,
- project status,
- health status,
- owner or assignee.

Do not sum or average child estimates into an epic unless the repository explicitly defines that aggregation. Do not assign a deadline from effort alone.

Prefer inherited or roll-up dates/progress when the platform and repository use them. Use fixed dates only when a real planning commitment exists.

### 9. Create and Enrich the Remote Epic

Read the platform reference.

Creation may require several operations:

1. create the epic or equivalent parent item,
2. capture its reference and URL,
3. set issue/work-item type and planning metadata,
4. attach existing children,
5. create missing children when requested,
6. set parent-child and dependency relationships,
7. add project, milestone, date, estimation, health, or custom-field values,
8. verify the final hierarchy and metadata from the remote.

If the dedicated CLI lacks a supported capability, use the official API through `gh api`, `glab api`, or equivalent authenticated access.

Do not silently drop unsupported metadata. Apply independent fields that can succeed, then report only the remaining unapplied fields and exact reason.

### 10. Validate Before Completion

The epic must pass all of these checks:

- No unresolved template placeholders remain unless uncertainty is intentional and clearly assigned.
- The title names the outcome or initiative rather than a vague activity.
- The epic has one coherent outcome.
- Goals, non-goals, scope, and deliverables do not contradict each other.
- Child items are meaningful deliverables rather than duplicate prose or microtasks.
- Existing relevant issues were reused instead of duplicated.
- Epic acceptance criteria validate the integrated result, not child implementation details.
- Dependencies are directional and consistent with sequencing.
- Metadata uses existing repository/group vocabulary and allowed values.
- Dates are user-supplied, inherited, policy-derived, or otherwise justified.
- Estimation follows repository convention and is not mechanically derived from dates.
- Native hierarchy and dependency relationships are applied where supported.
- The final remote state is re-read and matches the intended hierarchy, fields, and dates.

When available:

```bash
python scripts/validate_epic.py /path/to/epic.md
```

Fix validation errors before creating or updating the epic.

## Output Contract

For a draft request, return:

1. epic title,
2. complete Markdown body,
3. proposed child-item decomposition with reuse/create decisions,
4. proposed remote metadata and relationships,
5. unresolved decisions that cannot be discovered safely.

For a creation request, return:

1. epic reference and URL,
2. applied type, labels, owner/assignees, project, milestone, dates, status/health, and estimation fields,
3. created and reused child items,
4. parent/child and dependency relationships,
5. only remaining unapplied metadata or relationships, if any.

Do not dump discovery logs or every command unless the user asks for them.
