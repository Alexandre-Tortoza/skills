# Architecture Vocabulary

Use this reference to keep architecture reviews consistent and evidence-driven.

## Module

A **module** is a unit that owns a coherent responsibility and hides decisions from its callers. A module may be a file, package, namespace, class, set of functions, subsystem, or another repository-specific construct. Do not equate module with file count.

A module earns its existence when callers can rely on a smaller, more stable interface than the implementation complexity hidden behind it.

## Interface

The **interface** is the behavior and knowledge a caller must understand to use a module correctly. It includes more than function signatures. It can include sequencing requirements, required state, error conventions, data shapes, lifecycle assumptions, side effects, and configuration rules.

Treat the interface as the primary test surface. Tests that exercise stable behavior through the interface are more valuable than tests that freeze incidental implementation details.

## Implementation

The **implementation** is the complexity hidden behind the interface: orchestration, validation, transformations, dependency interaction, policy, state management, retries, caching, persistence, and other internal decisions.

Implementation complexity is not inherently bad. Complexity becomes expensive when callers must understand or coordinate it themselves.

## Depth

**Depth** compares the value and complexity hidden by a module with the burden of using its interface.

A **deep** module exposes a relatively small interface while hiding substantial useful complexity.

A **shallow** module exposes an interface whose complexity is close to the complexity of the implementation it hides. It often forwards calls, renames data, or divides one concept across several places without reducing what callers must know.

Do not optimize for the smallest possible interface mechanically. An interface must remain explicit enough to preserve important domain concepts and constraints.

## Seam

A **seam** is a deliberate place where one part of the system can vary independently from another. A good seam has a clear ownership reason, not merely a testing reason.

Typical evidence for a real seam includes:

- two or more production implementations;
- one production implementation plus a genuinely useful local or in-memory adapter;
- a stable protocol or infrastructure edge that must be isolated from domain policy;
- an ownership or deployment boundary already present in the system;
- a compatibility contract that changes independently of the implementation behind it.

Do not create a seam only because a mock is convenient.

## Adapter

An **adapter** translates between a module's interface and an external representation or dependency. Adapters should concentrate translation and infrastructure-specific behavior rather than leak it into domain modules.

A useful rule of thumb:

- one adapter can be a hypothetical seam;
- two materially different adapters are evidence that the seam is real.

This is not an absolute law. Repository constraints and domain ownership still decide the design.

## Locality

**Locality** measures how much related knowledge and behavior live together. Good locality means a developer can understand or change one concept without repeatedly jumping across unrelated modules.

Signs of weak locality include:

- one feature change requiring synchronized edits across many files;
- invariants split between callers and callees;
- state transitions partly owned by controllers, helpers, and persistence code;
- repeated mapping or validation at multiple call sites;
- tests reconstructing orchestration because no module owns it.

Deepening should improve locality by moving behavior toward the module that owns the concept, not by creating a miscellaneous utility bucket.

## Leverage

**Leverage** describes how much useful behavior a caller gets from understanding a small interface. A high-leverage module lets many callers use substantial implementation complexity through a stable, compact contract.

Architecture improvements should seek more leverage, not merely fewer lines of code.

## The Deletion Test

Use the deletion test when a module appears shallow:

> If this module disappeared, would the system become conceptually simpler, or would important complexity be forced into callers and duplicated elsewhere?

Interpretation:

- If deletion mostly removes forwarding and moves trivial logic into callers, the module is probably shallow.
- If deletion exposes important policy, invariants, translation, or coordination to multiple callers, the module is probably hiding real complexity and may already be deep.
- If the result depends on future hypothetical use cases, mark the conclusion as speculative rather than treating it as evidence.

The deletion test is diagnostic, not a command to delete code.

## Interface as Test Surface

Prefer tests that verify behavior through the durable interface of a module.

A deepening is usually healthy when it allows tests to:

- exercise one meaningful entry point instead of many helpers;
- assert domain behavior without reproducing orchestration;
- replace a dependency at a real seam instead of mocking internal calls;
- delete tests that existed only because implementation details were public;
- keep integration-sensitive behavior together.

Do not delete valuable fine-grained tests merely to satisfy this principle. Keep tests that protect complex algorithms or important failure cases even when those functions become internal.

## Deepening Heuristics

A deepening candidate is stronger when several of these are true:

- interface surface decreases while behavior remains available;
- callers need less sequencing or coordination knowledge;
- invariants move closer to the state they protect;
- repeated translations or validations become owned by one module;
- multiple callers stop depending on internal details;
- tests move toward a stable behavioral surface;
- a real seam becomes explicit and infrastructure details move behind an adapter;
- future changes in the scoped hot spot are likely to touch fewer places.

A candidate is weaker when it mainly:

- changes names;
- moves files;
- introduces a generic abstraction before a second use exists;
- extracts tiny functions to make unit testing easier;
- adds an interface around a dependency with no meaningful variability;
- replaces repository conventions with a preferred architecture style;
- depends on imagined future requirements.

## Evidence Standard

Use repository evidence before architectural preference.

Strong evidence includes:

- repeated changes across the same group of files;
- recurring defects caused by distributed ownership;
- tests with large setup because callers coordinate internals;
- duplicated orchestration, mapping, validation, or state transitions;
- dependency cycles or illegal dependency direction;
- comments or ADRs documenting known friction;
- concrete compatibility or deployment constraints.

Weak evidence includes:

- file size alone;
- number of classes or functions alone;
- personal preference for a pattern;
- abstract SOLID or clean-architecture arguments without repository-specific consequences;
- hypothetical scale or reuse.

## Language Rules

Use domain vocabulary for domain concepts and this vocabulary for structural analysis.

Prefer statements such as:

- `Order intake is shallow because three callers must coordinate validation, pricing, and persistence.`
- `Deepen the Order module so that callers cross one seam and the orchestration becomes implementation detail.`
- `Locality improves because the invariant and its state move into the same module.`
- `Leverage improves because one interface hides the existing validation and persistence workflow.`

Avoid vague conclusions such as:

- `cleaner architecture`;
- `better separation of concerns`;
- `more maintainable`;
- `follows best practices`.

If those outcomes are claimed, translate them into observable changes in locality, leverage, interface burden, test surface, or dependency direction.
