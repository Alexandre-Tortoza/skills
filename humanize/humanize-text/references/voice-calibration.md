# Voice calibration and false positives

Use this reference when a writing sample exists, when the user explicitly asks to preserve their voice, or when the source contains unusual stylistic features that may be genuine human signals.

## Calibrate from a writing sample

A user-provided sample outranks the default style rules in this skill.

Before rewriting, inspect the sample for:

- typical sentence length and how often short sentences interrupt longer ones
- vocabulary level, contractions, slang, jargon, and repeated favorite words
- paragraph length and common paragraph openings
- punctuation habits, including commas, semicolons, parentheses, colons, em dashes, en dashes, ellipses, and quotation marks
- transition habits and whether transitions are explicit or abrupt
- recurring phrases and verbal tics
- deliberate fragments, self-corrections, asides, or uneven rhythm
- heading capitalization and list style
- degree of formality, humor, confidence, uncertainty, or directness

Match those habits rather than merely deleting AI-pattern vocabulary.

Do not upgrade casual words, regularize deliberate quirks, or make every paragraph equally polished. If the sample uses em dashes, en dashes, curly quotes, emojis, title case headings, or another feature normally cleaned by the default rules, preserve that feature at approximately the sample's frequency when it is clearly part of the author's style.

## Personality and soul

Removing AI tells is only half the edit. In voice-driven writing, a sterile rewrite can sound as synthetic as the original.

Apply personality only when the content and author's voice call for it, such as:

- blog posts
- essays
- opinion writing
- personal writing
- commentary
- narrative prose

Do not inject personality into:

- encyclopedic text
- technical documentation
- legal writing
- reference material
- formal policies
- neutral reports whose source voice is impersonal

When personality is appropriate, preserve or allow:

- uneven sentence rhythm
- real opinions already supported by the source
- uncertainty or mixed feelings already expressed
- humor and restrained asides
- self-corrections
- first-person editorial choices
- paragraphs of unequal depth when the subject naturally deserves unequal attention

Personality is not permission to invent facts. A reaction, preference, or stylistic stance may be expressed only when it belongs to the authorial voice or is requested. Do not create a new factual premise merely to make the prose vivid.

## What not to flag by itself

These are weak or invalid authorship signals when isolated. Do not gut legitimate prose because of them.

### Perfect grammar and consistent style

Professional writers and edited publications can be extremely polished. Clean grammar is not evidence of model authorship.

### Mixed casual and formal registers

A writer may switch between technical precision and casual phrasing. This is common in engineering, academic, younger, multilingual, and neurodivergent writing.

### Bland or robotic prose

Dryness alone is not an AI pattern. Rewrite only when specific patterns or the user's request justify it.

### Formal or academic vocabulary

The pattern list identifies words that models overuse in clusters. It does not prohibit sophisticated vocabulary such as `ostensibly`, `constituent`, or domain-specific terminology.

### Letter-style openings or closings

Salutations and sign-offs predate generative AI. Preserve them when the artifact is actually a letter, email, comment, or message that conventionally uses them.

### Common transitions in isolation

One `however`, `additionally`, `moreover`, or `consequently` is ordinary prose. Repetition and clustering are what matter.

### Curly quotes alone

Operating systems, word processors, CMSs, and publishing tools automatically convert straight quotes to curly quotes. Treat typography as evidence only in combination with stronger patterns.

### Em dashes alone

Many human editors and journalists use em dashes heavily. The default no-dash rule exists to normalize model-like output, but an existing dash is not proof of AI authorship. A provided author sample can override the rule.

### One short emphatic sentence

Humans use short sentences for emphasis. Flag manufactured staccato only when several clipped fragments stack together and inflate the tone.

### `Honestly` or `look` in ordinary speech

These words are common in casual writing. The pattern is a theatrical standalone opener such as `Honestly?` followed by a routine reveal.

### Unsourced claims

Most everyday prose is not formally cited. Lack of citations does not prove AI authorship. During rewriting, however, never invent a citation or source to repair an unsupported claim.

### Correct or complex formatting

Templates, visual editors, static-site generators, linters, and documentation systems produce consistent formatting without generative AI.

### Secondhand text

Do not rewrite watched phrases inside quotations, book or article titles, proper names, code, or examples where the phrase itself is being discussed.

## Strong human signals to preserve

These features often contain the author's identity and should make the editor more conservative.

### Specific, unusual, hard-to-fabricate detail

Preserve concrete details such as an exact address, an odd quote, a peculiar description, a specific local reference, or an idiosyncratic anecdote. Models tend to round specifics into generic categories; human writers often retain them.

### Mixed feelings and unresolved tension

Preserve statements that resist a tidy conclusion, for example a writer who thinks something is mostly good but remains bothered by one part and cannot fully explain why.

### Dated or era-bound references

Slang, memes, cultural references, or in-jokes tied to a particular time or community can be genuine voice markers. Do not modernize them unless requested.

### First-person editorial choices the writer could defend

If the prose contains a clear preference, deliberate cut, unusual word choice, or stated editorial decision, retain it unless it conflicts with the user's requested transformation.

### Variety in sentence length

Natural prose often alternates long, medium, and short sentences. Avoid regularizing everything into the same mid-length cadence.

### Genuine asides, parentheticals, and self-corrections

Asides such as `(I keep wanting to say "almost" here, but it really was certain.)` can be strong human signals. Preserve them when they fit the source voice.

### Text known to predate November 30, 2022

Text written before ChatGPT's public launch is, with rare exceptions, not ChatGPT-generated. If the editing goal is merely AI detection, do not label such text as ChatGPT output. It may still be edited for style if the user requests that separately.

## Calibration decision rule

When a default cleanup rule conflicts with a stable, repeated habit in a user-provided sample, follow the sample unless doing so would:

1. change or fabricate facts,
2. violate an explicit user constraint,
3. corrupt code, structured data, citations, or link targets,
4. create ambiguity that was not present in the source.

The goal is to preserve a recognizably individual writer, not force every author into the same generic definition of "human" prose.
