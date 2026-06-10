# Document Quality — Anti-Slop + Output Calibration

Every document is a credibility signal. If it reads like AI wrote it, it weakens whoever shares it internally.

## Banned Language

- "Seamless", "next-gen", "cutting-edge", "revolutionary", "game-changing", "elevate", "unleash", "empower", "leverage" (as verb)
- "At the end of the day", "in today's rapidly evolving landscape", "in an era of..."
- "Comprehensive solution" — describe what you actually do instead
- "It's important to note that...", "It should be mentioned that..."
- False urgency without data

**Extended AI vocabulary ban** (instant flag per occurrence):
delve, tapestry, landscape (abstract), multifaceted, nuanced, pivotal, realm, robust, testament, transformative, underscore (verb), utilize, whilst, keen, embark, intricate, commendable, meticulous, paramount, groundbreaking, innovative, synergy, holistic, paradigm, ecosystem, Additionally, align with, crucial, enduring, enhance, fostering, garner, highlight (verb), interplay, intricacies, showcase, vibrant, valuable, profound, renowned, breathtaking, nestled, stunning

## Banned Structural Patterns

- Three-bullet feature lists with parallel structure
- Generic CTAs ("Get started today!", "Schedule a demo!")
- "Overview → Features → Benefits → Pricing → CTA" structure
- Round numbers in examples ("99.9%", "10x improvement")

## AI Writing Detection — 24-Pattern Rubric

Score starts at 100. Deduct points for each pattern detected. Multiple occurrences stack up to 2× base penalty. Target: 90+ on all prospect-facing content.

### Content Patterns

| Pattern | Penalty | Example |
|---------|---------|---------|
| **Significance inflation** | -10 | "stands as", "pivotal moment", "indelible mark", "deeply rooted", "setting the stage for" |
| **Undue notability claims** | -5 | Listing media mentions without context. "Leading expert." |
| **Superficial -Account_G analyses** | -8 | "highlighting", "underscoring", "emphasizing", "reflecting", "showcasing", "contributing to" |
| **Promotional language** | -8 | "boasts a", "exemplifies", "commitment to", "vibrant", "rich" (figurative) |
| **Vague attributions** | -8 | "Industry reports", "Experts argue", "Some critics argue" — no specific citation |
| **Formulaic "Challenges and Future"** | -10 | "Despite its X, faces challenges...", "Future Outlook" |

### Language & Grammar Patterns

| Pattern | Penalty | Example |
|---------|---------|---------|
| **AI vocabulary clustering** | -10 | Multiple banned words in same paragraph |
| **Copula avoidance** | -5 | "serves as", "stands as", "represents" instead of simple "is/are/has" |
| **Negative parallelisms** | -5 | "Not only...but...", "It's not just about X, it's Y" |
| **Rule of three overuse** | -8 | Forcing ideas into triple adjectives, triple parallel clauses |
| **Synonym cycling** | -5 | "The CEO... The business leader... The company head..." for the same person |
| **False ranges** | -5 | "From X to Y" where X and Y aren't on a meaningful scale |

### Style Patterns

| Pattern | Penalty | Example |
|---------|---------|---------|
| **Em dash overuse** | -5 | More than 1 em dash per 200 words |
| **Mechanical bold emphasis** | -3 | Bold on every key term |
| **Inline-header vertical lists** | -5 | Every list item starts with bolded header + colon |
| **Title Case headings** | -3 | Capitalizing All Main Words In Every Heading |
| **Emoji decoration** | -5 | Emojis on headings or bullet points |

### Communication Patterns

| Pattern | Penalty | Example |
|---------|---------|---------|
| **Collaborative artifacts** | -10 | "I hope this helps", "Of course!", "Certainly!", "Would you like..." |
| **Knowledge-cutoff disclaimers** | -10 | "As of [date]", "While specific details are limited" |
| **Sycophantic tone** | -8 | "Great question!", "You're absolutely right!" |

### Filler & Hedging

| Pattern | Penalty | Example |
|---------|---------|---------|
| **Filler phrases** | -5 each | "In order to" → "To". "Due to the fact that" → "Because". "At this point in time" → "Now". |
| **Excessive hedging** | -8 | "Could potentially possibly", "might have some effect" |
| **Generic positive conclusions** | -10 | "The future looks bright", "Exciting times lie ahead" |

### Score Interpretation

- **90-100**: Human-sounding. Ship it.
- **70-89**: Minor AI tells. Quick fixes needed.
- **50-69**: Obvious AI patterns. Significant rewrite.
- **0-49**: Full rewrite required.

## What to Do Instead

- Lead with specific numbers from actual data
- Use the prospect's own language
- Write in the tone of a senior consultant, not a marketing copywriter
- Let data carry the argument; minimize adjectives
- Use simple verbs (is, has, does) over elaborate constructions
- Vary sentence rhythm — short punches mixed with longer ones
- Include opinions, not just reporting
- Acknowledge uncertainty when honest, rather than hedging everything

## Output Calibration Dials

### TECHNICAL_DEPTH (1-10)

- 1-3: Headline counts + impact score. No citations. One paragraph per finding.
- 4-6: Finding summaries with source references, severity, remediation direction.
- 7-10: Full citations, precedent references, detailed recommendations, cross-references.

### DATA_DENSITY (1-10)

- 1-3: Executive summary only. Top 3 findings. One page max.
- 4-6: Summary + full findings. Impact by category. 3-5 pages.
- 7-10: Everything: every finding, source, citation, coverage matrix. 10+ pages.

### FORMALITY (1-10)

- 1-3: Conversational, advisory. First person. Plain language.
- 4-6: Professional consultative. Third person. Moderate domain familiarity assumed.
- 7-10: Formal. Passive voice where appropriate. Expert audience. Citation-heavy.

## Defaults

| Document | TECH | DATA | FORM |
|----------|------|------|------|
| Outreach email | 3 | 4 | 3 |
| Champion 1-pager | 5 | 5 | 5 |
| Full proposal | 8 | 9 | 7 |
| Board/exec summary | 2 | 2 | 6 |
| Internal update | 3 | 3 | 2 |
