#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <base> <head>" >&2
  exit 2
fi

base="$1"
head="$2"

git rev-parse --verify "${base}^{commit}" >/dev/null
git rev-parse --verify "${head}^{commit}" >/dev/null

printf 'base=%s\n' "$(git rev-parse "$base")"
printf 'head=%s\n' "$(git rev-parse "$head")"
printf '\n[summary]\n'
git diff --stat "$base" "$head"

printf '\n[changed-files]\n'
git diff --name-status "$base" "$head"

printf '\n[risk-markers]\n'

risk=0

while IFS= read -r path; do
  case "$path" in
    .github/workflows/*|.gitlab-ci.yml|.circleci/*|Jenkinsfile|azure-pipelines.yml)
      printf 'ESCALATE ci-cd %s\n' "$path"
      risk=1
      ;;
    package.json|package-lock.json|pnpm-lock.yaml|yarn.lock|bun.lock|bun.lockb|Cargo.toml|Cargo.lock|go.mod|go.sum|requirements*.txt|pyproject.toml|uv.lock|Gemfile|Gemfile.lock|composer.json|composer.lock)
      printf 'REVIEW dependency-or-toolchain %s\n' "$path"
      ;;
    Dockerfile|docker-compose*.yml|docker-compose*.yaml|compose*.yml|compose*.yaml|*.tf|*.tfvars|helm/*|charts/*|k8s/*|kubernetes/*)
      printf 'ESCALATE infrastructure %s\n' "$path"
      risk=1
      ;;
    *.pem|*.key|*.p12|*.pfx|*.crt|*.cer|.env|.env.*)
      printf 'ESCALATE credential-material %s\n' "$path"
      risk=1
      ;;
    *.so|*.dll|*.dylib|*.exe|*.bin|*.jar|*.wasm)
      printf 'ESCALATE binary-or-native %s\n' "$path"
      risk=1
      ;;
    *)
      ;;
  esac

done < <(git diff --name-only "$base" "$head")

while IFS=$'\t' read -r old_mode new_mode old_sha new_sha status path; do
  [[ -z "${status:-}" ]] && continue
  if [[ "$old_mode" != "$new_mode" ]]; then
    printf 'REVIEW mode-change %s %s->%s\n' "$path" "$old_mode" "$new_mode"
  fi
  if [[ "$new_mode" == "160000" || "$old_mode" == "160000" ]]; then
    printf 'ESCALATE submodule %s\n' "$path"
    risk=1
  fi
  if [[ "$new_mode" == "120000" || "$old_mode" == "120000" ]]; then
    printf 'ESCALATE symlink %s\n' "$path"
    risk=1
  fi
done < <(git diff --raw "$base" "$head" | sed -E 's/^:([0-9]+) ([0-9]+) ([0-9a-f]+) ([0-9a-f]+) ([A-Z][0-9]*)\t(.*)$/\1\t\2\t\3\t\4\t\5\t\6/')

if git diff --numstat "$base" "$head" | awk '$1 == "-" || $2 == "-" {found=1} END {exit !found}'; then
  printf 'ESCALATE binary-diff-detected\n'
  risk=1
fi

if git diff -U0 "$base" "$head" -- '*.yml' '*.yaml' '*.json' '*.toml' '*.sh' '*.bash' '*.py' '*.js' '*.ts' '*.mjs' '*.cjs' 2>/dev/null \
  | grep -E '^\+[^+].*(pull_request_target|permissions:|secrets\.|GITHUB_TOKEN|curl .*[|][[:space:]]*(sh|bash)|wget .*[|][[:space:]]*(sh|bash)|child_process|subprocess\.|os\.system|eval\(|exec\()' \
  >/dev/null; then
  printf 'ESCALATE execution-or-credential-pattern\n'
  risk=1
fi

printf '\n[result]\n'
if [[ "$risk" -eq 1 ]]; then
  printf 'ESCALATE\n'
else
  printf 'FAST_PATH_CANDIDATE\n'
fi
