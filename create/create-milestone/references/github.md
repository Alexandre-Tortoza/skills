# GitHub Milestone Capabilities

Use this reference for GitHub repositories.

GitHub milestones are repository-scoped and can group issues and pull requests. Prefer `gh` for issue and pull-request membership operations and `gh api` for milestone CRUD when the installed GitHub CLI has no dedicated milestone command.

Capabilities evolve. Inspect `gh help`, `gh <command> --help`, and the official API when the installed CLI differs from this reference.

## Authentication and Repository Discovery

```bash
gh auth status
gh repo view --json nameWithOwner,url,defaultBranchRef
```

Milestone writes require repository permissions that allow Issues or Pull requests write access.

## Inspect Existing Milestones

List open and closed milestones before creating a new one:

```bash
gh api --paginate \
  "repos/OWNER/REPO/milestones?state=all&per_page=100"
```

Inspect:

- title
- number
- state
- description
- due date
- open and closed issue counts
- creation and update timestamps

Search issues and pull requests that may already be planned for the same outcome.

```bash
gh issue list --repo OWNER/REPO --state all --limit 100 --search "KEY TERMS"
gh pr list --repo OWNER/REPO --state all --limit 100 --search "KEY TERMS"
```

## Native Milestone Fields

GitHub milestone REST objects support:

- `title`
- `state`: `open` or `closed`
- `description`
- `due_on`

GitHub milestones do not provide a native start-date field.

Do not fabricate milestone-level owners, labels, estimates, start dates, or project fields. Those concepts may exist on issues, pull requests, or Projects, but they are not milestone fields.

## Create a Milestone

Prepare a JSON payload so large Markdown descriptions and timestamps are not damaged by shell quoting.

Example payload:

```json
{
  "title": "v2.0",
  "description": "## Outcome\n\nShip the v2 API...",
  "due_on": "2026-09-30T23:59:59Z"
}
```

Create:

```bash
gh api \
  --method POST \
  repos/OWNER/REPO/milestones \
  --input /tmp/milestone.json
```

Omit `due_on` entirely when no justified due date exists.

The REST API requires `due_on` as an ISO 8601 UTC timestamp.

When the user provides only a calendar date, preserve the repository's established timezone/date convention. Do not invent an arbitrary time if it could change the intended rendered date.

## Update a Milestone

Use the milestone number, not a guessed title:

```bash
gh api \
  --method PATCH \
  repos/OWNER/REPO/milestones/MILESTONE_NUMBER \
  --input /tmp/milestone-patch.json
```

Only include fields that should change.

Close:

```bash
gh api \
  --method PATCH \
  repos/OWNER/REPO/milestones/MILESTONE_NUMBER \
  -f state=closed
```

Reopen:

```bash
gh api \
  --method PATCH \
  repos/OWNER/REPO/milestones/MILESTONE_NUMBER \
  -f state=open
```

## Delete a Milestone

Deletion removes the milestone object and its associations. Do not delete merely because a milestone is complete.

Delete only when explicitly requested:

```bash
gh api \
  --method DELETE \
  repos/OWNER/REPO/milestones/MILESTONE_NUMBER
```

Prefer closing when historical planning context should remain.

## Assign Issues

Use the dedicated CLI when the milestone title is unambiguous:

```bash
gh issue edit ISSUE_NUMBER \
  --repo OWNER/REPO \
  --milestone "MILESTONE TITLE"
```

Remove membership:

```bash
gh issue edit ISSUE_NUMBER \
  --repo OWNER/REPO \
  --remove-milestone
```

Before reassigning, inspect the existing milestone:

```bash
gh issue view ISSUE_NUMBER \
  --repo OWNER/REPO \
  --json number,title,milestone,url
```

## Assign Pull Requests

```bash
gh pr edit PR_NUMBER \
  --repo OWNER/REPO \
  --milestone "MILESTONE TITLE"
```

Remove membership:

```bash
gh pr edit PR_NUMBER \
  --repo OWNER/REPO \
  --remove-milestone
```

Inspect first:

```bash
gh pr view PR_NUMBER \
  --repo OWNER/REPO \
  --json number,title,milestone,url
```

## Exact Assignment by Milestone Number

If title-based assignment is ambiguous, use the REST issue endpoint with the milestone number.

GitHub models pull requests as issues for shared issue metadata, so the same milestone field can be set through the Issues API.

Example patch payload:

```json
{
  "milestone": 12
}
```

Apply to an issue or pull request number:

```bash
gh api \
  --method PATCH \
  repos/OWNER/REPO/issues/ITEM_NUMBER \
  --input /tmp/item-milestone.json
```

Use `null` for the API milestone field only when intentionally clearing an existing assignment.

## Verify Membership

Read the milestone after mutation:

```bash
gh api repos/OWNER/REPO/milestones/MILESTONE_NUMBER
```

List all issue-shaped items associated with it:

```bash
gh api --paginate \
  "repos/OWNER/REPO/issues?milestone=MILESTONE_NUMBER&state=all&per_page=100"
```

The Issues API response can contain both issues and pull requests. A pull request entry contains a `pull_request` object.

Also verify individual important items with `gh issue view` or `gh pr view`.

Check that:

- every intended item is assigned
- no unintended item was moved
- the open/closed counts are plausible
- the due date and state match the plan

## Releases

GitHub releases and milestones are separate objects.

Do not claim that creating a milestone creates a release or tag.

If the repository convention links releases and milestones through description text, Projects, automation, or release notes, preserve that existing convention without inventing a native relationship that GitHub does not provide.

## Failure Handling

If milestone creation succeeds but one issue or pull-request assignment fails:

1. continue assigning independent items
2. re-read the milestone and successful assignments
3. report the exact failed item and reason
4. do not roll back successful assignments unless the user requested atomic behavior

## Official References

- https://docs.github.com/en/rest/issues/milestones
- https://cli.github.com/manual/gh
- https://cli.github.com/manual/gh_issue_edit
- https://cli.github.com/manual/gh_issue_view
- https://cli.github.com/manual/gh_pr_edit
- https://cli.github.com/manual/gh_pr_view
