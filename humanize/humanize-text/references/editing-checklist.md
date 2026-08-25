# Editing checklist and validation loop

Use this reference before returning a humanized rewrite or writing it back to a file.

## Required process

### 1. Read the complete input

Do not start rewriting after the first obvious AI tell. Read the whole artifact so the edit preserves its argument, chronology, dependencies, terminology, and voice.

Identify:

- factual claims
- names, numbers, dates, quotes, and citations
- explicit uncertainty or hedging
- technical terminology and defined terms
- code blocks, frontmatter, data, link targets, or other content that must not be edited in file mode
- voice markers and deliberate quirks
- clusters of patterns from `references/ai-writing-patterns.md`

### 2. Draft the rewrite

Preserve information while changing shape as needed.

Check that the draft:

- keeps every source-supported claim
- does not add a new factual claim
- preserves the original intent and constraints
- preserves uncertainty instead of resolving it by guesswork
- uses natural sentence-length variation
- prefers direct constructions when they are clearer
- removes filler and fake analysis rather than replacing them with different filler
- keeps useful specific detail
- does not mirror the original paragraph structure merely out of caution
- sounds plausible when read aloud in the intended register

### 3. Run the two-question audit

Ask internally:

`What makes the below so obviously AI generated?`

Answer with the remaining concrete tells, if any. Look for pattern clusters such as promotional vocabulary, repeated rhetorical symmetry, stacked short sentences, generic conclusions, signposting, excessive bolding, formulaic headings, or leftover chatbot correspondence.

Then ask:

`Does the rewrite state any fact, name, number, date, quote, or citation that isn't in the source?`

If yes, remove or replace the unsupported material before continuing. Fabrication is a blocking defect, even when the invented detail sounds reasonable.

### 4. Revise into the final rewrite

Address the audit without flattening the author's voice.

Unless a supplied writing sample overrides the rule, scan the final prose for:

- em dash `—`
- en dash `–`
- double hyphen used as dash punctuation ` -- `

Any remaining dash punctuation means the default rewrite is not complete. Replace it with a period, comma, colon, parentheses, or sentence restructuring.

Do not confuse ordinary compound-word hyphens with dash punctuation.

## Factual preservation checklist

Before finalizing, verify all of the following:

- Every name in the rewrite appeared in the source or explicit user context.
- Every number and measurement appeared in the source or explicit user context.
- Every date and time reference appeared in the source or explicit user context.
- Every direct quote is preserved accurately or intentionally paraphrased without being presented as a quote.
- Every citation that remains refers to the same source as before.
- No new publication, expert, institution, location, causal explanation, motive, biography, or historical detail was invented.
- A vague source claim was not silently converted into a precise unsupported claim.
- Missing information was not filled with stock phrases such as `maintains a low profile`, `likely`, or `it is believed`.
- Source uncertainty remains uncertainty.

If a sentence cannot work without external detail, use the plain supported version, omit it when safe, or ask for missing information only when the larger task cannot proceed without it.

## Meaning preservation checklist

Verify that the rewrite has not changed:

- who did what
- causal direction
- chronology
- scope or exclusions
- modality such as `must`, `should`, `may`, and `can`
- certainty level
- comparison direction
- negation
- attribution
- technical meaning
- legal or policy obligation

A smoother sentence is a regression if it changes meaning.

## Voice checklist

If an author sample exists, compare the final rewrite against it:

- sentence-length distribution is roughly similar
- vocabulary level has not been unnecessarily upgraded
- contractions and formality match
- punctuation habits are recognizably similar
- paragraph rhythm is not artificially uniform
- recurring phrases and deliberate quirks were not scrubbed away
- humor, uncertainty, mixed feelings, asides, and self-corrections survive when they belong to the voice

If there is no sample, use the artifact's native register rather than imposing a generic casual voice.

## Pattern checklist

Confirm that the final rewrite has addressed relevant instances of all 33 pattern families:

1. significance and legacy inflation
2. notability and media-coverage inflation
3. superficial `-ing` analysis
4. promotional language
5. vague attribution and weasel words
6. formulaic challenges and future-prospects sections
7. clustered AI vocabulary
8. copula avoidance
9. negative parallelism and tailing negations
10. rule-of-three overuse
11. synonym cycling
12. false ranges
13. passive voice and subjectless fragments when clarity suffers
14. em/en dash overuse
15. mechanical boldface
16. inline-header vertical lists
17. title-case headings
18. decorative emojis
19. curly quotes when normalization is appropriate
20. chatbot correspondence artifacts
21. knowledge-cutoff disclaimers and speculative gap filling
22. sycophantic tone
23. filler phrases
24. excessive hedging
25. generic positive conclusions
26. uniform compound-word hyphenation
27. persuasive authority tropes
28. signposting and announcements
29. fragmented headers
30. diff-anchored writing outside version-scoped artifacts
31. manufactured punchlines and staccato drama
32. aphorism formulas
33. conversational rhetorical openers

Do not force a change for a pattern that is absent, legitimate in context, part of a quotation or proper name, or established by the author's sample.

## Invocation modes

### Pasted text mode

This is the default when the user supplies text directly in conversation.

Run the full process and return:

1. `Draft rewrite`
2. `Still reads as AI because` with brief bullets, including the factual-invention audit
3. `Final rewrite`
4. optionally, a compact summary of material editing choices

The draft and final rewrite should be complete, not excerpts.

### File mode

Use when the user identifies a file as the object to edit.

Run draft, audit, and final internally. Rewrite the file so the editable prose contains only the final rewrite.

Do not alter:

- YAML or other frontmatter unless the user explicitly asks
- fenced or indented code blocks
- source code
- structured data
- machine-readable configuration
- link destinations or citation targets

Humanize visible prose, headings, comments, descriptions, and surrounding narrative only when they are part of the requested editable content.

In conversation, return a short summary of what changed instead of pasting the full file.

### Embedded mode

Use when another task, tool, or agent calls this skill as a step inside a larger workflow.

Run the same draft and audit internally, then return only the final text. Do not expose audit questions, bullets, draft text, or process commentary to the caller.

## Output quality checks

A successful result should satisfy all of these:

- reads naturally for the target register
- preserves all source-supported information
- contains no fabricated facts
- does not expose chatbot process residue
- removes repeated AI-pattern clusters
- avoids formulaic symmetry and manufactured drama
- preserves meaningful human irregularities
- does not over-edit quotations, titles, proper names, code, or examples
- obeys the no-em/en-dash default unless author calibration overrides it
- ends on substantive content rather than a generic positive send-off

## Failure cases

Revise again if the final text:

- sounds generically casual instead of like the source author
- introduces a specific claim not found in the input
- removes important uncertainty
- loses technical or legal precision
- converts a neutral artifact into opinionated prose
- preserves AI tells only because they were grammatically correct
- removes legitimate human quirks only because they resemble one pattern in isolation
- contains the editor's own offers, praise, disclaimers, or process commentary inside the artifact
