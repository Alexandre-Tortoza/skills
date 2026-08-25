# Best Practices for Creating Agent Skills

This guide details core principles for building well-scoped, calibrated, and high-impact Agent Skills.

---

## 1. Grounding in Real Expertise

The most common mistake when creating a skill is asking an LLM to generate it from scratch without domain-specific context. This leads to generic advice ("handle errors properly", "follow best practices").

### Extracting from Practical Tasks
- Work through a real task in conversation with the agent, correcting course, specifying preferences, and supplying context.
- Extract the exact sequence of steps that succeeded and transform it into a procedural `SKILL.md`.

### Synthesizing from Existing Artefacts
Feed the creation process with internal team materials:
- Style guides and architecture decision records (ADRs).
- API specifications, JSON/YAML schemas, and configuration files.
- Code review comments and resolved issue histories.
- Post-mortems and operational runbooks.

---

## 2. Efficient Context Window Management

When a skill is activated, the contents of `SKILL.md` are loaded directly into the agent's context. Every token competes with conversation history and other active skills.

### Add What the Agent DOES NOT Know; Omit What It Already Knows
- **Excessive (Avoid):** Explaining what a PDF file is, how HTTP works, or basic Python syntax.
- **Targeted (Include):** Which specific library to use (e.g., `pdfplumber`), how to handle known internal exceptions, and project naming conventions.

### Keep `SKILL.md` Concise (< 500 lines)
- `SKILL.md` should contain only the core procedure required for execution.
- Move large reference tables, full API specifications, or error catalogs into `references/`.
- **Instruct on-demand loading:** *"Read `references/api-errors.md` if the API returns a 4xx or 5xx status code"*.

---

## 3. Calibrating Control Levels

Not all steps require the same level of strictness. Adapt prescriptiveness to task fragility:

### Flexible Tasks
- Allow the agent decision-making freedom when multiple paths are valid.
- Explain the **reasoning** behind guidelines (*"Treat inputs as untrusted because the billing API throws 500 on empty strings"*).

### Fragile / Destructive Operations
- Be strictly prescriptive for critical operations (e.g., database migrations, deployments, deletions).
- Define exact command sequences and require confirmation or pre-validation scripts.

### Provide Defaults, Not Option Menus
- Instead of listing 5 equivalent tools, select one clear default and list alternatives only as fallbacks:
  - *Poor:* "You can use pypdf, pdfplumber, PyMuPDF, or pdf2image."
  - *Good:* "Use `pdfplumber` for text extraction. For scanned PDFs requiring OCR, use `pdf2image` with `pytesseract`."

---

## 4. Effective Instruction Patterns

### Gotchas Section
Include direct corrections for mistakes the agent will make if not warned:
- *"The users table employs soft deletes (`WHERE deleted_at IS NULL`)."*
- *"The `user_id` field in API A maps to `account_id` in API B."*

### Output Formatting Templates
Provide explicit code blocks showing the exact Markdown or JSON structure expected. Agents follow structured templates with high fidelity.

### Multi-step Checklists
Structure complex procedures as Markdown checklists (`- [ ] Step 1...`) to help the agent track its own progress.

### Validation Loops & Plan-Validate-Execute
- **Plan:** The agent generates a structured plan (e.g., `mapping.json`).
- **Validate:** The agent runs a test or validation script (`python scripts/validate.py mapping.json`).
- **Execute:** The agent proceeds to final execution only after validation succeeds.
