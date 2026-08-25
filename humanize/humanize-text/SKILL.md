---
name: humanize-text
description: Use this skill when the user asks to humanize, naturalize, de-AI, de-robotize, rewrite, edit, review, or polish prose so it sounds genuinely human-written; remove signs of AI-generated writing; match an author's existing voice; or clean AI-style patterns from text, documents, comments, articles, essays, documentation, reports, or generated drafts. Preserve every factual claim, name, number, date, quote, citation, meaning, and constraint from the source. Detect pattern clusters rather than treating polished grammar as proof of AI authorship, and never invent specificity to make prose sound human.
license: MIT
metadata:
  author: alexandre-tortoza
  github: https://github.com/Alexandre-Tortoza
  version: "0.2"
---

# Humanize Text

Edit prose to remove recognizable AI-writing habits while preserving the source's information, intent, register, and authorial voice.

## Core Rules

1. **Preserve information, not structure.** Every factual claim in the source must survive, but paragraphs, sentence order, emphasis, and depth may change. Compress dull material, expand only what the source already supports, and merge or split paragraphs freely.
2. **Never invent facts.** Do not add a fact, name, number, date, quote, citation, source, causal explanation, or concrete detail that is absent from the source or explicit user context. If a vague sentence cannot be made specific from supplied material, keep it plain or remove unsupported content.
3. **Match the author's voice.** A user-provided writing sample outranks default style cleanup. Preserve characteristic vocabulary, punctuation, rhythm, paragraph openings, recurring phrases, deliberate quirks, and register.
4. **Do not flatten legitimate writing.** Perfect grammar, formal vocabulary, mixed registers, dry prose, one transition word, one em dash, one short sentence, or one unsourced claim is not evidence of AI authorship. Look for clusters of tells.
5. **Keep the correct register.** Technical, legal, academic, encyclopedic, and reference prose should remain neutral and plain. Personal, opinion, blog, and essay writing may retain or strengthen personality when the source voice supports it.
6. **Use simple constructions when they are stronger.** Prefer `is`, `are`, `has`, and direct subjects over inflated substitutes, passive constructions, or subjectless fragments when meaning is unchanged.
7. **Remove chatbot residue.** Strip assistant-facing phrases, signposting, sycophancy, unnecessary offers, knowledge-cutoff disclaimers, and generic conclusions when they are not part of the intended artifact.
8. **Do not claim detection certainty.** The patterns in this skill are editing signals, not reliable proof that a human or model authored the text.

## Progressive Disclosure

Read supporting files as follows:

- Read `references/ai-writing-patterns.md` whenever scanning, reviewing, or rewriting prose. It defines all 33 required pattern families and their fixes.
- Read `references/voice-calibration.md` whenever the user supplies a writing sample, asks to preserve a particular voice, or the text contains unusual human stylistic features that may be damaged by normalization.
- Read `references/editing-checklist.md` before returning the result. It defines the draft, audit, final loop, invocation modes, factual-preservation checks, and output contract.

## Workflow

### 1. Resolve the invocation mode

Use the mode implied by how this skill is called:

- **Pasted text:** The user supplied prose directly. Produce the draft, brief audit, and final rewrite.
- **File mode:** The user points to a file. Rewrite only prose in the file and leave code blocks, frontmatter, data, and link targets unchanged. Replace the file content with the final rewrite and report only a short summary in conversation.
- **Embedded mode:** Another task or agent invokes this skill as one step in a larger workflow, such as a PR description, commit message, article, or document. Run the full process internally and output only the final text.

### 2. Calibrate voice

If a writing sample exists, read `references/voice-calibration.md` first and record the observable habits that should survive. Do not "improve" casual wording, unusual cadence, punctuation, or deliberate roughness merely because a cleaner version is possible.

Without a sample, infer the intended register from the artifact and user request. Do not inject first person, humor, opinion, uncertainty, or asides into technical, legal, encyclopedic, or reference prose unless already present or requested.

### 3. Scan for AI-writing patterns

Read `references/ai-writing-patterns.md` and check the text against all 33 pattern families.

Prioritize clusters and repeated habits. Preserve legitimate uses that are contextually justified, especially quotations, titles, proper names, historical text, user-specific phrasing, and examples discussing the pattern itself.

### 4. Produce a draft rewrite

Rewrite the prose while preserving all source-supported information.

The draft should:

- sound natural when read aloud
- vary sentence length without manufacturing drama
- use direct subjects and simple verbs where appropriate
- remove inflated symbolism, promotional language, vague attribution, filler, fake depth, and chatbot framing
- avoid mechanical rules-of-three, synonym cycling, false ranges, formulaic conclusions, and excessive hedging
- retain useful specific and unusual details
- preserve uncertainty when the source is uncertain
- preserve citations and link targets exactly unless the user explicitly asks to edit them

### 5. Audit the draft

Ask these two questions internally:

1. `What makes the below so obviously AI generated?`
2. `Does the rewrite state any fact, name, number, date, quote, or citation that isn't in the source?`

Answer both briefly. Any fabricated specificity is a blocking defect even if it makes the prose sound more natural.

### 6. Produce the final rewrite

Revise the draft to address the audit.

Unless a user-provided writing sample establishes otherwise, the final prose must contain no em dash (`—`) or en dash (`–`). Replace them with a period, comma, colon, parentheses, or a restructured sentence. Also replace double hyphens used as dash punctuation.

Do not mechanically remove normal attributive hyphens such as `high-quality report`; follow the predicate-position guidance in `references/ai-writing-patterns.md`.

Run the validation checklist in `references/editing-checklist.md` before returning or writing the result.

## Output Contract

### Pasted text

Return, in order:

1. a draft rewrite
2. brief bullets identifying what still reads as AI-generated and whether any unsupported fact slipped in
3. the final rewrite
4. optionally, a very short summary of material editing choices

Do not pad the response with generic praise, invitations to continue, or explanations the user did not request.

### File mode

Rewrite the file in place so it contains only the final rewritten content for editable prose. Preserve code blocks, frontmatter, structured data, and link targets. In conversation, return only a short summary of what changed and the resulting file reference.

### Embedded mode

Return only the final rewritten text. Do not expose the draft, audit, process notes, or summary.

## Non-Goals

- Do not fabricate human quirks or factual specificity.
- Do not convert every polished sentence into slang.
- Do not erase meaningful formality, terminology, citations, or technical precision.
- Do not diagnose authorship from isolated stylistic clues.
- Do not inject personality into content whose correct voice is neutral.
- Do not mirror the source's paragraph structure when doing so makes the rewrite less natural.

## Source Basis

The pattern taxonomy is based on Wikipedia's `Signs of AI writing` guidance maintained by WikiProject AI Cleanup and the supplied humanizer reference. Treat the taxonomy as an editing framework, not an authorship detector.
