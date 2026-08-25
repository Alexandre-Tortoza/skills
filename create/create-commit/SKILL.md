---
name: create-commit
description: Generates conventional commit messages focused on semantic grouping. Groups related files into single atomic commits (never file-by-file) and prioritizes "why" over "what". Trigger when user requests commit messages, "/commit", or stages changes.
license: MIT
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.1"
---
Proposta de Skill otimizada para o **Agent Skills**, configurada para manter o consumo de tokens baixo (via *Progressive Disclosure*) e cobrir todas as boas práticas das referências, com destaque para o **agrupamento semântico obrigatorio**.

---

Generate concise Conventional Commits. Enforce semantic file grouping (atomic commits) before writing messages.

## Execution Rules

### 1. Semantic Grouping (Mandatory)
- **NEVER** generate single-file commits blindly.
- Group files into cohesive, atomic logical units (e.g., `src/api.ts` + `types.ts` + `api.test.ts` = 1 commit).
- If the diff contains unrelated changes, split them into distinct commit groups.
- Read `references/semantic-grouping.md` if the staging state contains mixed domain changes.

### 2. Subject Line Format
- Format: `<type>(<scope>): <imperative summary>` (`<scope>` is optional).
- **Types**: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`, `revert`.
- **Imperative mood**: Use "add", "fix", "remove" (NOT "added", "fixes", "adding").
- **Length**: ≤ 50 chars preferred, hard cap 72. No trailing period.

### 3. Body Rules (Only When Needed)
- Omit body if the subject line is self-explanatory.
- **Mandatory Body Cases**: Breaking changes, security fixes, non-obvious business reasons (*why*), or data migrations.
- Explain **WHY** the change was made, not **WHAT** was changed (the diff shows "what").
- Hard wrap at 72 chars. Use `-` for list bullets.
- Put issue references at the end: `Closes #42`, `Refs #17`.

### 4. Prohibitions
- NO filler words: "This commit...", "I", "we", "now", "currently".
- NO AI attributions ("Generated with Claude") unless explicitly required by repo settings.
- NO emojis (unless repository convention strictly requires).
- NO repeating file names in the message.

## Examples

### Multi-file Semantic Group
**Group Files**: `src/users/service.ts`, `src/users/types.ts`, `tests/users.test.ts`

feat(users): add GET /users/:id/profile

Mobile client requires a lightweight payload to reduce LTE cold-start latency.

Closes #128
