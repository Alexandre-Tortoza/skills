# AI-writing pattern reference

Use this reference whenever reviewing or rewriting prose with the `humanize-text` skill. Scan for clusters, not isolated words. A single occurrence is rarely enough to justify rewriting.

## Content patterns

### 1. Undue emphasis on significance, legacy, and broader trends

Watch for phrases such as `stands as`, `serves as`, `testament`, `reminder`, `vital`, `significant`, `crucial`, `pivotal`, `key role`, `key moment`, `underscores`, `highlights its importance`, `reflects broader`, `symbolizing`, `enduring`, `lasting`, `contributing to`, `setting the stage`, `marking`, `shaping`, `represents a shift`, `turning point`, `evolving landscape`, `focal point`, `indelible mark`, and `deeply rooted`.

Problem: AI prose often inflates ordinary facts by asserting that they symbolize, shape, or prove a much broader trend.

Fix: state the concrete fact and retain broader significance only when the source itself supports that relationship.

Example:

Before: `The institute was established in 1989, marking a pivotal moment in the evolution of regional statistics.`

After: `The institute was established in 1989 as part of the decentralization of administrative functions.`

### 2. Undue emphasis on notability and media coverage

Watch for source lists used only to prove importance, claims such as `independent coverage`, `national media outlets`, `written by a leading expert`, or `active social media presence`.

Problem: AI prose often lists outlets, followers, or coverage as a substitute for explaining what was actually notable.

Fix: keep only coverage that carries relevant context. If the source supplies what someone said and where, keep that. Do not invent context to justify a citation.

### 3. Superficial analysis with `-ing` endings

Watch for trailing participial phrases such as `highlighting`, `underscoring`, `emphasizing`, `ensuring`, `reflecting`, `symbolizing`, `contributing to`, `cultivating`, `fostering`, `encompassing`, and `showcasing`.

Problem: AI prose often appends an `-ing` phrase that pretends to add interpretation without adding evidence.

Fix: remove the fake analysis or convert source-supported meaning into a direct clause.

### 4. Promotional and advertisement-like language

Watch for `boasts`, `vibrant`, figurative `rich`, `profound`, `enhancing`, `showcasing`, `exemplifies`, `commitment to`, `natural beauty`, `nestled`, `in the heart of`, figurative `groundbreaking`, `renowned`, `breathtaking`, `must-visit`, and `stunning`.

Problem: neutral subjects, especially places and heritage topics, are frequently rewritten as tourism or marketing copy.

Fix: replace promotional framing with plain description unless the promotional claim is itself sourced and relevant.

### 5. Vague attributions and weasel words

Watch for `industry reports`, `observers have cited`, `experts argue`, `some critics argue`, `several sources`, and `several publications` when no specific source is named.

Problem: vague authorities make unsupported claims look sourced.

Fix: name a real source when one is provided. Otherwise remove the attribution or cut the unsupported claim. Never invent a source.

### 6. Outline-like "challenges and future prospects" sections

Watch for formulaic sections such as `Challenges`, `Challenges and Legacy`, `Future Outlook`, `Despite its... faces several challenges`, and `Despite these challenges... continues to thrive`.

Problem: AI prose often adds generic challenge and optimism sections that say little.

Fix: keep concrete, sourced problems and plans. Remove generic framing and upbeat send-offs.

## Language and grammar patterns

### 7. Overused AI vocabulary

High-frequency terms include `actually`, `additionally`, `align with`, `crucial`, `delve`, `emphasizing`, `enduring`, `enhance`, `fostering`, `garner`, `highlight` as a verb, `interplay`, `intricate`, `intricacies`, adjective `key`, abstract `landscape`, `pivotal`, `showcase`, abstract `tapestry`, `testament`, `underscore` as a verb, `valuable`, and `vibrant`.

Problem: these words are not forbidden individually, but repeated co-occurrence makes prose feel model-generated.

Fix: use simpler, more specific wording when meaning is unchanged. Do not flatten legitimate technical or academic vocabulary merely because it is formal.

### 8. Avoidance of `is` and `are`

Watch for `serves as`, `stands as`, `marks`, `represents`, `boasts`, `features`, and `offers` when a simple copula or `has` states the fact more directly.

