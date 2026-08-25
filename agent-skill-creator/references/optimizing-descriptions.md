# Optimizing Skill Descriptions

The `description` field in the `SKILL.md` frontmatter carries **100% of the responsibility for triggering** the skill. If the agent fails to understand when to activate the skill from the description, it will never be loaded.

---

## Description Authoring Principles

1. **Imperative Tone:** Write the instruction directed at the agent's decision-making process.
   - *Poor:* "This skill analyzes CSV files."
   - *Good:* "Use this skill when the user requests tabular data analysis (CSV, TSV, Excel), metric computation, or chart generation, even if they do not explicitly mention 'CSV'."
2. **Focus on User Intent:** Describe what problem the user wants to solve, not internal implementation details.
3. **Be Comprehensive and Assertive:** List equivalent terms and scenarios where the skill applies.
4. **Respect Length Limits:** The specification caps the `description` field at **1024 characters**.

---

## Designing Trigger Evaluation Queries (`eval_queries.json`)

To test trigger accuracy, build an `eval_queries.json` file containing ~20 realistic test prompts:

```json
[
  {
    "query": "I have a spreadsheet ~/data/q4.xlsx with revenue in col C and expenses in col D — can you calculate profit margins and highlight values under 10%?",
    "should_trigger": true
  },
  {
    "query": "What is the fastest way to convert this JSON file to YAML?",
    "should_trigger": false
  }
]
```

### Positive Queries (`should_trigger: true`)
- **Language variety:** Formal, casual, typos, and abbreviations.
- **Explicitness:** Some naming the exact tool, others describing the problem without specifying file extensions or tool names.
- **Contextual richness:** Include file paths (`~/Downloads/data.csv`), column names, and real-world task details.

### Negative Queries (`should_trigger: false` / Near-misses)
The best negative tests share keywords with the skill but require a different solution:
- For a CSV analysis skill: *"Write a Python script to parse a CSV and bulk insert into Postgres"* (ETL/Database focused, not analysis/charting).

---

## The Optimization Loop

1. **Train / Validation Split:**
   - **Train Set (~60%):** Used to identify trigger failures and guide description rewrites.
   - **Validation Set (~40%):** Kept untouched to verify generalization without overfitting.
2. **Multiple Runs:** Because LLMs are non-deterministic, execute each query 3 times and calculate the trigger rate.
3. **Description Refinement:**
   - If failing positive queries: The description is too narrow. Expand the scope or add intent synonyms.
   - If firing on negative queries (false positives): Add specificity regarding what the skill **does not** do or clarify boundaries.
4. **Iteration Selection:** Select the candidate description with the highest pass rate on the **Validation** set.
