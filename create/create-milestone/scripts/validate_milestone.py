#!/usr/bin/env python3
"""Validate the structural completeness of a Markdown milestone description.

Usage:
    python scripts/validate_milestone.py path/to/milestone.md
    cat milestone.md | python scripts/validate_milestone.py -

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
    "Outcome",
    "Scope",
    "Exit Criteria",
    "Dependencies and Sequencing",
    "Risks and Mitigations",
    "References",
)

PLACEHOLDER_PATTERNS = (
    r"\[Describe the concrete delivery outcome",
    r"\[Included capability",
    r"\[Nearby work explicitly excluded",
    r"\[Objective criterion",
    r"\[Second independently verifiable",
    r"\[Issue, PR/MR",
    r"\[Related work intentionally outside",
    r"\[External dependency",
    r"\[Failure mode",
    r"\[Prevention, detection",
    r"\[Release, tag",
    r"\[Roadmap, release plan",
    r"\bTBD\b",
    r"\bTODO\b",
    r"\[fill(?: me)?\]",
)

HEADING_RE = re.compile(r"(?m)^#{2,6}\s+(.+?)\s*$")
CHECKBOX_RE = re.compile(r"(?m)^\s*-\s*\[(?: |x|X)\]\s+.+$")


def read_input(path: str) -> str:
    if path == "-":
        return sys.stdin.read()
    return Path(path).read_text(encoding="utf-8")


def normalize_heading(value: str) -> str:
    value = re.sub(r"[`*_]", "", value)
    return re.sub(r"\s+", " ", value).strip().casefold()


def section(markdown: str, heading: str) -> str | None:
    pattern = re.compile(
        rf"(?ms)^##\s+{re.escape(heading)}\s*$"
        rf"(.*?)"
        rf"(?=^##\s+|\Z)"
    )
    match = pattern.search(markdown)
    return match.group(1) if match else None


def validate(markdown: str) -> dict[str, object]:
    errors: list[str] = []
    warnings: list[str] = []

    if not markdown.strip():
        errors.append("Milestone description is empty.")
        return {"valid": False, "errors": errors, "warnings": warnings}

    headings = {normalize_heading(h) for h in HEADING_RE.findall(markdown)}

    for required in CORE_HEADINGS:
        if normalize_heading(required) not in headings:
            errors.append(f'Missing required heading: "{required}".')

    exit_criteria = section(markdown, "Exit Criteria")
    if exit_criteria is not None:
        count = len(CHECKBOX_RE.findall(exit_criteria))
        if count < 2:
            errors.append("Exit Criteria must contain at least two checkboxes.")

    scope = section(markdown, "Scope")
    if scope is not None:
        scope_headings = {
            normalize_heading(h)
            for h in re.findall(r"(?m)^###\s+(.+?)\s*$", scope)
        }
        for required in ("In scope", "Out of scope"):
            if normalize_heading(required) not in scope_headings:
                errors.append(f'Scope must contain "### {required}".')

    for pattern in PLACEHOLDER_PATTERNS:
        if re.search(pattern, markdown, flags=re.IGNORECASE):
            errors.append(f"Unresolved template placeholder matched: {pattern}")

    if len(markdown.strip()) < 450:
        warnings.append(
            "Milestone description is unusually short; verify outcome, scope, "
            "exit criteria, dependencies, and risks are explicit."
        )

    if normalize_heading("Work Inventory") not in headings:
        warnings.append(
            'No "Work Inventory" section detected. This is acceptable when native '
            "membership is already authoritative, but draft milestones should normally "
            "show committed and excluded/deferred work."
        )

    if not re.search(r"(?i)\b(release|launch|deliver|deploy|migrate|cutover|complete|exit)\b", markdown):
        warnings.append(
            "No obvious delivery-boundary language was detected; verify this is a milestone "
            "rather than an ongoing project or backlog."
        )

    return {"valid": not errors, "errors": errors, "warnings": warnings}


def main() -> int:
    if len(sys.argv) != 2:
        print(
            json.dumps(
                {
                    "valid": False,
                    "errors": ["Usage: validate_milestone.py <path|->"],
                    "warnings": [],
                },
                indent=2,
            )
        )
        return 2

    try:
        markdown = read_input(sys.argv[1])
    except (OSError, UnicodeError) as exc:
        print(
            json.dumps(
                {
                    "valid": False,
                    "errors": [f"Cannot read input: {exc}"],
                    "warnings": [],
                },
                indent=2,
            )
        )
        return 2

    result = validate(markdown)
    print(json.dumps(result, indent=2))
    return 0 if result["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
