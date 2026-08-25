---
name: improve-codebase-architecture
description: Use this skill when the user asks to review, assess, improve, simplify, refactor, or redesign an existing codebase's architecture; find architectural friction, shallow modules, poor locality, leaky seams, excessive indirection, or hard-to-test structure; prioritize architecture refactors; or compare before/after module designs. Scope by recent change hot spots unless the user names an area, preserve domain and ADR constraints, produce evidence-backed deepening candidates, and guide the selected refactor without changing code unless asked.
license: MIT
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "1.0.0"
---

# Improve Codebase Architecture

Review an existing codebase for architectural friction and identify focused **deepening opportunities**: changes that reduce interface surface, absorb incidental complexity into stronger modules, improve locality, and make behavior easier to test through stable seams.

The default deliverable is an evidence-backed architecture review, not an implementation. Do not edit production code, rewrite architecture, or create migrations unless the user explicitly asks to implement a selected candidate.

## Core Contract

Use the architecture vocabulary defined in `references/architecture-vocabulary.md` consistently when reasoning about structure:

- **module**
- **interface**
- **implementation**
- **depth**
- **deep** / **shallow**
- **seam**
- **adapter**
- **locality**
- **leverage**

Preserve literal code identifiers and established domain terms when referring to concrete files or symbols. Use the shared vocabulary for the architectural interpretation of those facts.

Prefer evidence from the repository over generic architecture advice. Every candidate must be anchored in concrete files, dependencies, tests, change history, or documented constraints.

## Progressive Disclosure

Read `references/architecture-vocabulary.md` before evaluating candidates. It contains the deletion test, seam rules, test-surface guidance, and the criteria for module depth.

Read `references/html-report.md` only when generating the visual architecture report. It defines the report structure, diagram patterns, and output constraints.

Also inspect repository-local guidance when present, especially:

