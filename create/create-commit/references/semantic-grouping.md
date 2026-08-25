# Semantic Grouping & Atomic Commits

Commits must be **atomic**: a commit represents a single logical unit of work that leaves the codebase in a working state.

## Rules for Grouping Files

1. **Feature Cohesion**:
   - Combine implementation + unit tests + types/interfaces + docs update in the SAME commit.
   - Example: `auth.controller.ts`, `auth.test.ts`, and `auth.swagger.ts` belong together.

2. **Separation of Concerns**:
   - Separate refactoring from behavior changes. First commit `refactor(...)`, then commit `feat(...)` or `fix(...)`.
   - Separate unrelated bug fixes into distinct commits, even if done in the same session.

3. **Anti-Pattern Avoidance**:
   - ❌ **File-by-file commits**: Noise in git log (`fix user.ts`, `fix user.test.ts`).
   - ❌ **Monolithic commits**: Combining database migrations, UI tweaks, and dependency updates in 1 commit.

## Disambiguation Flow
When evaluating `git status` / `git diff`:
1. Cluster files by domain/feature.
2. Output a separate `git add <files>` command and commit message for each logical group.
