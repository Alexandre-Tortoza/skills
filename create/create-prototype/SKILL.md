---
name: create-prototype
description: Use this skill when the user wants to build a disposable prototype to answer a focused design question before production implementation, especially to validate business logic, state transitions, data shape, interaction flows, or materially different UI directions.
license: MIT
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.1"
---

# Create Prototype

Build the smallest disposable artifact that can answer one concrete design question.

A prototype is not a reduced production implementation. It is intentionally temporary code optimized for learning quickly, exposing assumptions, and making a decision easier.

## Choose the Prototype Type

Identify the primary uncertainty before writing code.

- **Logic prototype**: use when the question is whether business rules, state transitions, data shape, an API surface, or an interaction model behaves correctly. Read [references/logic-prototype.md](references/logic-prototype.md) before implementation.
- **UI prototype**: use when the question is what a page, component, flow, information hierarchy, or interaction should look or feel like. Read [references/ui-prototype.md](references/ui-prototype.md) before implementation.

If both are uncertain, validate the underlying logic first unless the user explicitly wants visual exploration independent of final behavior.

If the request is ambiguous and clarification is unavailable, infer from the surrounding code:

- Domain, service, model, reducer, state machine, or backend code usually implies a logic prototype.
- Page, route, component, layout, or design-system code usually implies a UI prototype.

State any material assumption in the prototype itself so the question being tested remains visible.

## Workflow

### 1. State the Question

Write one sentence describing exactly what the prototype must answer.

Good questions are narrow and falsifiable:

- "Can this state model represent cancellation after partial completion?"
- "Which information hierarchy makes the review screen easiest to scan?"

Avoid vague goals such as "explore the feature" or "make a prototype of the dashboard."

### 2. Inspect the Existing Project

Before creating files, inspect the relevant implementation area and reuse established conventions for:

- Routing and file placement.
- Runtime and package manager.
- Styling and component libraries.
- Existing data shapes and read-only fixtures.
- Naming conventions.

Place prototype code close to the area it informs, but name it clearly so it cannot be mistaken for production code.

### 3. Define the Smallest Experiment

Include only the behavior necessary to answer the question.

Decide:

- What actions or variants must exist.
- What state or output must be visible.
- Which scenarios expose the risky assumptions.
- What evidence would support or reject the current direction.

Prefer a prototype that can be understood in minutes over one that demonstrates every possible case.

### 4. Build for Fast Inspection

Make the prototype trivial to run and evaluate.

- Use one obvious command when the project runtime is required.
- Prefer a self-contained file when no runtime is required.
- Keep state in memory by default.
- Show the relevant state, result, or active variant directly in the prototype.
- Use domain language in labels and explanations when non-developers may evaluate it.

### 5. Exercise the Important Cases

Include the happy path plus the few edge cases most likely to invalidate the idea.

For logic prototypes, expose transitions and resulting state clearly.

For UI prototypes, make alternatives structurally different enough to reveal real tradeoffs rather than cosmetic preferences.

### 6. Record the Verdict

When the experiment answers the question, record:

- The original question.
- The observed result.
- The decision that follows.
- Any unresolved uncertainty that still requires another experiment.

Do not treat "the prototype runs" as a successful result. Success means the design question became easier to answer.

### 7. Absorb the Decision, Not the Prototype

Move validated ideas into production code using normal production standards.

Do not promote prototype code unchanged. Production implementation should restore the requirements intentionally skipped during exploration, such as tests, validation, error handling, accessibility, maintainable abstractions, and operational safeguards.

Keep prototype artifacts out of the main production path. If the prototype is useful as historical evidence, preserve it on a throwaway branch or another clearly non-production location and link to it from the implementation context.

## Rules

1. **Optimize for learning, not longevity.** Avoid abstractions, extensibility work, generalized configuration, and speculative features.
2. **Keep it obviously disposable.** Use names and locations that clearly identify prototype code.
3. **Avoid persistence by default.** Use in-memory state, fixtures, stubs, or scratch data unless persistence is the question being tested.
4. **Do not perform production side effects.** Never point experimental mutations at production databases, queues, billing systems, email delivery, or other real external effects.
5. **Skip production polish.** Add only enough error handling, responsiveness, accessibility, and visual finish to make the experiment usable for its intended evaluator.
6. **Do not add a normal test suite.** The prototype itself is the experiment. Add automated checks only when the design question specifically concerns executable behavior that cannot be evaluated otherwise.
7. **Expose what changed.** State transitions, outputs, selected variants, and important assumptions must be inspectable.
8. **Prefer existing project conventions.** Do not invent a new framework, routing scheme, build pipeline, or top-level architecture for a temporary experiment.
9. **Keep the experiment reversible.** Removing the prototype must not require untangling production code.

## Validation Loop

Before handing over the prototype, verify:

- The question being answered is visible and specific.
- The chosen prototype type matches the uncertainty.
- The prototype runs with minimal setup.
- No real production side effect is reachable.
- The important state, output, or variant is visible.
- At least one risky or awkward case can be exercised.
- Prototype-only code is clearly isolated from production implementation.
- The user can tell what to inspect and how to compare outcomes.
- There is a clear cleanup path after a decision is made.

If any item fails, simplify or isolate the prototype before adding more features.

## Handoff

Provide the user with:

- The question the prototype is testing.
- The prototype location.
- The exact run or open instruction.
- The scenarios, actions, or variants worth evaluating.
- The current verdict, if already known.
- What should be removed or rewritten after the decision.
