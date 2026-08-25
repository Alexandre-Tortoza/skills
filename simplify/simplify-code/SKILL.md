---
name: simplify-code
description: Use this skill when simplifying or refactoring working code without changing behavior, especially when code has unnecessary nesting, duplication, verbose control flow, unclear names, dead code, needless abstractions, or review feedback about readability and maintainability. Prefer it after functionality and tests are stable, for targeted cleanup of recently changed code. Do not use it for behavioral redesigns, performance rewrites, or code you do not yet understand.
license: MIT
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "1.0"
---

# Simplify Code

## Overview

Reduce accidental complexity while preserving observable behavior exactly. Optimize for comprehension, maintainability, and reviewability rather than line count.

A successful simplification should make the code easier for another developer to understand without forcing them to reconstruct intent from control flow, clever syntax, or unnecessary indirection.

## Use This Skill When

- Working code is harder to read or maintain than necessary.
- A review identifies complexity, duplication, confusing naming, or excessive nesting.
- Recently changed code accumulated temporary structure or implementation noise.
- A function or module has grown beyond one clear responsibility.
- Equivalent logic is repeated in multiple locations.
- An abstraction no longer pays for its complexity.
- Dead code, redundant checks, or unnecessary wrappers remain after implementation.

## Do Not Use This Skill When

- The code is already clear and consistent with the project.
- The requested change intentionally alters behavior or product requirements.
- The code has not been understood well enough to state its behavior contract.
- A simpler-looking implementation would weaken required performance characteristics.
- The code is about to be replaced entirely.
- The task is primarily architectural redesign rather than simplification.

## Core Invariants

Every simplification MUST preserve:

- Inputs and accepted input ranges.
- Outputs and return shapes.
- Side effects and their ordering.
- Error types, failure conditions, and error propagation.
- Public interfaces and compatibility unless the user explicitly approves a change.
- Observable timing or ordering semantics when callers depend on them.
- Existing tests without rewriting expectations to accommodate the refactor.

If equivalence is uncertain, keep the current implementation until the uncertainty is resolved.

## Principles

### Preserve behavior before improving style

Do not trade correctness for elegance. A refactor that requires changing tests because expectations no longer hold is usually a behavioral change, not a simplification.

### Follow the codebase, not personal preference

Before editing, inspect the repository's local conventions and neighboring code. Prefer consistency with established patterns for:

- Module boundaries and imports.
- Naming.
- Function and class style.
- Error handling.
- Type annotations.
- Async behavior.
- Logging and observability.
- Tests and fixtures.

