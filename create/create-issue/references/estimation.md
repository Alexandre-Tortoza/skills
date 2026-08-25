# Estimation and Planning Metadata

Use this reference whenever assigning effort, weight, points, due dates, target dates, time estimates, iterations, or planning fields.

## Principle

The repository's remote metadata is the source of truth. Estimation vocabulary is repository-specific.

Never invent a new scale, translate between scales without an explicit mapping, or guess a due date from effort.

## Discovery Order

Before estimating, inspect in this order:

1. Organization-level issue fields and their allowed values.
2. Project fields and iteration configuration.
3. Native GitLab issue fields such as weight, due date, and time estimate.
4. Existing labels used for estimation or priority.
5. Repository documentation, contribution guides, planning docs, or recent comparable issues.

Prefer existing structured fields over labels, and labels over free-form body text.

## Golden Pounds and Golden Points

Treat names such as `Golden Pounds`, `Golden Points`, `Points`, `Story Points`, `Effort`, `Size`, or `Weight` as repository-defined scales.

Rules:

- Match the field name exactly as configured on the remote.
- Discover whether the field is numeric or single-select before assigning it.
- For a single-select field, use an existing option name exactly.
- For a numeric field, use a numeric value allowed by repository convention.
- Infer scale meaning from repository documentation and comparable completed issues, not from generic Agile assumptions.
- Never silently assume Fibonacci, T-shirt sizes, hours, or a `1/2/3/5/8` scale.
- Never convert Golden Pounds/Points to hours unless the repository explicitly defines that mapping.
- If the field exists but its scale cannot be inferred safely, leave it unset and report a proposed value only if the user asked for an estimate.

## Estimation Method

Estimate after the issue scope and acceptance criteria are stable.

Use comparable work from the same repository when possible. Consider:

- implementation breadth across components or services
- uncertainty and discovery work
- data migrations or backfills
- external integrations
- test surface
- rollout and observability work
- security, compatibility, and accessibility constraints
- coordination or sequencing dependencies

Do not inflate size merely because the issue body is detailed.

## Relative Size vs Time Estimate

Keep these independent:

- **Relative size / weight / points** measures comparative complexity or effort according to repository convention.
- **Time estimate** measures expected working time when the platform and team use that concept.
- **Due/target date** is a scheduling commitment or planning target.

A relative estimate must not be mechanically converted into elapsed time.

## Dates

Assign a due or target date only when at least one is true:

- the user supplied the date
- the issue belongs to a milestone or iteration with an explicit date policy
- an existing project automation or repository convention derives the date
- a dependency or release requirement establishes the deadline

Do not choose a date simply because an issue appears small.

When a deadline is known, use ISO `YYYY-MM-DD` in API/CLI operations unless the platform command documents another accepted format.

## GitHub

GitHub can expose both organization-level **issue fields** and project-scoped custom fields.

Preferred order:

1. Organization issue field, because the value belongs to the issue across projects.
2. Project field, when the concept is intentionally project-specific.
3. Existing label convention.
4. Body text only as a last resort.

Common organization issue fields include Priority, Effort, Start date, Target date, or repository-specific custom fields. Field types can include single-select, text, number, date, and multi-select depending on the GitHub feature/API surface.

Do not assume `gh issue create` exposes every field as a flag. Use `gh api` for issue field values when needed.

Example discovery:

```bash
gh api repos/OWNER/REPO/issue-types
gh api orgs/ORG/issue-fields
gh api repos/OWNER/REPO/issues/ISSUE/issue-field-values
```

Example additive field update:

```bash
gh api \
  --method POST \
  repos/OWNER/REPO/issues/ISSUE/issue-field-values \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  --input - <<'JSON'
{
  "issue_field_values": [
    {"field_id": 123, "value": 5},
    {"field_id": 456, "value": "2026-09-30"}
  ]
}
JSON
```

Use `POST` when adding/updating selected fields without replacing unrelated values. Avoid `PUT` unless replacing the complete field-value set is intentional.

For project-specific fields, use `gh project field-list`, `gh project item-list`, and `gh project item-edit`.

## GitLab

GitLab issues support native scheduling and estimation primitives, subject to tier and instance configuration.

Prefer:

- `due_date` for issue due dates
- `weight` for repository-defined relative size when enabled
- time estimate for time-tracking workflows
- milestone and iteration for planning windows
- native linked-item relationships for dependencies

`glab issue create` can set due date, weight, and time estimate on supported instances. `glab issue update` can update due date and weight.

Do not use both weight and a custom label to represent the same estimate unless the repository convention intentionally mirrors them.

## Confidence

When the estimate requires judgment, determine confidence internally:

- High, close analogs and stable scope.
- Medium, known implementation with some uncertainty.
- Low, discovery, external dependency, unclear data migration, or novel architecture.

Do not store a confidence field unless the repository already uses one. If the user asks for reasoning, explain the drivers briefly.
