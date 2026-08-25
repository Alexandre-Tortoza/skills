# Architecture Review HTML Report

Use this reference only when the skill is producing its visual report.

The report must be a single HTML file written to the operating system's temporary directory. Keep repository working trees clean unless the user explicitly asks to save the report in the project.

## Technical Constraints

Use:

- Tailwind CSS from the CDN for layout and typography;
- Mermaid 11 from the CDN for dependency graphs, flows, and sequences;
- inline CSS and inline SVG for diagrams where custom geometry communicates module depth better than Mermaid;
- no build step, package installation, framework runtime, or generated asset directory.

A suitable document shell is:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Architecture review: {{repository}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      .arch-seam { stroke-dasharray: 6 5; }
      .arch-deep { border-width: 3px; }
      .arch-muted { opacity: 0.55; }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900">
    <main class="mx-auto max-w-6xl space-y-10 px-6 py-10">
      <header id="summary"></header>
      <section id="candidates" class="space-y-8"></section>
      <section id="top-recommendation"></section>
    </main>
  </body>
</html>
```

The shell is a starting point, not a requirement to reproduce identical styling on every run.

## Report Header

Keep the header compact. Include:

- repository name;
- scoped area;
- review date;
- evidence basis, for example `recent 50 commits + tests + ADR-0004`;
- a small legend for module, seam, leakage, and deepened module when diagrams need it.

Do not add a long architecture essay before the candidates.

## Candidate Card

Render each candidate as one visually separate card containing:

1. short title;
2. recommendation-strength badge;
3. affected files or modules in monospace;
4. concise evidence statement;
5. before/after visualization;
6. one-sentence problem statement;
7. one-sentence deepening statement;
8. locality gain;
9. leverage gain;
10. test-surface effect;
11. risk or constraint note when material;
12. ADR warning when the candidate conflicts with an accepted decision.

Prefer diagrams and compact labels over long prose. The report is for comparison and selection, not for documenting the final implementation design.

## Recommendation Strength

Use exactly:

- `Strong`
- `Worth exploring`
- `Speculative`

Make the badge visually distinct, but do not rely on color alone. Include the text label.

## Diagram Selection

Choose the diagram that best expresses the architectural friction. Do not force every candidate into the same visual pattern.

### Dependency or Call Flow

Use Mermaid `flowchart`, `graph`, or `sequenceDiagram` when the problem is excessive hops, dependency direction, orchestration fan-out, or leakage across a seam.

Example:

```html
<div class="rounded-xl border bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      Caller --> Validate
      Caller --> Price
      Caller --> Persist
      Price --> ExternalPricing
  </pre>
</div>
```

The after view should show the intended responsibility collapse without inventing detailed method signatures.

### Depth Diagram

Use hand-built HTML/CSS rectangles when the point is that interface surface is large relative to hidden implementation.

Represent:

- before: interface and implementation with similar visual weight;
- after: a smaller interface sitting above a visibly larger hidden implementation area.

Label the relationship with `shallow` and `deep` rather than with aesthetic judgments.

### Call-Graph Collapse

Use nested boxes or a simple Mermaid graph when multiple public helpers are effectively one operation.

The after view should group those operations inside one module and show the surviving external interface.

### Distributed Invariant

When an invariant is split across several files, show the state or domain concept in the center and the current owners around it. In the after view, move the invariant logic into the owning module while leaving adapters outside the seam.

### Translation / Adapter Diagram

When transport, persistence, or provider-specific translation leaks inward, show the external representation, adapter, seam, and domain module explicitly. Avoid adding an adapter when the review has not established a real seam.

## Before / After Rules

Each candidate must include both states.

The `before` diagram must reflect the code that actually exists. Do not exaggerate it for rhetorical effect.

The `after` diagram may omit implementation details that are intentionally hidden, but it must preserve known external constraints and dependencies.

Do not draw detailed interfaces before the user selects a candidate. At review time, show responsibility and seam changes only.

## Visual Style

Prefer an editorial technical-review style:

- generous whitespace;
- strong typography hierarchy;
- restrained borders and backgrounds;
- monospace for paths and identifiers;
- one accent treatment for recommendation emphasis;
- explicit warning treatment for ADR or compatibility conflicts;
- responsive two-column before/after layout that stacks on narrow screens.

Keep diagrams legible at laptop width. Avoid tiny labels, dense dashboards, decorative charts, or animation.

## Top Recommendation

End with one larger summary card containing:

- candidate title;
- recommendation strength;
- one or two sentences explaining why it ranks first;
- the main evidence behind the ranking;
- a link or anchor back to the candidate card.

Do not introduce a detailed implementation plan here. The next step is candidate selection and the focused decision workshop.

## Content Quality Rules

Every architectural claim in the report must be traceable to repository evidence.

Use architecture vocabulary precisely:

- module;
- interface;
- implementation;
- depth;
- deep;
- shallow;
- seam;
- adapter;
- locality;
- leverage.

Use literal repository identifiers when naming concrete code. Do not rename an existing `FooService` symbol merely because the structural vocabulary prefers `module`; describe it as the `FooService` module.

Avoid filler such as `cleaner`, `more elegant`, `best practice`, or `better separation` unless the report immediately states the measurable architectural effect.

## Final Checks

Before opening or reporting the HTML file:

1. Verify every candidate has a before and after visual.
2. Verify all listed files exist or are clearly marked as proposed new files.
3. Verify Mermaid syntax is syntactically plausible and identifiers are escaped when needed.
4. Verify the report does not expose secrets, environment values, or private credentials found during repository inspection.
5. Verify the top recommendation matches the ranking in the candidate cards.
6. Verify the file was created in the temp directory unless the user requested another destination.
7. Report the absolute path even when the browser-open command succeeds.
