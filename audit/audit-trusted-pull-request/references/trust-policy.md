# Trust Policy

Trusted review is an explicit operating mode, not an identity classifier.

## Acceptable trust sources

Use trusted mode only when at least one of these is true:

- the user explicitly states that the PR, contributor, branch, team, bot, or internal workflow is trusted
- repository instructions explicitly define a trusted contributor class or source
- organization policy explicitly defines a repository permission, team membership, signed automation identity, or branch source as sufficient for trusted review

Record the basis in the report.

## Signals that are not sufficient by themselves

Do not infer trust solely from:

- fame or public reputation
- employer or job title
- GitHub stars, followers, sponsors, or social proof
- account age
- contribution count
- prior merged PRs
- collaborator permission
- organization membership
- verified profile badges
- commit signing alone

These signals can support an explicit project policy, but they do not create that policy.

## Private repositories

A private repository is a reasonable environment for trusted review, but privacy alone is not a trust decision. Internal PRs may come from compromised accounts, automation, vendor integrations, or unfamiliar contributors.

Prefer a repository-level policy such as:

```text
Trusted PR sources:
- members of team backend-maintainers
- Dependabot security updates after registry verification
- branches under internal/* created by CI

All other PRs use audit-pull-request.
```

## Trust changes during review

Trust can remain valid while the risk profile escalates. Do not accuse a trusted author of malicious intent merely because a high-risk file changed.

Switch from the fast path to stricter gates when evidence shows that the consequences of a mistake are high or when the assumptions needed for normal execution no longer hold.

If evidence becomes genuinely suspicious, stop relying on trusted-mode execution assumptions and use the full `audit-pull-request` posture.
