# Epic Planning, Estimation, and Dates

Use this reference whenever assigning or proposing epic-level priority, effort, weight, Golden Pounds/Points, dates, milestones, iterations, project fields, progress, status, or health.

## Principle

The repository's configured remote metadata is the source of truth. An epic is a coordination object, so its planning metadata must not be fabricated from child values unless the repository explicitly defines an aggregation rule.

Never invent a scale, convert between scales without an explicit mapping, or derive a deadline from effort.

## Discovery Order

Inspect in this order:

1. Organization/group-level issue or work-item types and custom fields.
2. Project fields, roadmap fields, status/health fields, and iteration configuration.
3. Native GitLab epic/work-item dates and hierarchy metadata.
4. Existing labels or milestone conventions.
5. Recent comparable epics and repository planning documentation.
6. Child-item metadata only after understanding whether the repository rolls it up.

Prefer structured fields over labels, and labels over free-form body text.

## Epic Estimates vs Child Estimates

Treat epic and child estimates separately.

- Child estimates represent implementation work at the child-item level.
- Epic estimates may represent total program effort, relative size, investment level, or another repository-defined concept.
- Progress may be derived from child completion, but estimate aggregation may follow a different rule or no rule at all.

Do not sum child points, weights, hours, or Golden Pounds into the epic unless repository documentation or a configured automation explicitly defines that behavior.

Do not divide an epic estimate across children mechanically.

## Golden Pounds and Golden Points

Treat `Golden Pounds`, `Golden Points`, `Points`, `Story Points`, `Effort`, `Size`, `Weight`, or similar fields as repository-defined scales.

Rules:

- Match the configured field name exactly.
- Discover whether the field is numeric or select-based.
- Reuse only allowed values.
- Infer meaning from repository documentation and comparable epics, not generic Agile assumptions.
- Never assume Fibonacci, T-shirt sizes, hours, or a `1/2/3/5/8` scale.
- Never convert Golden Pounds/Points to hours unless an explicit mapping exists.
- If the repository estimates only child issues and not epics, leave the epic estimate unset.

## Dates

Distinguish:

- **Start date**, when coordinated work is expected to begin.
- **Target/due date**, a planning target or commitment.
- **Milestone/release dates**, dates belonging to a broader release or planning window.
- **Inherited dates**, dates computed from child items or milestones by the platform.

Assign a fixed date only when it comes from user input, an existing release/milestone policy, a dependency, an external commitment, or another discoverable planning rule.

Prefer inherited/roll-up dates when the platform and team intentionally use them. Do not replace inherited dates with fixed dates merely to populate a field.

## Priority, Status, and Health

These concepts are not interchangeable:

- **Priority** represents ordering or importance according to repository convention.
- **Status** represents workflow state.
- **Health** represents whether delivery is on track or at risk when such a field exists.

Do not infer health only from the percentage of closed child items. Use repository-defined criteria, schedule risk, blockers, and explicit signals.

Do not create a health/status taxonomy that does not already exist.

## Progress

Prefer native child completion or project roll-up progress when available.

Do not maintain a manually typed percentage in the epic body if the platform already computes progress. If the repository uses a custom progress field, follow its configured automation or update rule.

## GitHub

A GitHub epic may be represented as an issue with an organization-defined `Epic` issue type, a parent issue, or another repository-specific type.

Planning metadata can live in:

1. organization issue fields,
2. GitHub Projects fields,
3. milestones,
4. existing labels,
5. body text only as a last resort.

Before assigning values, inspect issue types, organization issue fields, project fields, milestone policy, and comparable parent issues.

If `Epic` is not an existing issue type, do not create a new organization issue type unless the user explicitly requests taxonomy changes.

## GitLab

GitLab epics are work items on current releases. Depending on tier and instance version, epics can expose native start/due dates, labels, assignees, health, milestones, hierarchy, and linked-item relationships.

GitLab can inherit epic start and due dates from child items and milestones. Preserve inherited dates when that is the team's intended planning model.

Do not treat issue weight as automatically valid for epics. Discover which work-item fields are available on the target instance and use only those supported for Epic work items.

## Confidence

When planning metadata requires judgment, determine confidence internally:

- High, stable scope and strong comparable epics.
- Medium, known decomposition with some uncertainty.
- Low, unresolved discovery, external dependency, migration risk, or unclear cross-team ownership.

Do not create a confidence field unless the repository already has one.
