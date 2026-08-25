# UI Prototype

Use a UI prototype when the main uncertainty is visual structure, information hierarchy, navigation, interaction flow, density, or the primary affordance of a page or component.

The goal is comparison. Build several meaningfully different directions that can be inspected in the real application context, then keep the decision and discard the experiment.

Return to [../SKILL.md](../SKILL.md) for the shared prototype rules.

## Preferred Shape

Prefer variants inside an existing page or route whenever a plausible host already exists.

Real application context exposes constraints that isolated mockups hide:

- Existing header and navigation.
- Real page width and density.
- Authentication and route parameters.
- Existing read-only data.
- Nearby controls and competing information.
- Current component and styling conventions.

Create a new throwaway route only when the concept genuinely has no appropriate existing host.

## Process

### 1. State the Design Question

Write one sentence describing what the variants are intended to resolve.

Examples:

- "Which layout makes account risk easiest to scan before approval?"
- "Should configuration use a step-by-step flow or a single dense workspace?"
- "Where should the primary action live when the page contains long supporting content?"

Avoid using "Which version looks best?" as the only criterion. The prototype should compare designs against a specific user or product need.

### 2. Choose the Host

Prefer this order:

1. Existing route and existing data flow.
2. Existing route with a prototype-only subtree.
3. New throwaway route following the project's routing convention.
4. Standalone page only when application context is irrelevant or unavailable.

When using an existing route, keep data loading, auth, route parameters, and other surrounding behavior intact. Swap only the rendering that is actually under evaluation.

When using a new route, name it clearly as a prototype and avoid creating a new top-level architecture for it.

### 3. Choose the Number of Variants

Default to **3 variants**.

Use 2 when the decision is genuinely binary. Use 4 or 5 only when additional directions are materially different and useful. Do not exceed 5 without a specific reason.

More variants are not automatically better. The purpose is to make tradeoffs legible, not to generate a gallery.

### 4. Make Variants Structurally Different

Each variant should disagree about at least one important design decision, such as:

- Page composition.
- Information hierarchy.
- Navigation model.
- Primary action placement.
- Density and grouping.
- Progressive disclosure.
- Relationship between summary and detail.

Do not count color, border radius, shadow, spacing tweaks, or minor copy changes as separate directions.

A useful test is whether an evaluator can explain the difference between variants without mentioning visual styling tokens.

If two variants feel too similar, replace one with a direction that deliberately rejects the shared structure.

### 5. Reuse the Project's Visual Language

Use the project's existing:

- Component library.
- Design tokens.
- Typography.
- Spacing system.
- Icons.
- Styling approach.

The prototype is intended to compare product structure, not introduce a new design system.

Reuse shared primitives where doing so preserves context, but avoid sharing layout abstractions that force all variants into the same shape.

### 6. Keep Data and Mutations Safe

Prefer real read-only data when it helps the design feel realistic and can be accessed safely through the existing page.

For mutations:

- Stub them by default.
- Record intended actions in local prototype state.
- Use fixtures for destructive or irreversible flows.
- Never connect prototype controls to production-side effects.

If the design question specifically concerns mutation behavior, make the effect visible locally rather than performing the real operation unless an isolated scratch environment is explicitly available.

### 7. Make Variants Addressable

Use a stable URL parameter when the application router supports it, for example:

```text
/settings?prototypeVariant=A
/settings?prototypeVariant=B
/settings?prototypeVariant=C
```

Benefits:

- A specific variant can be shared directly.
- Reloading preserves the selected variant.
- Feedback can refer to a stable key.
- Screenshots and review comments remain unambiguous.

Use the project's normal router APIs rather than manually reloading the page.

Keep prototype parameters namespaced enough that they are not confused with production behavior.

### 8. Add a Prototype Switcher

Provide a small control that is visually separate from the design under evaluation.

It should include:

- Previous variant.
- Current variant key and optional short name.
- Next variant.

Useful behavior:

- Previous and next wrap around.
- Switching updates the URL parameter.
- Left and right arrow keys may cycle variants.
- Keyboard shortcuts must not intercept input, textarea, select, or editable-content interactions.
- The switcher remains fixed and easy to find while reviewing long pages.

Keep the switcher implementation shared across variants. It is prototype tooling, not part of any candidate design.

### 9. Prevent Accidental Production Exposure

Use an existing development-only mechanism when the project has one.

Examples include:

- Development environment guards.
- Feature flags scoped to local or preview environments.
- Prototype-only routes excluded from production builds.
- Explicit local configuration.

Do not rely only on the prototype's visual appearance to indicate that it is temporary.

The final cleanup must remove:

- Losing variants.
- Variant-selection logic.
- Prototype-only query parameters.
- Prototype switchers.
- Development-only fixtures created solely for the experiment.

### 10. Hand Off the Comparison

Tell the evaluator:

- Which question the prototype is testing.
- Where to open it.
- Which variant keys exist.
- What meaningful tradeoff each variant represents.
- Which workflows or viewport sizes deserve attention.

Ask for feedback about decisions and tradeoffs rather than generic visual preference when possible.

Useful feedback sounds like:

- "B makes the approval state easier to scan, but C makes history easier to access."
- "The primary action in A is visible too early, before the reviewer has enough context."
- "Use B's information hierarchy with C's detail panel."

That kind of response is evidence the prototype is exposing the right design choices.

### 11. Capture the Decision and Clean Up

Once a direction wins:

1. Record which design decision was selected and why.
2. Reimplement or refactor the selected direction to production quality.
3. Restore normal testing, accessibility, validation, error handling, and maintainability requirements.
4. Remove prototype-only selection infrastructure from the production path.
5. Preserve the experiment only in a clearly non-production location when its history remains useful.

Do not merge the winning prototype unchanged merely because it resembles the desired final UI.

## Existing Route vs New Route

### Existing Route, Preferred

Use an existing page when the prototype modifies or adds something that naturally belongs there.

Keep existing behavior above or around the variant boundary. Conceptually:

```text
route
  load existing data
  keep existing auth and params
  choose prototype variant from URL
  render Variant A, B, or C
  render prototype switcher
```

Only the subtree being evaluated should vary.

### New Throwaway Route

Use a new route when there is no sensible existing host, such as a genuinely new top-level product surface.

Requirements:

- Follow the existing router convention.
- Include `prototype` or another unmistakable marker in the route or filename.
- Reuse the project's shell when useful.
- Keep the route isolated enough to delete cleanly.
- Use the same addressable variant mechanism.

Before creating the route, verify that an existing populated page would not provide a more realistic context.

## Anti-Patterns

- Variants that differ only in color, copy, or spacing.
- Three variations of the same card grid presented as distinct concepts.
- A shared layout abstraction that prevents real structural differences.
- Building an isolated page when a realistic host already exists.
- Connecting experimental controls to real destructive mutations.
- Introducing a second styling system for the prototype.
- Spending time polishing animations before the information hierarchy is resolved.
- Leaving the variant switcher or losing variants in production code.
- Treating the selected prototype as production-ready implementation.

## Validation Checklist

Before handoff, confirm:

- The UI question is specific and visible.
- The prototype uses the most realistic safe host available.
- There are enough variants to reveal a meaningful choice, usually 3.
- Variants differ structurally, not just cosmetically.
- Existing project visual conventions are reused.
- Variant selection is stable and shareable when routing permits it.
- The active variant is obvious.
- No prototype control can trigger unsafe production effects.
- Prototype-only tooling is gated or isolated from production.
- The evaluator knows which tradeoffs to compare.
- The cleanup path is explicit.
