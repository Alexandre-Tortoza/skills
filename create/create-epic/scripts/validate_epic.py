#!/usr/bin/env python3
"""Validate the structural completeness of a Markdown epic body.

Usage:
    python scripts/validate_epic.py path/to/epic.md
    cat epic.md | python scripts/validate_epic.py -

Exit codes:
    0: valid
    1: validation errors
    2: usage/read error
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

CORE_HEADINGS = (
    "Summary",
    "Context",
    "Outcome",
    "Success Signals",
    "Goals",
    "Non-goals",
    "Scope",
    "Deliverables",
    "Sequencing and Dependencies",
    "Epic Acceptance Criteria",
    "Risks and Mitigations",
    "Definition of Done",
    "References",
)

PLACEHOLDER_PATTERNS = (
    r"\[One short paragraph",
    r"\[What user",
    r"\[How the relevant system",
    r"\[The durable result",
    r"\[Observable product",
    r"\[Outcome or capability",
    r"\[Adjacent capability",
    r"\[Capability, system",
    r"\[Outcome-oriented name",
    r"\[Native blocker",
    r"\[Cross-cutting failure mode",
    r"\[Product specs",
    r"\bTBD\b",
    r"\bTODO\b",
    r"\[fill(?: me)?\]",
)

CHECKBOX_RE = re.compile(r"(?m)^\s*-\s*\[(?: |x|X)\]\s+.+$")
HEADING_RE = re.compile(r"(?m)^#{2,6}\s+(.+?)\s*$")
BULLET_RE = re.compile(r"(?m)^\s*-\s+(?!\[[ xX]\]).+$")


def read_input(path: str) -> str:
    if path == "-":
        return sys.stdin.read()
    return Path(path).read_text(encoding="utf-8")


def normalize_heading(value: str) -> str:
    value = re.sub(r"[`*_]", "", value)
    return re.sub(r"\s+", " ", value).strip().casefold()


def section(markdown: str, heading: str) -> str | None:
    match = re.search(
        rf"(?ms)^##\s+{re.escape(heading)}\s*$"
        rf"(.*?)"
        rf"(?=^##\s+|\Z)",
        markdown,
        flags=re.IGNORECASE,
    )
    return match.group(1) if match else None


def validate(markdown: str) -> dict[str, object]:
    errors: list[str] = []
    warnings: list[str] = []

    if not markdown.strip():
        errors.append("Epic body is empty.")
        return {"valid": False, "errors": errors, "warnings": warnings}

    headings = {normalize_heading(h) for h in HEADING_RE.findall(markdown)}

    for required in CORE_HEADINGS:
        if normalize_heading(required) not in headings:
            errors.append(f'Missing required heading: "{required}".')

    acceptance = section(markdown, "Epic Acceptance Criteria")
    if acceptance is not None and len(CHECKBOX_RE.findall(acceptance)) < 3:
        errors.append("Epic Acceptance Criteria must contain at least three checkboxes.")

    dod = section(markdown, "Definition of Done")
    if dod is not None and len(CHECKBOX_RE.findall(dod)) < 3:
        errors.append("Definition of Done must contain at least three checkboxes.")

    deliverables = section(markdown, "Deliverables")
    if deliverables is not None:
        child_refs = re.findall(r"(?i)\b(?:child item|issue|epic)\s*:", deliverables)
        workstream_headings = re.findall(r"(?im)^###\s+Workstream\b", deliverables)
        bullets = BULLET_RE.findall(deliverables)
        if not child_refs and not workstream_headings and len(bullets) < 2:
            errors.append(
                "Deliverables must define multiple meaningful work items or workstreams; "
                "otherwise this may be issue-sized rather than epic-sized."
            )

    for pattern in PLACEHOLDER_PATTERNS:
        if re.search(pattern, markdown, flags=re.IGNORECASE):
            errors.append(f"Unresolved template placeholder matched: {pattern}")

    if len(markdown.strip()) < 1000:
        warnings.append(
            "Epic body is unusually short; verify outcome, scope, decomposition, "
            "dependencies, rollout, risks, and completion rules."
        )

    if not re.search(r"(?i)\b(child|sub-issue|subissue|workstream|deliverable)\b", markdown):
        warnings.append("No explicit child-item or deliverable decomposition language was detected.")

    if not re.search(r"(?i)\b(blocked|blocking|dependenc|sequence|parallel)\b", markdown):
        warnings.append("No obvious dependency or sequencing language was detected.")

    if not re.search(r"(?i)\b(metric|measure|signal|verify|validation|observable)\b", markdown):
        warnings.append("No obvious success-measurement or verification language was detected.")

    return {"valid": not errors, "errors": errors, "warnings": warnings}


def main() -> int:
    if len(sys.argv) != 2:
        print(
            json.dumps(
                {"valid": False, "errors": ["Usage: validate_epic.py <path|->"], "warnings": []},
                indent=2,
            )
        )
        return 2

    try:
        markdown = read_input(sys.argv[1])
    except (OSError, UnicodeError) as exc:
        print(
            json.dumps(
                {"valid": False, "errors": [f"Cannot read input: {exc}"], "warnings": []},
                indent=2,
            )
        )
        return 2

    result = validate(markdown)
    print(json.dumps(result, indent=2))
    return 0 if result["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
