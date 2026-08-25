# Evaluating Skill Output Quality

Once trigger reliability is established, you must evaluate whether the quality of output generated with the skill superior to the baseline agent response without it.

---

## 1. Test Case Structure (`evals.json`)

Store test cases in `evals/evals.json` within the skill directory:

```json
{
  "skill_name": "csv-analyzer",
  "evals": [
    {
      "id": 1,
      "prompt": "I have sales data in data/sales_2026.csv. Find the top 3 months by revenue and generate a bar chart.",
      "expected_output": "A bar chart image displaying the top 3 revenue months with labeled axes and explained values.",
      "files": ["evals/files/sales_2026.csv"],
      "assertions": [
        "Output includes an image file with the bar chart",
        "The chart displays exactly 3 months",
        "Both X and Y axes are clearly labeled",
        "The chart title explicitly mentions Revenue"
      ]
    }
  ]
}
```

---

## 2. Running Evaluations

Run each test case in two configurations to establish a comparative baseline:
- **`with_skill`**: Execution with the agent loading the newly authored skill.
- **`without_skill`**: Execution in a clean context without the skill (or using an older version).

### Evaluation Workspace Layout
```text
csv-analyzer-workspace/
└── iteration-1/
    ├── eval-top-months/
    │   ├── with_skill/
    │   │   ├── outputs/
    │   │   ├── timing.json
    │   │   └── grading.json
    │   └── without_skill/
    │       ├── outputs/
    │       ├── timing.json
    │       └── grading.json
    └── benchmark.json
```

---

## 3. Assertions, Grading, and Benchmarking

### Writing Effective Assertions
- **Good Assertions:** Objective and verifiable (e.g., *"Output file is valid JSON"*, *"Exactly 4 metrics were calculated"*).
- **Poor Assertions:** Vague or subjective (e.g., *"The response is helpful"*).

### Automated Grading
Use deterministic scripts (to validate formats, row counts, exit codes) or a neutral LLM Grader to verify each assertion, recording explicit evidence in `grading.json`.

### Cost & Performance Metrics (`benchmark.json`)
Record total token consumption and execution runtime (`timing.json`). The final benchmark computes:
- **Pass Rate:** % of assertions passed.
- **Delta:** The net gain in success rate relative to added time and token overhead.

---

## 4. Skill Iteration Loop

1. **Failed Assertions:** Directly point to gaps in `SKILL.md` (missing or ambiguous steps).
2. **Execution Traces:** Inspect agent logs. If the agent wasted steps on wrong approaches, simplify instructions or add a helper script in `scripts/`.
3. **Human Inspection:** Verify that output formatting is polished and practical.
4. **Update & Re-eval:** Refine `SKILL.md` or scripts, and execute the next run in `iteration-N+1/`.
