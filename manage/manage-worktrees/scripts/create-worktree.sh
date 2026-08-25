#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  create-worktree.sh --slug <slug> --base <ref> [--branch <branch>] [--repo <path>] --confirm

Defaults:
  branch: worktree/<slug>
  path:   .worktrees/<slug>

The script is non-interactive. --confirm is required and must only be supplied
after the user has approved the exact worktree creation operation.
USAGE
}

repo="."
slug=""
base=""
branch=""
confirmed=0

while (($#)); do
  case "$1" in
    --repo)
      [[ $# -ge 2 ]] || { echo "error: --repo requires a path" >&2; exit 2; }
      repo="$2"
      shift 2
      ;;
    --slug)
      [[ $# -ge 2 ]] || { echo "error: --slug requires a value" >&2; exit 2; }
      slug="$2"
      shift 2
      ;;
    --base)
      [[ $# -ge 2 ]] || { echo "error: --base requires a ref" >&2; exit 2; }
      base="$2"
      shift 2
      ;;
    --branch)
      [[ $# -ge 2 ]] || { echo "error: --branch requires a name" >&2; exit 2; }
      branch="$2"
      shift 2
      ;;
    --confirm)
      confirmed=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$slug" ]] || { echo "error: --slug is required" >&2; exit 2; }
[[ -n "$base" ]] || { echo "error: --base is required" >&2; exit 2; }
[[ $confirmed -eq 1 ]] || {
  echo "error: refusing to create a worktree without --confirm" >&2
  echo "obtain explicit user approval for the exact base, branch, and path first" >&2
  exit 3
}

if [[ ! "$slug" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "error: invalid slug '$slug'; use letters, digits, dot, underscore, or hyphen" >&2
  exit 2
fi

root="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" || {
  echo "error: not inside a Git repository: $repo" >&2
  exit 1
}

branch="${branch:-worktree/$slug}"
git -C "$root" check-ref-format --branch "$branch" >/dev/null || {
  echo "error: invalid branch name: $branch" >&2
  exit 2
}

base_commit="$(git -C "$root" rev-parse --verify "${base}^{commit}" 2>/dev/null)" || {
  echo "error: base ref does not resolve to a commit: $base" >&2
  exit 1
}

path_rel=".worktrees/$slug"
path_abs="$root/$path_rel"

if [[ -e "$path_abs" ]]; then
  echo "error: target path already exists: $path_abs" >&2
  exit 1
fi

if git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
  echo "error: local branch already exists: $branch" >&2
  exit 1
fi

while IFS= read -r remote; do
  [[ -n "$remote" ]] || continue
  set +e
  remote_output="$(git -C "$root" ls-remote --exit-code --heads "$remote" "refs/heads/$branch" 2>&1)"
  remote_status=$?
  set -e

  case "$remote_status" in
    0)
      echo "error: branch already exists on remote '$remote': $branch" >&2
      exit 1
      ;;
    2)
      ;;
    *)
      echo "error: could not verify branch availability on remote '$remote'" >&2
      [[ -n "$remote_output" ]] && echo "$remote_output" >&2
      exit 1
      ;;
  esac
done < <(git -C "$root" remote)

if git -C "$root" worktree list --porcelain | awk -v target="$path_abs" '
  $1 == "worktree" && $2 == target { found = 1 }
  END { exit found ? 0 : 1 }
'; then
  echo "error: target path is already registered as a worktree: $path_abs" >&2
  exit 1
fi

ensure_managed_block() {
  local file="$1"
  local begin="$2"
  local end="$3"
  local block="$4"
  local begin_count end_count start finish tmp

  if [[ ! -e "$file" ]]; then
    : > "$file"
  fi

  begin_count="$(grep -Fxc "$begin" "$file" || true)"
  end_count="$(grep -Fxc "$end" "$file" || true)"

  if [[ "$begin_count" == "0" && "$end_count" == "0" ]]; then
    if [[ -s "$file" && -n "$(tail -c 1 "$file")" ]]; then
      printf '\n' >> "$file"
    fi
    [[ ! -s "$file" ]] || printf '\n' >> "$file"
    printf '%s\n' "$block" >> "$file"
    return
  fi

  if [[ "$begin_count" != "1" || "$end_count" != "1" ]]; then
    echo "error: malformed or duplicate managed block in $file" >&2
    exit 1
  fi

  start="$(grep -Fnx "$begin" "$file" | cut -d: -f1)"
  finish="$(grep -Fnx "$end" "$file" | cut -d: -f1)"

  if (( start >= finish )); then
    echo "error: malformed managed block order in $file" >&2
    exit 1
  fi

  tmp="$(mktemp "${file}.tmp.XXXXXX")"
  {
    if (( start > 1 )); then
      head -n $((start - 1)) "$file"
    fi
    printf '%s\n' "$block"
    tail -n +$((finish + 1)) "$file"
  } > "$tmp"
  mv "$tmp" "$file"
}

gitignore_block='# BEGIN manage-worktrees
.worktrees/
.worktrees.json
# END manage-worktrees'

ignore_block='# BEGIN manage-worktrees
!.worktrees.json
!.worktrees/
!.worktrees/**
# END manage-worktrees'

worktrees_ignored=0
manifest_ignored=0
if git -C "$root" check-ignore --no-index -q "$path_rel/probe" 2>/dev/null; then
  worktrees_ignored=1
fi
if git -C "$root" check-ignore --no-index -q ".worktrees.json" 2>/dev/null; then
  manifest_ignored=1
fi

if [[ $worktrees_ignored -ne 1 || $manifest_ignored -ne 1 ]]; then
  ensure_managed_block "$root/.gitignore" '# BEGIN manage-worktrees' '# END manage-worktrees' "$gitignore_block"
fi

if [[ -f "$root/.ignore" ]]; then
  ensure_managed_block "$root/.ignore" '# BEGIN manage-worktrees' '# END manage-worktrees' "$ignore_block"
fi

mkdir -p "$root/.worktrees"

if [[ ! -f "$root/.worktrees.json" ]]; then
  cat > "$root/.worktrees.json" <<'JSON'
{
  "version": "1.0.0",
  "updatedAt": null,
  "lanes": []
}
JSON
fi

printf 'Repository: %s\n' "$root"
printf 'Base: %s (%s)\n' "$base" "$base_commit"
printf 'Branch: %s\n' "$branch"
printf 'Path: %s\n' "$path_rel"

git -C "$root" worktree add -b "$branch" "$path_abs" "$base_commit"

printf '\nCreated worktree:\n'
git -C "$root" worktree list --porcelain
printf '\nNext: register lane metadata in %s/.worktrees.json\n' "$root"
