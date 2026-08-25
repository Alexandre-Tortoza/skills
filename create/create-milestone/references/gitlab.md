# GitLab Milestone Capabilities

Use this reference for GitLab repositories and groups.

GitLab supports both project and group milestones. Prefer the dedicated `glab milestone` commands when available and use `glab api` for capabilities or verification not exposed cleanly by the CLI.

GitLab behavior can depend on instance version and subscription tier. Inspect the target instance instead of assuming GitLab.com behavior.

## Authentication and Target Discovery

```bash
glab auth status
git remote get-url origin
glab repo view
```

Inspect the installed milestone commands:

```bash
glab milestone --help
glab milestone list --help
glab milestone create --help
glab milestone edit --help
```

## Choose Project vs Group Scope

Use a project milestone when the committed work belongs to one project.

Use a group milestone when the outcome intentionally spans projects in a group or group-level planning is required.

Group milestones can be assigned to work across projects in the group. GitLab also supports milestone assignment on epics/work items in applicable versions.

Do not choose group scope solely because it appears broader or more powerful.

## Inspect Existing Milestones

Project:

```bash
glab milestone list \
  --project GROUP/PROJECT \
  --output json
```

Group:

```bash
glab milestone list \
  --group GROUP \
  --output json
```

For group hierarchies, inspect ancestor milestones when relevant:

```bash
glab milestone list \
  --group GROUP \
  --include-ancestors \
  --output json
```

Search by title and description before creating.

GitLab enforces milestone title uniqueness within relevant project/group hierarchies. Detect conflicts before mutation instead of relying on the API error.

## Native Milestone Fields

Project and group milestones support:

- title
- description
- start date
- due date
- lifecycle state

GitLab uses active/closed milestone states. CLI edit operations express the transition with `activate` or `close`.

## Create a Project Milestone

```bash
glab milestone create \
  --project GROUP/PROJECT \
  --title "Release 2.0" \
  --description "$(cat /tmp/milestone.md)" \
  --start-date "2026-09-01" \
  --due-date "2026-09-30"
```

Use only justified dates. Omit start or due date when unknown.

For large descriptions or when shell quoting is unsafe, use the API with a JSON or form payload instead of embedding the description in a command substitution.

Project API:

```bash
glab api \
  --method POST \
  projects/PROJECT_ID/milestones \
  -f title='Release 2.0' \
  -f description='...' \
  -f start_date='2026-09-01' \
  -f due_date='2026-09-30'
```

The API uses `YYYY-MM-DD` for start and due dates.

## Create a Group Milestone

```bash
glab milestone create \
  --group GROUP \
  --title "FY27 Platform Launch" \
  --description "$(cat /tmp/milestone.md)" \
  --start-date "2026-10-01" \
  --due-date "2026-12-15"
```

API fallback:

```bash
glab api \
  --method POST \
  groups/GROUP_ID/milestones \
  -f title='FY27 Platform Launch' \
  -f description='...' \
  -f start_date='2026-10-01' \
  -f due_date='2026-12-15'
```

## Update Lifecycle or Dates

Get the stable numeric ID first:

```bash
glab milestone get MILESTONE_ID \
  --project GROUP/PROJECT \
  --output json
```

Edit project milestone:

```bash
glab milestone edit MILESTONE_ID \
  --project GROUP/PROJECT \
  --title "Release 2.0" \
  --due-date "2026-10-07"
```

Close:

```bash
glab milestone edit MILESTONE_ID \
  --project GROUP/PROJECT \
  --state close
```

Reactivate:

```bash
glab milestone edit MILESTONE_ID \
  --project GROUP/PROJECT \
  --state activate
```

Use `--group GROUP` instead of `--project` for group milestones.

## Assign Issues

```bash
glab issue update ISSUE_IID \
  --repo GROUP/PROJECT \
  --milestone "MILESTONE TITLE"
```

Unassign:

```bash
glab issue update ISSUE_IID \
  --repo GROUP/PROJECT \
  --milestone ""
```

Inspect current milestone before reassigning.

## Assign Merge Requests

```bash
glab mr update MR_IID \
  --repo GROUP/PROJECT \
  --milestone "MILESTONE TITLE" \
  --yes
```

Unassign with an empty or zero milestone value when supported by the installed CLI. Use the API if the CLI cannot express the intended clear operation reliably.

## Assign Work Items or Epics

On GitLab versions exposing work-item milestone updates:

```bash
glab work-items update WORK_ITEM_ID \
  --repo GROUP/PROJECT \
  --milestone "MILESTONE TITLE"
```

For group-scoped work items, use the appropriate `--group` target.

Because GitLab's epic/work-item model continues to evolve, inspect the installed `glab work-items` help and target instance API before mutating hierarchy-level items.

## Project Milestone API Verification

Read:

```bash
glab api projects/PROJECT_ID/milestones/MILESTONE_ID
```

List assigned issues:

```bash
glab api \
  "projects/PROJECT_ID/milestones/MILESTONE_ID/issues"
```

List assigned merge requests:

```bash
glab api \
  "projects/PROJECT_ID/milestones/MILESTONE_ID/merge_requests"
```

## Group Milestone API Verification

Read:

```bash
glab api groups/GROUP_ID/milestones/MILESTONE_ID
```

List issues:

```bash
glab api \
  "groups/GROUP_ID/milestones/MILESTONE_ID/issues"
```

List merge requests:

```bash
glab api \
  "groups/GROUP_ID/milestones/MILESTONE_ID/merge_requests"
```

Important: the group-milestone issues endpoint does not include subgroup issues. For exhaustive cross-hierarchy verification, use the broader Issues API filtered by milestone title and inspect the returned projects.

## Promotion to Group Milestone

GitLab can promote a project milestone to a group milestone:

```bash
glab api \
  --method POST \
  projects/PROJECT_ID/milestones/MILESTONE_ID/promote
```

Promotion can merge same-named project milestones across the group and cannot be reversed.

Never promote as an inferred optimization. Use it only when the user explicitly requests promotion or the repository workflow explicitly requires it.

## Releases

GitLab releases can be associated with milestone titles.

For example:

```bash
glab release create v2.0.0 \
  --milestone "Release 2.0" \
  --notes-file /tmp/release-notes.md
```

Release creation can close associated milestones by default in applicable workflows. Use `--no-close-milestone` when closure is not intended.

Do not create a release merely because a milestone is release-oriented unless the user requested the release operation.

## Delete a Milestone

Deletion removes the milestone and its associations.

Use only when explicitly requested:

```bash
glab milestone delete MILESTONE_ID \
  --project GROUP/PROJECT
```

Use `--group GROUP` for a group milestone.

Prefer closing when preserving planning history is appropriate.

## Verification Checklist

After all mutations, confirm:

- project or group scope
- title and description
- start and due dates
- active or closed state
- assigned issues
- assigned merge requests
- assigned epics/work items when applicable
- release association when requested
- no unintended reassignment from another milestone

## Official References

- https://docs.gitlab.com/cli/milestone/
- https://docs.gitlab.com/cli/milestone/create/
- https://docs.gitlab.com/cli/milestone/edit/
- https://docs.gitlab.com/cli/milestone/get/
- https://docs.gitlab.com/cli/milestone/list/
- https://docs.gitlab.com/api/milestones/
- https://docs.gitlab.com/api/group_milestones/
- https://docs.gitlab.com/user/project/milestones/
- https://docs.gitlab.com/cli/issue/update/
- https://docs.gitlab.com/cli/mr/update/
- https://docs.gitlab.com/cli/release/create/
