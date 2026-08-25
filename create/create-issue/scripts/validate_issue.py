#!/usr/bin/env python3
"""Validate the structural completeness of a Markdown issue body.

Usage:
    python scripts/validate_issue.py path/to/issue.md
    cat issue.md | python scripts/validate_issue.py -

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
    "Goal",
    "Non-goals",
    "Scope",
    "Requirements",
    "Acceptance Criteria",
    "Test Plan",
    "Dependencies and Relationships",
    "Risks and Mitigations",
    "Definition of Done",
    "References",
)

PLACEHOLDER_PATTERNS = (
    r"\[One short paragraph",
    r"\[What ",
    r"\[The concrete outcome",
    r"\[Explicitly excluded",
    r"\[Deliverable or behavior",
    r"\[Required behavior",
    r"\[Known implementation",
    r"\[A criterion",
    r"\[Unit/component",
    r"\[Native parent",
    r"\[Failure mode",
    r"\[Specifications, code",
    r"\bTBD\b",
    r"\bTODO\b",
    r"\[fill(?: me)?\]",
)

CHECKBOX_RE = re.compile(r"(?m)^\s*-\s*\[(?: |x|X)\]\s+.+$")
HEADING_RE = re.compile(r"(?m)^#{2,6}\s+(.+?)\s*$")


def read_input(path: str) -> str:
    if path == "-":
        return sys.stdin.read()
    return Path(path).read_text(encoding="utf-8")


def normalize_heading(value: str) -> str:
    value = re.sub(r"[`*_]", "", value)
    return re.sub(r"\s+", " ", value).strip().casefold()


def validate(markdown: str) -> dict[str, object]:
    errors: list[str] = []
    warnings: list[str] = []

    if not markdown.strip():
        errors.append("Issue body is empty.")
        return {"valid": False, "errors": errors, "warnings": warnings}

    headings = {normalize_heading(h) for h in HEADING_RE.findall(markdown)}

    for required in CORE_HEADINGS:
        if normalize_heading(required) not in headings:
            errors.append(f'Missing required heading: "{required}".')

    acceptance_match = re.search(
        r"(?ms)^##\s+Acceptance Criteria\s*$"
        r"(.*?)"
        r"(?=^##\s+|\Z)",
        markdown,
    )
    if acceptance_match:
        acceptance_count = len(CHECKBOX_RE.findall(acceptance_match.group(1)))
        if acceptance_count < 2:
            errors.append("Acceptance Criteria must contain at least two checkboxes.")

    dod_match = re.search(
        r"(?ms)^##\s+Definition of Done\s*$"
        r"(.*?)"
        r"(?=^##\s+|\Z)",
        markdown,
    )
    if dod_match:
        dod_count = len(CHECKBOX_RE.findall(dod_match.group(1)))
        if dod_count < 2:
            errors.append("Definition of Done must contain at least two checkboxes.")

    for pattern in PLACEHOLDER_PATTERNS:
        if re.search(pattern, markdown, flags=re.IGNORECASE):
            errors.append(f"Unresolved template placeholder matched: {pattern}")

    if len(markdown.strip()) < 700:
        warnings.append(
            "Issue body is unusually short for an implementation-ready issue; "
            "verify that scope, validation, dependencies, and risks are sufficiently explicit."
        )

    if "## Non-goals" in markdown and re.search(
        r"(?ms)^##\s+Non-goals\s*$\s*(?:N/?A|None)\s*$", markdown
    ):
        warnings.append("Non-goals is empty; explicit exclusions usually improve scope control.")

    if not re.search(r"(?i)\b(test|verify|validation|assert|given|when|then)\b", markdown):
        warnings.append("No obvious verification language was detected.")

    return {"valid": not errors, "errors": errors, "warnings": warnings}


def main() -> int:
    if len(sys.argv) != 2:
        print(
            json.dumps(
                {"valid": False, "errors": ["Usage: validate_issue.py <path|->"], "warnings": []},
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