Read repository guidance such as `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, style guides, linters, formatters, and framework conventions when present.

### Prefer obvious code over clever code

Compact code is not automatically simple. Prefer structures whose purpose can be understood on first read.

Avoid transformations that save lines but increase mental branching, hidden coercion, implicit state, or expression density.

### Keep useful abstractions

Do not remove an abstraction solely because it is small. Keep helpers and boundaries that provide one or more of these benefits:

- Name an important concept.
- Isolate side effects.
- Improve testability.
- Preserve a stable interface.
- Hide framework or platform details.
- Centralize a policy or invariant.

Remove abstractions that only forward calls, duplicate another layer, or exist for speculative future use without providing current value.

### Keep scope narrow

Default to code related to the current task or recently modified area. Avoid drive-by cleanup in unrelated modules unless explicitly requested.

A smaller focused diff is easier to verify, review, revert, and reason about.

## Workflow

### 1. Understand the code before changing it

Establish why the current structure exists.

Answer these questions before editing:

- What responsibility does this code have?
- Who calls it, and what does it call?
- What inputs and outputs form its behavior contract?
- What side effects occur, and in what order?
- Which edge cases and failure paths matter?
- Which tests define expected behavior?
- Are there performance, platform, framework, or compatibility constraints?
- Does repository history explain a non-obvious implementation choice?

Use git history or blame when the reason for a suspicious construct is unclear. Do not remove a structure whose purpose has not been understood.

### 2. Establish a verification baseline

Before the first refactor, identify the commands that prove the current code is healthy.

Use the narrowest relevant checks first, then broaden when needed:

1. Targeted tests for the affected module.
2. Type checking or compilation.
3. Linting and formatting checks.
4. Broader test suites when the change crosses module boundaries.

If the baseline is already failing, record the existing failures and do not attribute them to the simplification.

### 3. Find concrete simplification opportunities

Look for evidence of accidental complexity rather than refactoring by aesthetic preference.

#### Structural complexity

| Signal | Typical problem | Preferred direction |
| --- | --- | --- |
| Deep nesting | Control flow requires excessive mental state | Guard clauses, early returns, focused helpers |
| Long functions | Multiple responsibilities are mixed | Extract cohesive operations with meaningful names |
| Nested ternaries | Branching is difficult to scan | `if`/`else`, `switch`, match expressions, or lookup tables |
| Boolean argument clusters | Call sites hide intent | Options objects, enums, or separate operations |
| Repeated condition checks | Policy is duplicated | Named predicates or centralized validation |
| Large branch blocks | One function coordinates unrelated paths | Split orchestration from branch-specific work |

Treat thresholds such as three levels of nesting or fifty-line functions as investigation signals, not mechanical rules.

#### Naming and readability

Look for:

- Generic names such as `data`, `result`, `temp`, or `value` when a domain name is available.
- Abbreviations that make code harder to search or understand.
- Names that no longer match behavior.
- Functions whose names hide mutation or side effects.
- Comments that merely restate the code.
- Missing explanation for constraints that cannot be expressed directly in code.

Prefer descriptive names and code that explains what happens. Preserve comments that explain why a constraint, workaround, or unusual decision exists.

#### Redundancy

Look for:

- Repeated implementation logic.
- Unreachable branches.
- Unused variables, imports, functions, or types.
- Commented-out code that is already preserved in version control.
- Pass-through wrappers with no policy or semantic value.
- Multiple abstractions representing the same concept.
- Redundant type assertions or conversions.
- Defensive checks already guaranteed by an earlier invariant.

Confirm that code is truly unused before deleting it, including dynamic registrations, reflection, dependency injection, framework conventions, and externally consumed APIs.

### 4. Choose the smallest safe transformation

Prefer local transformations that make one idea clearer at a time.

Good examples include:

- Replace nested branches with guard clauses.
- Rename ambiguous identifiers.
- Extract a repeated predicate.
- Remove a redundant wrapper.
- Replace manual collection building with a standard operation when it stays readable.
- Delete proven dead code.
- Separate orchestration from computation.
- Collapse duplicated paths that have identical semantics.

Avoid mixing unrelated refactors into the same change.

### 5. Apply changes incrementally

For each simplification:

1. Make one coherent change.
2. Run the most relevant verification.
3. Compare behavior-sensitive details with the original.
4. Keep the change if verification passes and clarity improves.
5. Revert or revise it if equivalence is uncertain or readability worsens.

Do not accumulate a large unverified batch of edits.

When a refactor spans roughly 500 or more repetitive lines, prefer an automated transformation such as a codemod, AST rewrite, or deterministic script instead of manual editing. Validate representative cases before applying it broadly.

### 6. Review the complete diff

After individual edits pass, inspect the full result as a reviewer would.

Check that:

- The code is easier to understand than before.
- The diff contains no unrelated cleanup.
- New helpers or abstractions earn their existence.
- Existing project conventions are preserved.
- Error handling is unchanged or more explicit without changing semantics.
- No required logging, metrics, tracing, or side effects disappeared.
- No behavior was accidentally coupled to a formatting or style change.

If the final result is harder to review than the original, reduce or revert the refactor.

## Common Simplification Patterns

### Flatten control flow

Prefer early exits when they remove indentation and make failure conditions explicit.

```ts
// Before
function process(input: Input) {
  if (input) {
    if (input.valid) {
      return run(input)
    }
  }

  return null
}

// After
function process(input: Input | null) {
  if (!input || !input.valid) return null
  return run(input)
}
```

Do not combine guards when separate conditions have different error behavior or deserve independent names.

### Replace opaque branching with named decisions

```ts
// Before
const label = isNew ? 'New' : isUpdated ? 'Updated' : isArchived ? 'Archived' : 'Active'

// After
function getStatusLabel(item: Item) {
  if (item.isNew) return 'New'
  if (item.isUpdated) return 'Updated'
  if (item.isArchived) return 'Archived'
  return 'Active'
}
```

The longer version is preferable when it reduces parsing effort.

### Remove unnecessary async layers

```ts
// Before
async function getUser(id: string): Promise<User> {
  return await userService.findById(id)
}

