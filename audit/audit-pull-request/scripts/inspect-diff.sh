#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: inspect-diff.sh <base-ref-or-sha> <head-ref-or-sha>

Performs static Git inspection of a pull-request range. It never checks out the
head and never executes code from the pull request.
EOF
}

if [[ $# -ne 2 ]]; then
  usage
  exit 2
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "error: not inside a Git repository" >&2
  exit 2
fi

BASE_INPUT=$1
HEAD_INPUT=$2

if ! BASE_SHA=$(git rev-parse --verify "${BASE_INPUT}^{commit}" 2>/dev/null); then
  echo "error: cannot resolve base commit: ${BASE_INPUT}" >&2
  exit 2
fi

if ! HEAD_SHA=$(git rev-parse --verify "${HEAD_INPUT}^{commit}" 2>/dev/null); then
  echo "error: cannot resolve head commit: ${HEAD_INPUT}" >&2
  exit 2
fi

if ! MERGE_BASE=$(git merge-base "$BASE_SHA" "$HEAD_SHA" 2>/dev/null); then
  echo "error: base and head do not have a merge base" >&2
  exit 2
fi

RANGE="${BASE_SHA}...${HEAD_SHA}"

section() {
  printf '\n## %s\n' "$1"
}

printf 'Base SHA: %s\n' "$BASE_SHA"
printf 'Head SHA: %s\n' "$HEAD_SHA"
printf 'Merge base: %s\n' "$MERGE_BASE"

section "Diff stat"
git diff --stat "$RANGE"

section "Name status"
git diff --name-status "$RANGE"

section "Numeric stat"
git diff --numstat "$RANGE"

section "Mode, rename, symlink, and create/delete summary"
git diff --summary "$RANGE"

section "Whitespace errors"
if git diff --check "$RANGE"; then
  echo "No diff-check errors detected."
else
  echo "WARNING: git diff --check reported whitespace errors."
fi

section "Submodule changes"
git diff --submodule=log "$RANGE"

section "Sensitive changed paths"
changed_paths=$(git diff --name-only "$RANGE")
if [[ -n "$changed_paths" ]]; then
  printf '%s\n' "$changed_paths" | grep -E -i '(^|/)(\.github/workflows|\.gitlab-ci|Dockerfile|docker-compose|compose\.|package(-lock)?\.json|pnpm-lock\.yaml|yarn\.lock|bun\.lockb?|Cargo\.(toml|lock)|go\.(mod|sum)|Gemfile(\.lock)?|pyproject\.toml|poetry\.lock|uv\.lock|requirements[^/]*\.txt|pom\.xml|build\.gradle|settings\.gradle|\.gitattributes|\.gitmodules|Makefile|Justfile|Taskfile|scripts?|migrations?|deploy|release)(/|$|\.)' || echo "No common sensitive paths matched."
else
  echo "No changed paths."
fi

section "Executable and symlink entries at head"
git ls-tree -r "$HEAD_SHA" | awk '$1 == "100755" || $1 == "120000" { print }' || true

section "Review hints from added lines"
echo "These are search hints only, not findings. Inspect context before assigning severity."
added_lines=$(git diff --no-ext-diff --unified=0 "$RANGE" -- . ':(exclude)*.lock' ':(exclude)*lock.json' | grep '^+' | grep -v '^+++' || true)
if [[ -n "$added_lines" ]]; then
  printf '%s\n' "$added_lines" | grep -E -i '(curl |wget |Invoke-WebRequest|child_process|subprocess|os\.system|Runtime\.getRuntime|ProcessBuilder|exec\(|eval\(|shell[[:space:]]*=[[:space:]]*true|chmod|chown|sudo |process\.env|os\.environ|AWS_|GITHUB_TOKEN|CI_JOB_TOKEN|SECRET|PASSWORD|TOKEN|private[_-]?key|authorization|deserialize|pickle|yaml\.load|tar |unzip|rm -rf|DROP TABLE|pull_request_target)' || echo "No common execution/credential patterns matched."
else
  echo "No added text lines."
fi

section "Changed file count"
git diff --name-only "$RANGE" | awk 'END { print NR + 0 }'

cat <<'EOF'

Static inspection complete. Review the full patch manually. Pattern matches are
not proof of a vulnerability, and absence of matches is not proof of safety.
EOF
