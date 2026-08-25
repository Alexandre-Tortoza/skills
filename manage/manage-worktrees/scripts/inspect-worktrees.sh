#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: inspect-worktrees.sh [--repo <path>]

Read-only inspection of Git worktree state.
USAGE
}

repo="."

while (($#)); do
  case "$1" in
    --repo)
      [[ $# -ge 2 ]] || { echo "error: --repo requires a path" >&2; exit 2; }
      repo="$2"
      shift 2
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

root="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" || {
  echo "error: not inside a Git repository: $repo" >&2
  exit 1
}

branch="$(git -C "$root" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
if [[ -z "$branch" ]]; then
  branch="DETACHED@$(git -C "$root" rev-parse --short HEAD)"
fi

printf 'Repository: %s\n' "$root"
printf 'Current checkout: %s\n' "$branch"
printf 'HEAD: %s\n' "$(git -C "$root" rev-parse HEAD)"

if [[ -n "$(git -C "$root" status --short)" ]]; then
  printf 'Dirty: yes\n'
  git -C "$root" status --short
else
  printf 'Dirty: no\n'
fi

printf '\nRemotes:\n'
if [[ -n "$(git -C "$root" remote)" ]]; then
  git -C "$root" remote -v
else
  printf '(none)\n'
fi

printf '\nRegistered worktrees:\n'
git -C "$root" worktree list --porcelain

printf '\nLocal branches:\n'
git -C "$root" for-each-ref --sort=refname --format='%(refname:short) %(objectname)' refs/heads/

if [[ -f "$root/.worktrees.json" ]]; then
  printf '\nManifest: %s\n' "$root/.worktrees.json"
else
  printf '\nManifest: not present\n'
fi