// After
function getUser(id: string): Promise<User> {
  return userService.findById(id)
}
```

Do not remove `await` when it changes stack traces, `try`/`catch` behavior, cleanup timing, or framework semantics.

### Use standard collection operations when clearer

```ts
// Before
const activeUsers: User[] = []
for (const user of users) {
  if (user.isActive) activeUsers.push(user)
}

// After
const activeUsers = users.filter((user) => user.isActive)
```

Do not force `map`, `filter`, `reduce`, comprehensions, or chaining when a simple loop communicates state transitions more clearly.

### Simplify redundant boolean logic

```ts
// Before
function isValid(input: string) {
  if (input.length > 0 && input.length < 100) {
    return true
  }

  return false
}

// After
function isValid(input: string) {
  return input.length > 0 && input.length < 100
}
```

Keep explicit branches when they carry distinct side effects, diagnostics, or domain meaning.

### Use comprehensions carefully in Python

```python
# Before
names = {}
for item in items:
    names[item.id] = item.name

# After
names = {item.id: item.name for item in items}
```

Prefer a normal loop when the comprehension needs multiple conditions, side effects, exception handling, or nested transformations that reduce readability.

### Treat component architecture as a judgment call

In React, Vue, JSX, templates, and similar UI code, do not automatically replace prop passing with context, stores, dependency injection, or composition. Those changes alter architecture and dependency visibility.

Flag architectural opportunities separately unless the user explicitly requests them.

## Over-Simplification Traps

Avoid these failure modes:

- Inlining a helper that gave a domain concept a useful name.
- Merging independent responsibilities into one function.
- Replacing explicit control flow with a dense expression.
- Removing error handling to make code shorter.
- Removing an interface required for testing or substitution.
- Eliminating validation because current callers happen to validate first.
- Replacing readable code with framework-specific tricks unfamiliar to the project.
- Introducing a new dependency for a trivial cleanup.
- Changing public APIs as part of an internal readability refactor.
- Optimizing primarily for fewer lines.

## Common Rationalizations to Reject

- "It works, so readability does not matter." Working code still accumulates maintenance cost.
- "Fewer lines means simpler." Compression can increase cognitive load.
- "I can clean this unrelated module while I am here." Unrelated edits increase risk and review noise.
- "The type system explains everything." Types describe structure better than intent.
- "This abstraction might be useful someday." Speculative layers impose present cost for uncertain value.
- "The original code must have a reason." Investigate the reason instead of assuming either that it matters or that it does not.
- "I can refactor while implementing the feature." Separate behavioral work from structural cleanup when practical.

## Red Flags

Stop and reassess if any of these occur:

- Existing tests need new expectations solely because of the refactor.
- Error handling becomes weaker or less specific.
- A new abstraction is more complex than the code it replaces.
- The diff expands far beyond the requested scope.
- A performance-sensitive path changes without evidence that the impact is acceptable.
- The simplified code relies on subtle coercion, precedence, mutation, or lifecycle behavior.
- Many unrelated simplifications are bundled together.
- You cannot clearly explain why the before and after versions are behaviorally equivalent.

## Output Contract

After completing a simplification task, report only information useful for review:

```md
## Simplified

- `<path>`: <what became clearer or less complex>

## Verification

- `<command>`: passed

## Notes

- <behavioral assumptions, intentionally preserved complexity, or skipped risky opportunities>
```

Omit sections that have no useful content. Do not claim a command passed unless it was actually run.

## Validation Checklist

Before considering the task complete, verify:

- [ ] Existing behavior is preserved.
- [ ] Relevant tests pass without changing expectations for the refactor.
- [ ] Build or type checking succeeds when applicable.
- [ ] Lint and formatting checks pass when applicable.
- [ ] The resulting code is easier to understand than the original.
- [ ] Naming reflects current behavior and domain intent.
- [ ] Error paths and side effects remain intact.
- [ ] No required observability or cleanup logic was removed.
- [ ] Dead code introduced or exposed by the refactor was removed when safe.
- [ ] The diff contains no unrelated changes.
- [ ] The implementation follows local project conventions.
- [ ] Any intentionally retained complexity has a concrete reason.

## Credits

This skill is informed by Addy Osmani's `code-simplification` Agent Skill and the code simplification practices it references:

https://github.com/addyosmani/agent-skills/blob/main/skills/code-simplification/SKILL.md
