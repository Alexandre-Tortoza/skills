---
name: create-issue
description: Create or update implementation-ready GitHub or GitLab issues and fully enrich them on the remote. Use when the user asks to open, draft, plan, file, split, or refine an issue, bug, task, feature, or work item; when converting requirements, TODOs, incidents, code findings, or PR feedback into trackable work; or when issue metadata and relationships must be managed. Inspect repository conventions first, then use native remote capabilities such as issue types, assignees, labels, milestones, projects, custom issue fields, parent/sub-issues, blocked-by/blocking links, due dates, weights, estimates, iterations, and related items. Prefer gh/glab and official APIs over text-only approximations.
license: MIT
compatibility: Requires a Git repository. Remote mutations require authenticated GitHub CLI (gh), GitLab CLI (glab), or equivalent API access with sufficient repository permissions.
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.2"
---

# Create Issue

Create issues that are self-contained, implementation-ready, and fully represented by the remote platform rather than only by Markdown.

## Core Rules

1. **Inspect before creating.** Detect the remote platform, repository conventions, templates, labels, milestones, issue types, issue fields, project fields, iterations, and nearby issues before choosing metadata.
2. **Use native relationships.** Prefer parent/sub-issue, blocked-by, blocking, related-item, milestone, project, and issue-field relationships over prose-only references.
3. **Use the strongest remote primitive available.** Prefer the platform CLI, then the official API, then a textual fallback only when the remote cannot represent the concept natively.
4. **Do not invent repository taxonomy.** Reuse existing labels, types, fields, project options, estimation scales, milestones, and naming conventions. Do not create new taxonomy unless the user explicitly asks for it or the repository clearly requires it.
5. **Make the issue executable.** A developer who did not participate in the conversation should be able to understand the problem, scope, constraints, expected behavior, validation, and completion criteria from the issue alone.
6. **Be complete without filler.** Include every section that affects implementation or verification. Omit sections that are truly irrelevant, but never hide uncertainty. State `N/A` with a reason when omission could be ambiguous.
7. **Use non-interactive commands.** Never depend on editor prompts or TTY input when creating or enriching an issue.
8. **Preserve user intent.** If the user requests a draft only, do not mutate the remote. If the user requests creation, create and enrich the issue instead of only returning a command.

## Progressive Disclosure

Read supporting files only when needed:

- Read `references/issue-template.md` whenever composing or materially rewriting an issue body.
- Read `references/github.md` for a GitHub remote or when using `gh`.
- Read `references/gitlab.md` for a GitLab remote or when using `glab`.
- Read `references/estimation.md` whenever assigning or proposing effort, weight, points, due dates, target dates, time estimates, or scheduling fields.
- Run `scripts/validate_issue.py` against the final Markdown body when shell execution is available.

## Workflow

### 1. Resolve Repository and Platform

Determine the target from the user-provided URL or the current repository.

When working locally, inspect:

```bash
git remote get-url origin
git rev-parse --show-toplevel
```

Infer GitHub vs GitLab from the remote. Do not ask for information that can be discovered from the repository or authenticated CLI.

### 2. Inspect Repository Conventions

Before drafting:

- Read issue templates and contribution guidance.
- Inspect existing labels, milestones, issue types, organization issue fields, Projects or GitLab planning fields, and iteration conventions.
- Search existing open and closed issues for duplicates or related work.
- Inspect a few recent high-quality issues of the same type to learn title, body, acceptance-criteria, estimation, and metadata conventions.
- Detect the repository language and use it unless the user requests another language.

Do not copy weak historical issues merely because they exist. Repository convention controls taxonomy and syntax; this skill controls completeness.

### 3. Classify the Work

Choose the smallest correct work-item shape:

- Bug, unexpected behavior or regression.
- Feature, new user-visible capability.
- Task, implementation or operational work.
- Incident, production reliability or security event when the platform supports it.
- Child/sub-issue, independently deliverable part of a larger issue.
- Parent issue, only when the requested work is explicitly an issue-sized umbrella. Use an epic-specific skill for genuinely epic scope.

If the requested issue contains multiple independently releasable deliverables, split it only when the user asks for decomposition or the repository convention clearly requires child issues. Preserve native parent-child relationships.

### 4. Establish Relationships Before Writing

Search for and classify relevant work as:

- parent
- sub-issue
- blocked by
- blocking
- related
- duplicate candidate
- milestone or iteration membership
- linked pull request or merge request context

Directional relationships must be correct. If issue A cannot proceed until B is complete, A is **blocked by** B and B is **blocking** A.

Prefer native relationship fields. In the body, explain dependency rationale only when useful; do not use prose as the source of truth when a native relationship exists.

### 5. Draft the Issue

Use `references/issue-template.md`.

The issue must normally include:

- concise summary
- problem and context
- goal and non-goals
- user or business impact when relevant
- in-scope and out-of-scope boundaries
- functional and non-functional requirements
- technical context and affected surfaces
- implementation notes or plan when known
- test and validation plan
- acceptance criteria that are observable and verifiable
- rollout, migration, compatibility, and observability considerations when relevant
- dependencies and relationship rationale
- risks and mitigations
- definition of done
- references and evidence

For bugs, include reproduction steps, expected behavior, actual behavior, environment, evidence, regression range when known, and test coverage required to prevent recurrence.

Do not turn implementation guesses into requirements. Separate confirmed requirements from proposed implementation notes.

### 6. Assign Planning Metadata

Use repository-native metadata and exact existing vocabulary.

Read `references/estimation.md` before assigning:

- priority
- effort
- weight
- story points
- Golden Pounds or Golden Points
- time estimate
- target or due date
- iteration or sprint
- milestone

Never invent a mapping between relative size and elapsed time. Never derive a due date from effort alone.

### 7. Create and Enrich the Remote Issue

Read the platform reference and prefer the authenticated CLI.

Creation and enrichment may require more than one operation. It is acceptable to:

1. create the issue with the metadata supported directly by the create command,
2. capture its number and URL,
3. apply organization issue fields or project fields,
4. add or verify relationships,
5. verify the resulting remote state.

If a CLI lacks a native flag for a supported platform feature, use the official API through `gh api`, `glab api`, or equivalent authenticated API access.

Do not silently drop requested metadata. If one field cannot be applied, continue applying independent fields, then report the exact unapplied field and reason.

### 8. Validate Before Completion

The final issue must pass all of these checks:

- No unresolved placeholders such as `TBD`, `[fill]`, or template instructions remain unless the uncertainty itself is intentional and clearly assigned.
- The title describes the outcome or problem, not the implementation activity alone.
- Scope and non-goals do not conflict.
- Acceptance criteria are externally observable or objectively testable.
- Test coverage maps to the acceptance criteria.
- Dependencies are directional and point to the correct issues.
- Metadata uses existing repository values.
- Estimation follows the repository's scale.
- Dates are justified by user input, milestone/iteration policy, or an explicit repository rule.
- Native remote relationships and fields are applied when supported.
- The created issue is re-read from the remote to verify the final state.

When available:

```bash
python scripts/validate_issue.py /path/to/issue.md
```

Fix validation errors before creating the issue.

## Output Contract

For a draft request, return:

1. title
2. complete Markdown body
3. proposed remote metadata and relationships
4. any unresolved decisions that cannot be discovered

For a creation request, return:

1. issue reference and URL
2. applied type, labels, assignees, milestone/iteration/project
3. applied estimation and date fields
4. parent/sub-issue and dependency relationships
5. only the remaining unapplied metadata, if any

Do not dump discovery logs or every command unless the user asks for them.
