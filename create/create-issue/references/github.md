# GitHub Remote Capabilities

Use this reference for GitHub repositories. Prefer `gh` for normal operations and `gh api` for capabilities not exposed directly by a dedicated command.

Capabilities evolve. If a documented command fails because of CLI version drift, inspect `gh <command> --help` and the official API before falling back to prose.

## Authentication and Repository Discovery

```bash
gh auth status
gh repo view --json nameWithOwner,url,defaultBranchRef
```

For GitHub Projects operations, the token may require the `project` scope:

```bash
gh auth refresh -s project
```

## Inspect Before Creating

### Templates and repository guidance

Inspect:

- `.github/ISSUE_TEMPLATE/`
- `.github/ISSUE_TEMPLATE/config.yml`
- `CONTRIBUTING.md`
- planning or architecture docs referenced by recent issues

### Labels

```bash
gh label list --limit 100
```

Reuse labels. Do not create a label merely to satisfy a generic taxonomy.

### Milestones

```bash
gh api "repos/OWNER/REPO/milestones?state=all&per_page=100"
```

### Issue types

Repository issue types can be listed through the REST API:

```bash
gh api repos/OWNER/REPO/issue-types
```

Set a known type with `gh issue create --type` or `gh issue edit --type`.

### Organization issue fields

For organization-owned repositories with issue fields enabled:

```bash
gh api orgs/ORG/issue-fields
```

Issue fields are issue-level structured metadata and can represent priority, effort, dates, points, or repository-specific concepts.

Read current values:

```bash
gh api repos/OWNER/REPO/issues/ISSUE/issue-field-values
```

### Projects

```bash
gh project list --owner OWNER --format json
gh project field-list PROJECT_NUMBER --owner OWNER --format json
gh project item-list PROJECT_NUMBER --owner OWNER --format json
```

Use project fields when the metadata is intentionally scoped to a project. Prefer organization issue fields for metadata that should remain consistent across projects.

### Duplicate and related work search

Use repository issue search before creating:

```bash
gh issue list --state all --limit 100 --search "KEY TERMS"
```

Search title concepts, error strings, affected component names, and user-visible behavior. Review plausible duplicates rather than relying only on exact title matches.

## Create an Issue

`gh issue create` supports native metadata and relationships such as:

- assignees
- labels
- milestone
- project membership
- issue type
- parent issue
- blocked-by dependencies
- blocking dependencies

Example:

```bash
ISSUE_URL="$(
  gh issue create \
    --repo OWNER/REPO \
    --title "TITLE" \
    --body-file /tmp/issue.md \
    --type "Task" \
    --label "backend" \
    --milestone "v2.0" \
    --project "Roadmap" \
    --parent 100 \
    --blocked-by 200,201
)"
```

Use only flags backed by discovered repository values.

Prefer `--body-file` to avoid shell quoting errors in large Markdown bodies.

## Parent and Sub-Issue Relationships

Create a new issue as a child:

```bash
gh issue create --title "TITLE" --body-file issue.md --parent 100
```

Set or change a parent on an existing issue:

```bash
gh issue edit ISSUE --parent 100
```

Add existing children to a parent:

```bash
gh issue edit PARENT --add-sub-issue 101,102
```

Do not simulate hierarchy with task-list links when native parent/sub-issue relationships are available.

## Dependencies

GitHub supports directional issue dependencies.

Create with relationships:

```bash
gh issue create \
  --title "TITLE" \
  --body-file issue.md \
  --blocked-by 200,201 \
  --blocking 300
```

Update later:

```bash
gh issue edit ISSUE --add-blocked-by 200
gh issue edit ISSUE --add-blocking 300
gh issue edit ISSUE --remove-blocked-by 200
gh issue edit ISSUE --remove-blocking 300
```

Verify:

```bash
gh issue view ISSUE --json blockedBy,blocking,parent,subIssues
```

If the installed `gh` version lacks dependency flags but the GitHub host supports dependencies, use the official REST endpoints through `gh api` instead of downgrading to body text.

## Issue Fields

List organization fields and discover IDs/options before setting values:

```bash
gh api orgs/ORG/issue-fields
```

Add or update selected issue field values without replacing unrelated existing values:

```bash
gh api \
  --method POST \
  repos/OWNER/REPO/issues/ISSUE/issue-field-values \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  --input - <<'JSON'
{
  "issue_field_values": [
    {"field_id": 123, "value": "High"},
    {"field_id": 456, "value": 5},
    {"field_id": 789, "value": "2026-09-30"}
  ]
}
JSON
```

Supported values depend on field type. Use exact existing option names for select fields.

Avoid the replace-all `PUT` operation unless the complete intended field set has been read and preserving no other values is deliberate.

## Project Fields

Add the issue to a project during creation with `--project`, or later:

```bash
gh issue edit ISSUE --add-project "Roadmap"
```

Edit a project field by issue URL:

```bash
gh project item-edit PROJECT_NUMBER \
  --owner OWNER \
  --url https://github.com/OWNER/REPO/issues/ISSUE \
  --field "Status" \
  --value "In Progress"
```

Field-specific direct forms are also available for project fields, including date, number, text, single-select, and iteration identifiers. For scripts, inspect field IDs/options with `gh project field-list --format json`.

A non-draft item generally requires one field update per invocation.

## Due Dates and Estimates

Do not assume a universal GitHub issue due-date or estimate field name.

Prefer, in order:

1. organization issue field such as `Target date`, `Due date`, `Points`, `Effort`, or a repository-specific field
2. project-scoped date/number/select field
3. milestone due date when the deadline belongs to the whole milestone
4. existing repository label convention

Never create a new organization field or Project field unless the user explicitly requests taxonomy/configuration changes.

## Assignees

Assign only when the user names the owner, the repository convention makes ownership unambiguous, or an existing workflow explicitly requires self-assignment.

```bash
gh issue edit ISSUE --add-assignee USER
```

Do not infer the assignee from the author of a related issue or commit.

## Verification

After all mutations, re-read the issue:

```bash
gh issue view ISSUE --json \
  title,body,assignees,labels,milestone,issueType,parent,subIssues,blockedBy,blocking,projectItems,url
```

Also verify organization issue fields when used:

```bash
gh api repos/OWNER/REPO/issues/ISSUE/issue-field-values
```

Verify project fields with `gh project item-list` or `gh project item-edit` JSON output where appropriate.

The remote state, not command success text, is the final source of truth.

## Official References

- https://cli.github.com/manual/gh_issue_create
- https://cli.github.com/manual/gh_issue_edit
- https://cli.github.com/manual/gh_issue_view
- https://cli.github.com/manual/gh_project
- https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-issue-dependencies
- https://docs.github.com/en/rest/issues/issue-dependencies
- https://docs.github.com/en/rest/repos/issue-types
- https://docs.github.com/en/rest/orgs/issue-fields
- https://docs.github.com/en/rest/issues/issue-field-values
