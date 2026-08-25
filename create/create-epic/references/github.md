# GitHub Epic Capabilities

Use this reference for GitHub repositories. GitHub does not require a universal `Epic` object: an epic may be an issue with an organization-defined Epic issue type, a parent issue with sub-issues, or another repository-specific planning convention.

Prefer `gh` for normal operations and `gh api` for supported capabilities not exposed by a dedicated command. If command syntax differs, inspect `gh <command> --help` before falling back to prose.

## Authentication and Repository Discovery

```bash
gh auth status
gh repo view --json nameWithOwner,url,defaultBranchRef
```

GitHub Projects operations may require the `project` scope:

```bash
gh auth refresh -s project
```

## Inspect Before Creating

Inspect repository guidance and templates:

- `.github/ISSUE_TEMPLATE/`
- `.github/ISSUE_TEMPLATE/config.yml`
- `CONTRIBUTING.md`
- roadmap/planning docs referenced by recent parent issues

Inspect existing metadata:

```bash
gh label list --limit 100
gh api "repos/OWNER/REPO/milestones?state=all&per_page=100"
gh issue list --state all --limit 100 --search "KEY TERMS"
```

For organization issue types:

```bash
gh api orgs/ORG/issue-types
```

For organization issue fields when enabled:

```bash
gh api orgs/ORG/issue-fields
```

For Projects:

```bash
gh project list --owner OWNER --format json
gh project field-list PROJECT_NUMBER --owner OWNER --format json
gh project item-list PROJECT_NUMBER --owner OWNER --format json
```

Do not create an `Epic` issue type, label, or project field merely because this skill is creating an epic. Reuse existing taxonomy.

## Choose the GitHub Epic Representation

Use this order:

1. Existing organization issue type such as `Epic` or the repository's equivalent.
2. Existing parent-issue convention using native sub-issues.
3. Existing project/roadmap convention for parent items.
4. A normal parent issue with explicit scope, only when no stronger repository-specific representation exists.

If the organization has no Epic type, creating a parent issue is usually better than inventing taxonomy.

## Create the Parent Item

When an existing Epic issue type is available:

```bash
EPIC_URL="$(
  gh issue create \
    --repo OWNER/REPO \
    --title "TITLE" \
    --body-file /tmp/epic.md \
    --type "Epic" \
    --project "Roadmap"
)"
```

When no Epic type exists, omit `--type` or use the exact existing repository type that represents this class of work.

`gh issue create` also supports native parent and dependency flags. Use only relationships that are already known at creation time.

## Sub-Issue Hierarchy

GitHub sub-issues are the native hierarchy primitive for decomposing a parent item.

Create a child under the epic:

```bash
gh issue create \
  --repo OWNER/REPO \
  --title "CHILD TITLE" \
  --body-file /tmp/child.md \
  --parent EPIC_NUMBER
```

Attach existing issues:

```bash
gh issue edit EPIC_NUMBER --add-sub-issue 101,102,103
```

Set or change a parent from the child side:

```bash
gh issue edit CHILD_NUMBER --parent EPIC_NUMBER
```

Remove stale relationships explicitly:

```bash
gh issue edit EPIC_NUMBER --remove-sub-issue 103
gh issue edit CHILD_NUMBER --remove-parent
```

Current GitHub documentation allows up to 100 direct sub-issues per parent and up to eight nested levels. Treat these as platform limits, not a target design. If the epic approaches them, reconsider decomposition before creating an excessively broad hierarchy.

Do not simulate hierarchy only with task lists when sub-issues are available.

## Dependencies

GitHub supports directional issue dependencies.

Create with dependencies:

```bash
gh issue create \
  --title "TITLE" \
  --body-file /tmp/epic.md \
  --blocked-by 200,201 \
  --blocking 300
```

Update dependencies:

```bash
gh issue edit EPIC_NUMBER --add-blocked-by 200
gh issue edit EPIC_NUMBER --add-blocking 300
gh issue edit EPIC_NUMBER --remove-blocked-by 200
gh issue edit EPIC_NUMBER --remove-blocking 300
```

Dependencies can also exist between child issues. Model the real dependency graph rather than putting every dependency on the parent epic.

If the installed `gh` lacks these flags but the host supports dependencies, use the official REST endpoints with `gh api`.

## Projects and Progress

Add the epic to a project during creation with `--project` or later:

```bash
gh issue edit EPIC_NUMBER --add-project "Roadmap"
```

Parent/sub-issue progress is available in GitHub Projects. Prefer native progress or project rollups over a manually maintained percentage in the issue body.

Edit project fields through discovered existing fields:

```bash
gh project item-edit PROJECT_NUMBER \
  --owner OWNER \
  --url https://github.com/OWNER/REPO/issues/EPIC_NUMBER \
  --field "Status" \
  --value "In Progress"
```

Use exact field names/options from `gh project field-list`. One field update per invocation may be required for non-draft items.

## Organization Issue Fields

Read current values:

```bash
gh api repos/OWNER/REPO/issues/EPIC_NUMBER/issue-field-values
```

Add or update selected values without replacing unrelated fields:

```bash
gh api \
  --method POST \
  repos/OWNER/REPO/issues/EPIC_NUMBER/issue-field-values \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  --input - <<'JSON'
{
  "issue_field_values": [
    {"field_id": 123, "value": "High"},
    {"field_id": 456, "value": "2026-09-30"}
  ]
}
JSON
```

Use exact configured values. Avoid replace-all operations unless the complete intended field set has been read and replacement is deliberate.

## Dates, Estimates, and Milestones

GitHub has no single universal epic due-date or estimate field.

Prefer, in order:

1. organization issue field such as Target date, Start date, Effort, Golden Pounds, or repository-specific equivalent,
2. project-scoped date/number/select field,
3. milestone when the date belongs to a release or phase,
4. existing label convention.

Do not infer an epic estimate by summing child estimates unless repository automation or documentation defines that rule.

Do not invent a target date from size.

## Verification

After all mutations, re-read the parent:

```bash
gh issue view EPIC_NUMBER --json \
  title,body,assignees,labels,milestone,issueType,parent,subIssues,subIssuesSummary,blockedBy,blocking,projectItems,url
```

Verify each reused/created child has the intended parent and dependency relationships. Verify organization issue fields and Project fields separately when used.

The remote state, not command output, is the final source of truth.

## Official References

- https://cli.github.com/manual/gh_issue_create
- https://cli.github.com/manual/gh_issue_edit
- https://cli.github.com/manual/gh_issue_view
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-sub-issues
- https://docs.github.com/en/rest/issues/sub-issues
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-issue-dependencies
- https://docs.github.com/en/rest/issues/issue-dependencies
- https://docs.github.com/en/rest/orgs/issue-types
- https://docs.github.com/en/rest/orgs/issue-fields
- https://docs.github.com/en/rest/issues/issue-field-values
