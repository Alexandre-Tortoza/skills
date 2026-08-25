---
name: agent-skill-creator
description: Create, structure, optimize, and evaluate Agent Skills according to the agentskills.io standard. Use this skill when requested to build a new AI agent skill, write or refine a SKILL.md, optimize skill descriptions for reliable triggering, set up eval test cases, or bundle executable scripts.
license: MIT
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.1"
---

# Agent Skill Creator

An engineering standard and procedural guide for authoring, structuring, optimizing, and evaluating high-performance **Agent Skills**, fully aligned with the official `agentskills.io` specification.

---

## When to Use This Skill

Activate this skill whenever the user's request involves:
1. Creating a new **Agent Skill** from scratch for a specific domain, API, tool, or workflow.
2. Structuring a skill directory (`SKILL.md`, `references/`, `scripts/`, `assets/`).
3. Optimizing the `description` field in the frontmatter to guarantee precise trigger rates.
4. Setting up and running evaluations (*evals*) for output quality and trigger accuracy.
5. Packaging reusable executable scripts in `scripts/` with inline dependency management.

---

## Architecture of an Agent Skill

An Agent Skill is a self-contained, versionable folder containing instructions and resources:

```text
my-skill/
├── SKILL.md       # Required: Frontmatter metadata + Core instructions
├── scripts/       # Optional: Reusable executables and CLI tools
├── references/    # Optional: Detailed documentation, schemas, domain-specific guides
└── assets/        # Optional: Templates, images, static resources
```

### The Principle of Progressive Disclosure
The agent loads context across 3 distinct stages:
1. **Discovery:** At startup, loads only `name` and `description` of all available skills.
2. **Activation:** When a task matches the `description`, the agent reads the full `SKILL.md`.
3. **Execution:** The agent follows `SKILL.md` instructions, reading files from `references/` or executing `scripts/` on demand.

---

## Procedural Workflow for Creating a Skill

### Step 1: Extract Real World Expertise
- **Do not rely solely on general LLM knowledge:** Generic skills yield vague guidelines.
- **Primary sources:** Ground the skill in production code, troubleshooting runbooks, incident logs, team architecture conventions, and Pull Request code reviews.
- **Context filter:** Include **only what the agent would not know on its own**. Omit generic conceptual explanations (e.g., what HTTP or JSON is).

### Step 2: Draft the `SKILL.md`
- **Target size:** Keep `SKILL.md` under **500 lines** and **5,000 tokens**.
- **Recommended structure:**
  - `## Overview & When to Use`: Clear scope and prerequisites.
  - `## Workflow / Procedures`: Sequential operational steps or checklists.
  - `## Gotchas`: Pitfalls and fixes for common mistakes the agent would make without guidance.
  - `## Output Templates`: Expected visual Markdown/JSON formats.
  - `## Validation Loop`: Instructions for the agent to self-verify its work.
- **Deep dives:** If there is extensive API documentation or error tables, move them to `references/*.md` and instruct the agent when to read them in `SKILL.md`.

### Step 3: Bundle Executable Scripts (`scripts/`)
- Move repetitive logic (validations, parsing, report/chart generation) into the `scripts/` directory.
- **CRITICAL CONSTRAINT:** NEVER use interactive prompts (TTY/keyboard). The agent runs in a non-interactive shell, and interactive scripts will freeze.
- Declare inline dependencies (e.g., PEP 723 in Python via `uv` or Deno/Bun imports).
- *See `references/using-scripts.md` for complete guidelines.*

### Step 4: Optimize the Description (`description`)
- The `description` field (max 1024 characters) carries 100% of the responsibility for triggering the skill.
- Write in imperative mode (*"Use this skill when..."*) focusing on user intent.
- Build ~20 test queries (`should_trigger` true/false) and measure trigger performance.
- *See `references/optimizing-descriptions.md` for the optimization loop.*

### Step 5: Run Output Quality Evaluations (*Output Evals*)
- Create test cases in `evals/evals.json`.
- Run each test **WITH** the skill and **WITHOUT** the skill (baseline).
- Verify objective assertions and measure token usage and execution time.
- *See `references/evaluating-skills.md` for the evaluation methodology.*

---

## Reference Documents (Progressive Disclosure)

When creating or refining a skill, refer to the following detailed guides:

- **`references/best-practices.md`**: Authoring practices, control level calibration, context management, and instruction patterns.
- **`references/optimizing-descriptions.md`**: Trigger authoring guide, test query design, and description optimization loops.
- **`references/evaluating-skills.md`**: Test case creation, assertions, LLM grading, and performance benchmarking.
- **`references/using-scripts.md`**: Rules for executable scripts, inline dependencies, and isolated CLI tools.
