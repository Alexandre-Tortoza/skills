# GitLab Remote Capabilities

Use this reference for GitLab repositories. Prefer `glab` for normal issue operations and `glab api` for supported capabilities not exposed by a dedicated command.

GitLab features can depend on instance version and subscription tier. Discover capabilities from the target instance instead of assuming GitLab.com behavior.

## Authentication and Repository Discovery

```bash
glab auth status
git remote get-url origin
```

Use `glab <command> --help` when the installed CLI version differs from this reference.

## Inspect Before Creating

Inspect:

- `.gitlab/issue_templates/`
- `CONTRIBUTING.md`
- existing labels and milestones
- iterations or boards used by the project/group
- nearby open and closed issues
- work-item hierarchy and linked items
- weight and time-estimate conventions

Search for duplicate or related work before creating a new issue.

## Create an Issue

Current `glab issue create` supports structured metadata including:

- assignees
- confidentiality
- due date
- epic association where supported
- labels
- linked issues plus link type
- milestone
- time estimate
- time spent
- weight

Example:

```bash
glab issue create \
  --repo GROUP/PROJECT \
  --title "TITLE" \
  --description-file /tmp/issue.md \
  --label "backend" \
  --milestone "v2.0" \
  --due-date "2026-09-30" \
  --time-estimate "2d" \
  --weight 5 \
  --linked-issues 200,201 \
  --link-type "is_blocked_by" \
  --yes
```

Use only values supported by the target instance and repository convention.

Prefer `--description-file` for large Markdown bodies.

## Due Date

GitLab supports a native issue due date.

Create with:

```bash
glab issue create --due-date "YYYY-MM-DD"
```

Update with:

```bash
glab issue update ISSUE --due-date "YYYY-MM-DD"
```

A due date must come from user input or a discoverable scheduling rule. Do not derive it from issue size.

## Weight

GitLab supports issue weight on applicable tiers/configurations.

Create with:

```bash
glab issue create --weight 5
```

Update with:

```bash
glab issue update ISSUE --weight 5
```

The numeric meaning is repository-specific. Read `references/estimation.md` before assigning it.

## Time Estimate

GitLab has native time tracking.

Create with:

```bash
glab issue create --time-estimate "1d 4h"
```

If direct CLI support is unavailable on the installed version, use the Issues API:

```bash
glab api \
  --method POST \
  projects/PROJECT_ID/issues/ISSUE_IID/time_estimate \
  -f duration='1d 4h'
```

Do not equate time estimate with weight.

## Linked Issues and Dependencies

GitLab linked issues are bidirectional and can express:

- `relates_to`
- `blocks`
- `is_blocked_by`

`glab issue create` can create links using `--linked-issues` and `--link-type`.

For more control, use the Issue Links API:

```bash
glab api \
  --method POST \
  projects/PROJECT_ID/issues/ISSUE_IID/links \
  -f target_project_id='TARGET_PROJECT_ID' \
  -f target_issue_iid='TARGET_ISSUE_IID' \
  -f link_type='blocks'
```

Blocking relationships can be tier-dependent. If the target instance does not support `blocks` or `is_blocked_by`, do not pretend a generic relation is equivalent. Apply the strongest supported relation and clearly preserve the dependency in the issue body only when necessary.

GitLab quick actions can also express relationships on supported work items:

```text
/blocks #123
/blocked_by #456
/relate #789
```

Prefer CLI/API relations when automating because they are easier to verify.

## Parent and Child Work Items

GitLab is progressively unifying issues, tasks, epics, and other planning entities as work items. Use the target instance's native parent/child work-item capability when available.

Do not emulate parent/child hierarchy only with checklist links when native hierarchy is available.

Because CLI coverage can vary by GitLab version, inspect:

```bash
glab work-items --help
glab work-items update --help
```

Use `glab api` for work-item hierarchy when the dedicated CLI does not expose the required operation.

## Milestones and Iterations

Use milestones for release or phase grouping when the repository already does so.

Project/group milestones can carry start and due dates. Do not create a new milestone solely to give one issue a due date.

Use existing iterations when the team plans by iteration. Do not assign an arbitrary iteration based only on the current date.

## Confidentiality

Use confidential issues when the user requests it or the content requires restricted visibility under repository policy.

```bash
glab issue create --confidential
glab issue update ISSUE --confidential
```

Do not place unnecessary secrets, credentials, personal data, or exploit details in an issue even when it is confidential.

## Quick Actions

GitLab quick actions can represent metadata in the description or comments. Useful actions include concepts such as:

- due date
- estimate
- parent/epic relationship
- relate
- blocks
- blocked by
- health status on supported tiers

Prefer dedicated CLI flags or API fields when available. Use quick actions when they are the target instance's supported automation surface.

## Verification

After creation and enrichment, inspect the issue and its links from the remote.

Use `glab issue view` where sufficient, and the API for structured verification:

```bash
glab api projects/PROJECT_ID/issues/ISSUE_IID
glab api projects/PROJECT_ID/issues/ISSUE_IID/links
```

Confirm:

- title and description
- labels and assignees
- milestone/iteration
- due date
- weight
- time estimate
- parent/child relationship
- related/blocked-by/blocking relationships
- confidentiality when applicable

The remote state is the final source of truth.

## Official References

- https://docs.gitlab.com/cli/issue/create/
- https://docs.gitlab.com/cli/issue/update/
- https://docs.gitlab.com/api/issues/
- https://docs.gitlab.com/api/issue_links/
- https://docs.gitlab.com/user/project/issues/related_issues/
- https://docs.gitlab.com/user/project/issues/due_dates/
- https://docs.gitlab.com/user/project/quick_actions/