- `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, or equivalent agent/contributor instructions;
- `CONTEXT.md`, domain glossaries, or ubiquitous-language documentation;
- `docs/adr/`, `adr/`, `decisions/`, or other architecture decision records;
- package or workspace manifests that reveal module ownership and dependency structure.

Repository instructions and accepted ADRs override generic preferences in this skill.

## Workflow

### Phase 1: Establish Scope Before Scanning

Apply YAGNI to the review itself. Deepening is valuable when it reduces the cost of future change, so focus first on code that is changing, painful, or strategically important.

If the user names a module, subsystem, feature, dependency, or pain point, use that as the primary scope. Do not replace their scope with a repository-wide audit unless the evidence requires widening it.

Otherwise, use recent history to find hot spots. A useful default for an active repository is roughly the last 50 non-merge commits, adjusted for repository size and activity.

Useful commands include:

```bash
git log --oneline --decorate --no-merges -n 50
git log --name-only --format= --no-merges -n 50
```

Look for files and directories that recur, areas involved in repeated fixes, and paths where small changes consistently fan out into many modules.

If useful Git history is unavailable, infer scope from the current dependency graph, test layout, TODOs, duplicated orchestration, and repository documentation. State that history-based prioritization was unavailable.

Before deeper inspection, summarize the chosen scope in one or two sentences so the review remains bounded.

### Phase 2: Establish Domain and Decision Constraints

Before proposing structural changes:

1. Read the domain glossary or `CONTEXT.md` if present.
2. Read ADRs that apply to the selected area.
3. Identify public contracts, persistence formats, protocol constraints, framework conventions, and compatibility promises.
4. Identify test boundaries and dependency-injection patterns already accepted by the repository.
5. Record constraints that a candidate must preserve.

Do not re-litigate an ADR merely because a different design is aesthetically cleaner. Surface an ADR conflict only when current code provides concrete evidence that the decision now causes material friction.

If no domain glossary or ADRs exist, proceed without inventing them.

### Phase 3: Explore Architectural Friction

Walk the scoped code organically. Follow control flow, state flow, dependency flow, and tests far enough to understand where complexity actually lives.

Look for evidence such as:

- understanding one domain concept requires bouncing across many tiny modules;
- a module exposes an interface almost as complicated as its implementation;
- orchestration is spread across call sites instead of concentrated behind one interface;
- tests target extracted helpers while integration bugs remain in the callers;
- tightly coupled modules leak assumptions across a seam;
- one conceptual change requires coordinated edits across unrelated files;
- adapters exist without a meaningful seam, or a seam is justified by multiple real adapters but not represented clearly;
- repeated translation, validation, mapping, or state transitions occur outside the module that owns the concept;
- test setup is large because callers must understand implementation details;
- dependency direction forces domain code to know infrastructure details.

Do not treat file count, class count, function length, or dependency count as architectural problems by themselves. They are signals only when they create observable friction.

For every suspected shallow module, apply the **deletion test** from `references/architecture-vocabulary.md`. If removing the module merely moves its complexity into callers without simplifying the system, it is probably shallow. If removal would force important complexity to become duplicated or exposed, the module may already be earning its existence.

### Phase 4: Form and Rank Deepening Candidates

Generate a small set of candidates, normally three to five. Prefer fewer well-supported candidates over a long refactor wishlist.

Each candidate must include:

- **Title**: short name for the deepening move;
- **Evidence**: concrete observations from code, tests, history, or docs;
- **Files**: affected files or modules;
- **Problem**: the architectural friction in current terms;
- **Deepening**: what responsibility moves behind which module or seam;
- **Locality gain**: what related behavior becomes colocated;
- **Leverage gain**: how a smaller interface controls more implementation complexity;
- **Test effect**: how the test surface becomes smaller, more realistic, or more stable;
- **Constraints / risks**: compatibility, migration, performance, ownership, or ADR concerns;
- **Recommendation strength**: `Strong`, `Worth exploring`, or `Speculative`.

Use these strengths consistently:

- `Strong`: repeated or high-cost friction is directly evidenced, the ownership change is coherent, and major constraints are understood;
- `Worth exploring`: evidence is real but the seam, migration cost, or domain ownership still needs validation;
- `Speculative`: the idea is plausible but evidence is weak or depends on assumptions that have not been verified.

Do not propose detailed new interfaces yet. At this stage, describe responsibility movement and the intended seam, not method signatures or complete abstractions.

Reject candidates that are primarily:

- renaming without responsibility change;
- moving files without improving locality;
- introducing an interface with only hypothetical value;
- creating a generic abstraction for one current use case;
- splitting code only to reduce file size;
- adding indirection without hiding meaningful complexity;
- contradicting a binding ADR without evidence strong enough to justify reopening it.

### Phase 5: Produce the Architecture Report

Generate a self-contained HTML report in the operating system's temporary directory. Do not write report artifacts into the repository unless the user explicitly asks to keep them there.

Resolve the temporary directory as follows:

1. `$TMPDIR` when set;
2. `/tmp` on Unix-like systems;
3. `%TEMP%` on Windows.

Use a unique path such as:

```text
<tmpdir>/architecture-review-<timestamp>.html
```

Follow `references/html-report.md` for structure and diagrams.

The report must contain:

- repository and scoped area;
- the evidence used to prioritize the scope;
- one visual card per candidate;
- affected files;
- problem and deepening summary;
- locality, leverage, and test effects;
- before/after visualization;
- recommendation strength;
- ADR or compatibility warning when applicable;
- one clearly identified top recommendation.

Use Mermaid for graph-shaped relationships and inline HTML/CSS/SVG when a custom visual communicates depth or collapse more clearly.

If the environment supports opening files, open the report with the platform-appropriate command. If not, report the absolute path without treating the inability to launch a browser as a failure.

After presenting the report, ask the user which candidate they want to explore. Do not silently choose and implement one.

### Phase 6: Deepen the Selected Candidate

Once the user selects a candidate, run a focused architecture decision workshop before editing code.

Resolve, in order:

1. **Goal**: what future change or current failure mode the deepening should improve.
2. **Ownership**: which module should own the behavior after the change.
3. **Seam**: what must remain externally visible and what should move behind it.
4. **Dependencies**: which dependencies are intrinsic and which should be adapted at the seam.
5. **State and invariants**: which rules must become local to the module.
6. **Test surface**: which tests should survive at the interface and which helper-level tests become unnecessary.
7. **Migration**: how callers move without a risky big-bang rewrite.
8. **Compatibility**: what public behavior, data shape, protocol, or ADR must remain intact.

When the best interface shape is unclear, design at least two materially different options before selecting one. Compare them using interface size, hidden implementation complexity, locality, adapter reality, test surface, migration cost, and repository conventions.

Only after these decisions are explicit should implementation begin.

### Phase 7: Implement Only When Requested

If the user asks to implement the selected refactor:

1. Re-read repository instructions for the affected files.
2. Capture the relevant baseline tests before changing structure.
3. Make the smallest coherent architectural move that realizes the chosen ownership and seam.
4. Preserve behavior unless behavior change is explicitly part of the request.
5. Migrate callers incrementally when possible.
6. Remove obsolete shallow modules only after callers no longer depend on them.
7. Update tests to target the surviving interface rather than re-creating implementation coupling.
8. Run repository-required validation plus targeted tests for the moved behavior.
9. Review the final diff for accidental abstraction growth, dead adapters, duplicated logic, and unrelated cleanup.

Do not mix unrelated style cleanup into an architecture refactor. A smaller diff makes the new seam easier to verify.

If the selected design introduces or materially changes domain terminology, suggest updating the repository's glossary. If a durable architecture decision is made or an existing ADR is intentionally reversed, suggest recording or updating an ADR. Do not create either artifact unless requested or clearly included in the implementation scope.

## Gotchas

- **Recent change is a prioritization signal, not proof.** Hot code can be healthy; cold code can still be strategically critical.
- **Many files do not automatically mean poor locality.** Judge how many places must be understood or changed for one concept.
- **A small interface is not automatically deep.** The implementation must actually absorb meaningful complexity.
- **One adapter may be accidental.** Avoid inventing a seam solely to enable mocking when no real variability exists.
- **Tests can preserve bad architecture.** Do not keep helper seams only because tests were written around them; prefer tests at the durable interface.
- **Framework conventions matter.** Do not fight framework lifecycle or file conventions unless they demonstrably cause the friction being reviewed.
- **Domain language outranks generic architecture vocabulary.** Use domain terms for concepts and the shared vocabulary for structural analysis.
- **ADRs are constraints, not decoration.** Do not propose a forbidden design without identifying the decision and the evidence for reconsideration.
- **Do not confuse extraction with deepening.** Creating more modules often increases interface surface and reduces depth.
- **Do not optimize for diagram beauty.** The report must reflect real code, even when the current structure is messy.

## Output Contract

For a completed review, report concisely:

```text
Scope: <module/subsystem/repository area>
Evidence: <history, files, tests, docs inspected>
Candidates: <count>
Top recommendation: <candidate title>
Strength: <Strong|Worth exploring|Speculative>
ADR conflicts: <none or identifiers>
Report: <absolute path to HTML report>
Next decision: <candidate to explore or unresolved question>
```

When the user requests a text-only review, preserve the same candidate fields and ranking but omit HTML generation and the report path.

When implementation was requested, additionally report:

```text
Implemented: <selected deepening>
Interface impact: <what changed or remained stable>
Callers migrated: <summary>
Tests: <commands and outcomes>
Remaining risks: <none or concise list>
```

## Validation Loop

Before finishing an architecture review:

1. Confirm the scope matches the user's request or is justified by repository evidence.
2. Confirm relevant repository instructions, domain docs, and ADRs were checked when present.
3. Confirm every candidate cites concrete code or repository evidence.
4. Apply the deletion test to each candidate centered on shallow modules.
5. Confirm the proposed deepening reduces interface burden or improves ownership instead of merely moving files.
6. Confirm locality, leverage, and test effects are explicit for every candidate.
7. Confirm recommendation strength matches the evidence quality.
8. Confirm no detailed interface was prematurely invented before candidate selection.
9. Confirm the top recommendation explains why it outranks the alternatives.
10. Confirm the HTML report was written outside the repository unless the user requested otherwise.
11. Confirm no production code or durable project artifact was modified during a review-only request.
12. If implementation was requested, run the relevant tests and review the complete diff before reporting completion.
