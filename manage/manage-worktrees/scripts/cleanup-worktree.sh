#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  cleanup-worktree.sh --slug <slug> [--repo <path>] --confirm
  cleanup-worktree.sh --slug <slug> [--repo <path>] --confirm --delete-branch --confirm-branch-delete
  cleanup-worktree.sh [--repo <path>] --prune --confirm-prune

The script never force-removes a dirty worktree and never force-deletes a branch.
Approval flags are guards and must only be supplied after explicit user approval.
USAGE
}

repo="."
slug=""
confirmed=0
delete_branch=0
confirm_branch_delete=0
prune=0
confirm_prune=0

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
    --confirm)
      confirmed=1
      shift
      ;;
    --delete-branch)
      delete_branch=1
      shift
      ;;
    --confirm-branch-delete)
      confirm_branch_delete=1
      shift
      ;;
    --prune)
      prune=1
      shift
      ;;
    --confirm-prune)
      confirm_prune=1
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

root="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" || {
  echo "error: not inside a Git repository: $repo" >&2
  exit 1
}

if [[ $prune -eq 1 ]]; then
  [[ -z "$slug" ]] || { echo "error: --prune cannot be combined with --slug" >&2; exit 2; }
  [[ $delete_branch -eq 0 ]] || { echo "error: --prune cannot be combined with --delete-branch" >&2; exit 2; }

  printf 'Prune dry run:\n'
  git -C "$root" worktree prune --dry-run --verbose

  [[ $confirm_prune -eq 1 ]] || {
    echo "error: refusing to prune without --confirm-prune" >&2
    exit 3
  }

  git -C "$root" worktree prune --verbose
  printf '\nRegistered worktrees after prune:\n'
  git -C "$root" worktree list --porcelain
  exit 0
fi

[[ -n "$slug" ]] || { echo "error: --slug is required unless --prune is used" >&2; exit 2; }
[[ $confirmed -eq 1 ]] || {
  echo "error: refusing to remove a worktree without --confirm" >&2
  exit 3
}
if [[ $delete_branch -eq 1 && $confirm_branch_delete -ne 1 ]]; then
  echo "error: --delete-branch requires --confirm-branch-delete before any removal occurs" >&2
  exit 3
fi

if [[ ! "$slug" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "error: invalid slug '$slug'" >&2
  exit 2
fi

path_rel=".worktrees/$slug"
path_abs="$root/$path_rel"

[[ -d "$path_abs" ]] || {
  echo "error: worktree directory does not exist: $path_abs" >&2
  exit 1
}

canonical_path="$(cd "$path_abs" && pwd -P)"
registered=0
while IFS= read -r line; do
  case "$line" in
    "worktree "*)
      candidate="${line#worktree }"
      if [[ "$candidate" == "$canonical_path" || "$candidate" == "$path_abs" ]]; then
        registered=1
        break
      fi
      ;;
  esac
done < <(git -C "$root" worktree list --porcelain)

[[ $registered -eq 1 ]] || {
  echo "error: path exists but is not registered as a Git worktree: $path_abs" >&2
  exit 1
}

status="$(git -C "$path_abs" status --short)"
if [[ -n "$status" ]]; then
  echo "error: refusing to remove dirty worktree: $path_abs" >&2
  printf '%s\n' "$status" >&2
  exit 1
fi

branch="$(git -C "$path_abs" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
head="$(git -C "$path_abs" rev-parse HEAD)"

printf 'Repository: %s\n' "$root"
printf 'Path: %s\n' "$path_rel"
printf 'Branch: %s\n' "${branch:-DETACHED}"
printf 'HEAD: %s\n' "$head"
printf 'Dirty: no\n'

git -C "$root" worktree remove "$path_abs"

if [[ $delete_branch -eq 1 ]]; then
  [[ -n "$branch" ]] || {
    echo "error: cannot delete a branch for a detached-HEAD worktree" >&2
    exit 1
  }

  git -C "$root" branch -d "$branch"
fi

printf '\nRegistered worktrees after cleanup:\n'
git -C "$root" worktree list --porcelain
printf '\nNext: archive or remove the lane record in %s/.worktrees.json if present.\n' "$root"