Problem: AI prose often avoids basic verbs to sound elevated.

Fix: prefer `is`, `are`, or `has` when they are clearer.

### 9. Negative parallelisms and tailing negations

Watch for `not only... but...`, `it's not just about..., it's...`, `not merely...`, and clipped endings such as `no guessing`, `no wasted motion`, or similar slogan-like negations.

Problem: these constructions are often used for manufactured emphasis.

Fix: state the positive claim directly. Convert a tailing negation into a real clause when the information matters.

### 10. Rule-of-three overuse

Problem: AI prose repeatedly groups ideas into threes to simulate completeness or rhythm.

Fix: keep the natural number of ideas. Split or combine them according to meaning rather than forcing a three-part cadence.

### 11. Elegant variation and synonym cycling

Problem: models often avoid repeating the same noun by cycling through synonyms such as `protagonist`, `main character`, `central figure`, and `hero`.

Fix: repeat the precise noun when repetition is clearer. Merge redundant sentences rather than renaming the same thing.

### 12. False ranges

Watch for `from X to Y` when X and Y are not ends of a meaningful scale, sequence, geography, or chronology.

Problem: AI prose uses range syntax as rhetorical decoration.

Fix: list the actual topics or stages directly.

### 13. Passive voice and subjectless fragments

Watch for actorless statements and fragments such as `No configuration file needed` or `The results are preserved automatically` when the actor can be stated naturally.

Problem: subjectless and passive phrasing can make prose vague or mechanically concise.

Fix: use an explicit subject and active voice when it improves clarity, for example `You do not need a configuration file` or `The system preserves the results automatically`.

## Style patterns

### 14. Em dashes and en dashes

Default rule: the final rewrite contains no em dash (`—`) or en dash (`–`). Also remove double hyphens used as dash punctuation.

Preferred replacements, in order: period, comma, colon, parentheses, or sentence restructuring.

Exception: if a user-provided writing sample uses em or en dashes as part of the author's normal style, the sample outranks the default ban. Match roughly the sample's frequency instead of deleting them mechanically.

Before final output, scan explicitly for `—` and `–`.

### 15. Overuse of boldface

Problem: AI output frequently bolds terms and mini-headings mechanically.

Fix: remove emphasis that does not materially help comprehension. Preserve bold only when the artifact convention or source requires it.

### 16. Inline-header vertical lists

Watch for lists where every item starts with a bold label and colon, such as `**Performance:** ...`, `**Security:** ...`.

Problem: AI prose often converts ordinary paragraphs into a stack of mini-sections.

Fix: use normal prose or a simpler list when the items truly need list structure.

### 17. Title Case in headings

Problem: model-generated headings frequently capitalize every major word.

Fix: prefer sentence case unless the user's style, publication, language, or documentation convention calls for title case.

### 18. Emojis

Problem: AI often decorates headings, bullets, and status lines with emojis that were not requested.

Fix: remove decorative emojis unless they are part of the author's established voice or required destination format.

### 19. Curly quotation marks

Problem: curly quotation marks can be a model-output tell when combined with other patterns.

Fix: default to straight quotes (`"`) when normalizing AI-like output, unless the user's style or destination typography prefers curly quotes. Do not treat curly quotes alone as evidence of AI authorship.

## Communication patterns

### 20. Collaborative communication artifacts

Watch for `I hope this helps`, `Of course`, `Certainly`, `You're absolutely right`, `Would you like`, `Want me to`, `Should I continue`, `let me know`, and `here is a...` when those phrases were accidentally pasted into the intended content.

Problem: assistant-user interaction residue survives into the artifact.

Fix: remove the conversational wrapper and keep the actual content.

### 21. Knowledge-cutoff disclaimers and speculative gap filling

Watch for `as of [date]`, `up to my last training update`, `while specific details are limited`, `based on available information`, `not publicly available`, `maintains a low profile`, `keeps personal details private`, `prefers to stay out of the spotlight`, `likely`, `it is believed that`, and similar phrases.

Problem: models either expose knowledge limitations or fill missing biographical and factual gaps with plausible-sounding speculation.

Fix: state only what the source establishes. If a fact is unknown, say it is not documented when that fact itself matters, otherwise omit the sentence. Never convert uncertainty into a guess.

