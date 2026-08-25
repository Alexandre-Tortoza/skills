# Using Scripts in Agent Skills

When an agent needs to perform repetitive or complex tasks requiring deterministic logic (e.g., parsing, schema validation, report/chart generation), you should **bundle executable scripts** inside the `scripts/` directory.

---

## 1. Golden Rule: No Interactive Prompts

**HARD CONSTRAINT:** Agents operate in **non-interactive** shell environments.
- Scripts **MUST NEVER** wait for keyboard/TTY input (e.g., `input()`, `[y/N]` confirmations, password prompts).
- If a script requests interactive input, the agent execution process will freeze indefinitely.
- Accept all inputs via command-line arguments (`flags`), environment variables, or input files.

---

## 2. One-Off Isolated Tools

For standard ecosystem CLI tools, instruct the agent to use runners that manage isolated environments without requiring global installation:

- **Python:** `uvx ruff@0.8.0 check .` or `pipx run 'black==24.10.0' .`
- **Node.js / JavaScript:** `npx eslint@9 --fix .` or `bunx`
- **Deno:** `deno run npm:eslint@9`
- **Go:** `go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.0 run`

---

## 3. Self-Contained Scripts with Inline Dependencies

To avoid managing separate dependency files (like `requirements.txt` or `package.json`), use inline dependency metadata directly inside the script:

### Python (PEP 723 via `uv`)
```python
# /// script
# dependencies = [
#     "beautifulsoup4",
#     "pandas",
# ]
# ///

from bs4 import BeautifulSoup
import pandas as pd

print("Script running in an isolated environment managed automatically by uv!")
```
*Agent invocation in `SKILL.md`:*
```bash
uv run scripts/my_script.py
```

### Deno / Bun (TypeScript / JavaScript)
Direct versioned imports:
```typescript
import * as cheerio from "npm:cheerio@1.0.0";
// Script logic...
```

---

## 4. Script Design Principles for AI Agents

1. **Self-Documentation via `--help`:** The agent executes `python scripts/my_script.py --help` to discover usage. Provide concise descriptions and clear usage examples in `--help`.
2. **Actionable Error Messages:** When a script fails, write diagnostic messages to `stderr` explaining what failed, what was expected, and how to fix it.
3. **Structured Output:**
   - Write final structured results (JSON, CSV, Markdown) to `stdout`.
   - Write execution progress, warnings, and diagnostic logs to `stderr`.
4. **Idempotency & Safety Flags:**
   - Support a `--dry-run` flag to preview destructive changes before real execution.
   - Use appropriate exit codes to signal validation failures vs unexpected exceptions.
