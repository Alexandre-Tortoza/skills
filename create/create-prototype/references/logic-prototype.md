# Logic Prototype

Use a logic prototype when the main uncertainty is behavior rather than appearance: business rules, state transitions, data modeling, API shape, ordering constraints, or edge cases that are difficult to judge from static code or diagrams.

The default artifact is a small interactive demo that lets a person perform actions and immediately inspect the resulting state.

Return to [../SKILL.md](../SKILL.md) for the shared prototype rules.

## Preferred Shape

Prefer a single self-contained HTML file with inline CSS and JavaScript when the logic can run independently of the application runtime.

This shape is useful because it is:

- Easy to open without installing dependencies.
- Easy to share with developers and non-developers.
- Explicit about actions and state changes.
- Temporary by construction.

If the question fundamentally depends on existing application modules, framework behavior, runtime APIs, or project-only dependencies, use the smallest runnable script or route supported by the existing project instead. Do not reproduce large sections of the application merely to preserve the single-file shape.

## Process

### 1. Make the Question Visible

Show the question at the top of the demo, not only in a source-code comment.

Include enough context for someone opening the prototype later to understand:

- Which model or behavior is under evaluation.
- Which assumption is uncertain.
- What result would be surprising or invalid.

Keep the question narrow. If the demo needs several unrelated questions to justify its controls, split it into separate experiments.

### 2. Isolate the Behavior Under Test

Keep the core logic separate from the UI shell.

Choose the simplest representation that matches the problem:

- **Reducer** for discrete actions applied to a single state value.
- **State machine** when valid transitions depend on the current state.
- **Pure functions** for independent transformations over plain data.
- **Small stateful module or class** only when persistent in-memory state is genuinely part of the model.

The prototype UI may call the logic, but the logic should not depend on DOM elements, button handlers, or rendering details.

A useful test is whether the core logic could be copied into a real module without bringing the prototype page with it. If not, separate the two more clearly.

### 3. Define Representative State

Start from the smallest state that can expose the uncertainty.

Use realistic names and values where they affect reasoning, but avoid recreating the production database or every field in a domain object.

Prefer:

- Plain objects and arrays.
- Small fixtures.
- Deterministic initial state.
- Explicit reset behavior.

Avoid hidden globals and implicit state that make it difficult to understand why an outcome occurred.

### 4. Build Free-Play Controls

Expose one obvious control for each meaningful action.

Examples include:

- Create, approve, reject, cancel, retry.
- Add, remove, reorder, assign.
- Advance, rewind, expire, restore.

After every action, re-render the complete relevant state.

Use domain labels rather than implementation names. Prefer `Approve order` over `dispatch(APPROVE_ORDER)`.

If an action is invalid in the current state, make the outcome visible. Depending on the question, either disable the action with a reason or allow the attempt and show the rejected transition.

### 5. Add Guided Scenarios

Include a few deterministic scenarios for cases that are hard to reason about manually.

A useful minimum is:

1. Happy path.
2. Important edge case.
3. Invalid or contradictory action sequence.

Each scenario should:

- Reset to a known initial state.
- Explain the situation in plain language.
- Provide an ordered sequence of actions.
- Make the expected point of attention clear.

Do not add scenarios only to increase coverage. Every scenario must contribute evidence about the prototype question.

### 6. Surface State Clearly

The evaluator should not need developer tools to understand what happened.

Render important state as labeled fields, tables, timelines, or small structured panels rather than dumping raw JSON as the primary interface.

Raw JSON may be included as a secondary diagnostic view when helpful.

Where useful, highlight:

- The field that changed.
- The transition that just occurred.
- The action that was rejected.
- Derived values affected by the action.

Avoid animation or visual effects that make state changes harder to compare.

### 7. Keep External Effects Fake

Use in-memory behavior by default.

If the model normally sends email, charges a card, publishes a message, writes to a database, or calls another service, represent the effect as visible prototype state such as:

```text
Queued effects:
- invoice.email_requested
- payment.refund_requested
```

Only connect to a scratch resource when the external system itself is the uncertainty being tested. Make scratch resources unmistakably disposable.

### 8. Capture the Result

When the prototype has provided enough evidence, record:

- What behavior was observed.
- Which assumption held or failed.
- Which model or API decision should move forward.
- Which part, if any, deserves a separate experiment.

If the logic shape proved useful, rewrite or transplant the validated idea into production code with normal tests and safeguards. Do not ship the interactive shell.

## Interaction Layout

For a standalone HTML prototype, prefer this vertical structure:

1. Title.
2. Prototype question and short context.
3. Current-state panel.
4. Free-play actions.
5. Guided scenarios.
6. Optional event history or diagnostic output.
7. Reset control.

Keep the styling restrained. The interface exists to make behavior legible, not to answer visual-design questions.

## Anti-Patterns

- Coupling the core logic to DOM APIs.
- Requiring a framework or bundler for logic that could run in one file.
- Recreating production persistence when persistence is not under test.
- Hiding state changes behind console output.
- Adding abstractions for hypothetical future requirements.
- Building a full CRUD application around a narrow state question.
- Treating successful execution as proof that the model is correct.
- Shipping the prototype shell as production code.

## Validation Checklist

Before handoff, confirm:

- The logic question is stated visibly.
- Initial state is deterministic.
- The behavior under test is isolated from presentation code.
- Every meaningful action has an observable result.
- At least one awkward or invalid sequence is exercisable.
- State changes can be understood without developer tools.
- No production side effect can occur.
- Resetting the demo returns it to a known state.
- The evaluator knows what outcome would support or reject the current model.
