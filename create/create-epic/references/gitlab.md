# GitLab Epic Capabilities

Use this reference for GitLab repositories and groups. On current GitLab releases, epics are work items. Feature availability can depend on instance version, subscription tier, and permissions, so discover capabilities from the target instance instead of assuming GitLab.com behavior.

Prefer stable dedicated `glab` commands where available. The `glab work-items` command family is currently marked experimental, so use it only after checking the installed version and fall back to the current Work Item API when reliability matters.

## Authentication and Scope Discovery

```bash
glab auth status
git remote get-url origin
glab repo view
```

Resolve the group or subgroup that should own the epic. Epics are group-scoped planning items even when their children live in projects.

Inspect CLI support:

```bash
glab work-items --help
glab work-items create --help
glab work-items update --help
```

## Inspect Before Creating

Inspect:

- group and project planning conventions,
- existing epics/work items,
- labels and milestones,
- roadmap usage,
- parent/child hierarchy,
- linked-item dependency conventions,
- start/due-date inheritance conventions,
- health status and assignee usage,
- project child issues that already cover requested deliverables.

Search for duplicate or overlapping epics before creating a new one.

## Create an Epic Work Item

Current `glab work-items create` can create a group Epic work item:

```bash
glab work-items create \
  --type epic \
  --group GROUP/SUBGROUP \
  --title "TITLE" \
  --description-file /tmp/epic.md
```

This command is experimental. For production automation, verify the installed version and prefer the current Work Item GraphQL API when the CLI does not expose the required fields or relationships.

The legacy Epics REST API is deprecated. Do not build new automation around it when the Work Item API can represent the required capability.

## Update Epic Metadata

The work-item CLI can update fields exposed by the installed version, including title, description, start date, due date, milestone, assignees, and weight where the work-item type supports them:

```bash
glab work-items update WORK_ITEM \
  --group GROUP/SUBGROUP \
  --title "TITLE" \
  --startdate "YYYY-MM-DD" \
  --duedate "YYYY-MM-DD"
```

Do not assume every flag applies to Epic work items. GitLab work-item widgets differ by type. Discover supported fields from the target instance and use the Work Item GraphQL API for capabilities not exposed by `glab`.

## Parent and Child Hierarchy

GitLab child items can represent:

- child epics under an epic,
- issues under an epic,
- tasks under issues.

Use the native hierarchy instead of checklists.

On current GitLab documentation, an epic can have up to 5000 direct child issues/epics. Multi-level epic hierarchy can reach up to seven epic levels and is tier-dependent. Treat those as platform limits, not a target architecture.

When an existing issue already belongs to another epic, reparenting changes its source of truth. Inspect the current parent before moving it.

Quick actions can set a parent on supported work items:

```text
/set_parent <reference-or-URL>
/remove_parent
```

For issues, `/epic` is an alias for `/set_parent` on current GitLab versions.

For automated hierarchy changes, prefer the current Work Item API when the dedicated CLI does not expose parent/child mutations directly.

## Linked Items and Dependencies

GitLab linked items support bidirectional relationships such as:

- relates to,
- blocks,
- is blocked by.

Dependencies can connect epics, issues, tasks, objectives, and key results where supported.

Quick actions include:

```text
/blocks <reference>
/blocked_by <reference>
/relate <reference>
```

Prefer structured API/CLI relationships when automating because they can be verified reliably.

Do not put every child dependency on the epic. Model dependencies on the items that actually block one another, and use epic-level dependencies only for cross-initiative constraints.

## Start and Due Dates

GitLab epics can use fixed or inherited dates.

Inherited dates derive from child epics, child issues, and related milestone dates. They update as children and milestones change.

Prefer inherited dates when the team's roadmap uses roll-up scheduling. Use fixed start/due dates only when there is an explicit planning commitment or repository rule.

Do not derive a due date from estimate or current progress.

## Health, Status, and Assignees

Current GitLab work-item capabilities can expose assignees and health status for epics depending on tier/version. Use the Work Item API for newer epic attributes when legacy APIs do not expose them.

Do not infer health solely from completion percentage. Respect the team's existing health semantics such as on track, at risk, or needs attention when configured.

## Milestones and Child Planning

Milestones can be associated with supported work items and may contribute dates to inherited epic scheduling.

Do not force every child into the epic's milestone if repository convention allows children to span multiple milestones or releases.

Iterations and weight are generally issue-level planning concepts. Do not assume they apply directly to Epic work items. Discover the target instance's widgets and existing conventions.

## API Guidance

For GitLab 18.1 and later, epics are generally available as work items. GitLab's legacy Epics REST API is deprecated and does not receive new features.

Use the Work Item GraphQL API for new epic capabilities such as hierarchy widgets, assignees, health status, and linked items when required.

Inspect the migration guide and GraphQL schema from the target instance before hard-coding mutation names, because the Work Item GraphQL surface has been evolving.

## Verification

After creation and enrichment, verify from the remote:

- title and description,
- Epic work-item type,
- parent and children,
- linked-item blockers and related items,
- labels and assignees,
- start/due dates and whether they are fixed or inherited,
- milestone,
- health/status fields where used,
- all child issue references.

Use `glab work-items` JSON output when sufficient and the Work Item API for hierarchy/widgets that need structured verification.

The remote state is the final source of truth.

## Official References

- https://docs.gitlab.com/user/group/epics/
- https://docs.gitlab.com/user/group/epics/manage_epics/
- https://docs.gitlab.com/user/work_items/
- https://docs.gitlab.com/user/work_items/child_items/
- https://docs.gitlab.com/user/work_items/linked_items/
- https://docs.gitlab.com/cli/work-items/create/
- https://docs.gitlab.com/cli/work-items/update/
- https://docs.gitlab.com/api/graphql/epic_work_items_api_migration_guide/
- https://docs.gitlab.com/user/project/quick_actions/