### 22. Sycophantic or servile tone

Watch for `Great question`, `You're absolutely right`, `That's an excellent point`, and similar approval language.

Problem: praise directed at the reader becomes content or weakens a neutral explanation.

Fix: state the relevant point directly.

## Filler and hedging

### 23. Filler phrases

Prefer direct equivalents:

- `In order to achieve this goal` -> `To achieve this`
- `Due to the fact that` -> `Because`
- `At this point in time` -> `Now`
- `In the event that` -> `If`
- `has the ability to` -> `can`
- `It is important to note that the data shows` -> `The data shows`

Do not shorten a phrase when doing so changes legal, technical, or rhetorical meaning.

### 24. Excessive hedging

Problem: stacked qualifiers such as `could potentially possibly`, `might perhaps`, or repeated distancing language dilute a claim.

Fix: preserve the correct uncertainty level with the minimum wording needed, for example `may affect` instead of `could potentially possibly affect`.

### 25. Generic positive conclusions

Watch for vague endings such as `the future looks bright`, `exciting times lie ahead`, `continues its journey toward excellence`, and `a major step in the right direction`.

Problem: AI often appends an upbeat conclusion unsupported by new facts.

Fix: cut the paragraph and end on the last concrete fact, or retain real future plans only when the source states them.

### 26. Hyphenated word-pair overuse

Watch compounds such as `third-party`, `cross-functional`, `client-facing`, `data-driven`, `decision-making`, `well-known`, `high-quality`, `real-time`, `long-term`, and `end-to-end`.

Problem: AI tends to hyphenate these uniformly even in predicate position.

Fix: keep conventional attributive hyphens, for example `a high-quality report`; often drop them after the noun, for example `the report is high quality`. Follow the destination's style guide when one exists.

### 27. Persuasive authority tropes

Watch for `The real question is`, `at its core`, `in reality`, `what really matters`, `fundamentally`, `the deeper issue`, and `the heart of the matter`.

Problem: these phrases manufacture a reveal or claim authority without adding precision.

Fix: state the concrete claim directly.

### 28. Signposting and announcements

Watch for `Let's dive in`, `Let's explore`, `Let's break this down`, `Here's what you need to know`, `Now let's look at`, and `Without further ado`.

Problem: the prose announces the explanation instead of giving it.

Fix: begin with the substantive statement.

### 29. Fragmented headers

Pattern: a heading is immediately followed by a one-line paragraph that merely restates the heading, then the real explanation begins.

Fix: delete the rhetorical warm-up and start with the meaningful content.

### 30. Diff-anchored writing

Problem: documentation and comments often narrate what changed in a patch instead of describing the current system. This makes the text depend on commit context.

Fix: for stable documentation, describe how the system works now. Keep change-oriented narration only in inherently version-scoped artifacts such as changelogs, release notes, migration guides, or PR descriptions.

### 31. Manufactured punchlines and staccato drama

Problem: multiple short declarations or fragments are stacked to make every line sound quotable or dramatic.

Fix: combine related ideas into natural sentences. One short emphatic sentence can be legitimate; repeated dramatic fragments are the tell.

### 32. Aphorism formulas

Watch formulas such as `X is the Y of Z`, `X becomes a trap`, `X is not a tool but a mirror`, `the language of`, `the currency of`, and `the architecture of` when used metaphorically without added precision.

Problem: the sentence sounds profound but often hides an ordinary claim.

Fix: replace the aphorism with the concrete observation it is trying to express.

### 33. Conversational rhetorical openers

Watch standalone hooks such as `Honestly?`, `Look,`, `Here's the thing`, `The thing is`, `Let's be honest`, and `Real talk` when they introduce an ordinary point through a fake candid pause.

Problem: the theatrical opener manufactures intimacy.

Fix: state the point directly. Do not flag ordinary mid-sentence uses of words such as `honestly` or `look`.

## Pattern interaction rule

Never treat one stylistic feature as a verdict. Strong evidence is a cluster such as repeated em dashes plus rule-of-three structure plus promotional vocabulary plus generic conclusion plus chatbot signposting. The purpose of this taxonomy is to guide editing decisions, not classify authorship.
