# Writing Guide for Against Entropy

This skill defines the voice, structural patterns, and editorial rules for
Quentin Kasseh's blog at kasseh.com and the Against Entropy newsletter.

Load this skill before producing any content artifact: thesis documents,
structural briefs, prose drafts, or edit reports.

---

## Core Identity

**Author:** Quentin Kasseh, founder of Syntaxia
**Newsletter:** Against Entropy
**Persona:** The Data Nomad
**Mission:** Reducing entropy. Organizing data chaos. Grounding knowledge
on business ontologies.

**Positioning:** Practical analysis for tech founders, data engineers, and
entrepreneurs. Problems vendors won't discuss. Builder credibility over
thought leadership polish.

---

## Voice Calibration

The target tone is direct, opinionated, and technically grounded: the
nonchalant confidence of Anthony Bourdain applied to enterprise data. Ideas
build within sentences. Paragraphs develop momentum. The writing is
observational and aphoristic, favoring implicit tension over spelled-out
contrasts.

Write for readers already familiar with terms like semantic layer, ontology,
AI debt, agent orchestration, and decision intelligence. These do not need
definition.

### Too formal:
> "Organizations must consider the implications of semantic inconsistency
> across their data infrastructure."

### Too casual:
> "Look, your data is basically lying to you and nobody's gonna tell you."

### Just right:
> "The data industry has spent a decade building sophisticated tooling for
> one type of data failure while almost completely ignoring another. We can
> detect when a column disappears. We cannot detect when its meaning
> changes."

---

## Writing Influences

Draw from the style and approach of:

- **Dave McComb**: Data-centric architecture, ontologies, the case against
  application-centricity
- **Jason Fried**: Direct, opinionated, contrarian business thinking
- **Frank Slootman**: No-nonsense executive communication, bias toward action
- **Jim Collins**: Research-backed frameworks, disciplined thinking
- **Tim Urban**: Complex concepts made accessible through analogy and humor
- **William Zinsser**: Clear writing, remove unnecessary words, no fluff

---

## Language Rules (Non-Negotiable)

### Punctuation
Punctuation goes outside quotation marks (logical/British style).
Correct: "this is correct".  Wrong: "this is incorrect."

### Prohibited Constructions
- No em dashes. Use commas, colons, periods, or parentheses.
- No negative contrast structures: "it's not X, it's Y." State the point
  directly.
- No generic assumptions about what "everyone" or "nobody" does, thinks,
  or ignores. State observations specifically or leave them out.
- No choppy stacked short sentences. Short punches must be earned by
  surrounding prose.
- No first-person reflective phrases like "keeps coming back to me" in
  professional content. Prefer authoritative, impersonal framing.
- No "you don't have X, you have Y" negative contrast structure.
- Inclusive first-person framing preferred over declarative positioning
  when writing in first person (e.g., "we may be skipping a step" over
  "I think most people are skipping a step").
- No invented personal anecdotes. No projection framing attributed to
  unnamed collectives.

### Prohibited Phrases
Never use: "leverage," "cutting-edge," "delve," "dive in," "robust,"
"rot," "utilize," "landscape," "paradigm shift," "synergy," "quietly,"
"nobody asks the harder question," "the pattern nobody talks about,"
"here's the uncomfortable truth."

### Preferred Substitutions

| Avoid | Prefer |
|-------|--------|
| leverage | use |
| utilize | use |
| landscape | space, industry, field |
| cutting-edge | new, recent, modern |
| rot | degrade |
| paradigm shift | change, transition |

---

## Structural Archetypes

The structure of an essay is part of its argument. Do not default to a
fixed template. Select the archetype that serves the thesis, or blend
archetypes when the argument demands it.

### 1. The Accumulation

Start with one small, specific observation. Add another. And another. The
reader sees the pattern before you name it. By the time you state the
thesis, it feels inevitable rather than declared.

**Reader engagement:** Discovery. The reader is assembling the argument
alongside you.

**Best for:** Naming a problem the industry hasn't articulated yet.

**Demands:** 3-5 specific, concrete observations that independently seem
unremarkable but together form an undeniable pattern. No observation can
be generic. Each must have real tool names, column names, or scenarios.

**Example move:** Three teams, three dashboards, three definitions of MAU.
You don't tell the reader what's wrong. You lay out the scenarios and let
the pattern announce itself.

**Reference writers:** Paul Graham, Jim Collins (the research-first
approach in Good to Great).

### 2. The Inversion

Open by articulating the conventional wisdom generously, even persuasively.
Give the reader a comfortable chair. Then turn it inside out. The structure
mirrors the intellectual move.

**Reader engagement:** Cognitive reversal. The reader's assumptions are
challenged from inside, not outside.

**Best for:** Contrarian takes on industry trends. Responding to Gartner
reports, vendor announcements, or consensus positions.

**Demands:** The conventional view must be genuinely compelling first. If
you straw-man it, the inversion has no force. The pivot must be a single,
clean intellectual move, not a list of objections.

**Example move:** "Decision Intelligence is the right question. The
platforms in the quadrant are the wrong answer." The first half builds the
case for DI. The second half shows why platforms can't deliver it without
semantic foundations.

**Reference writers:** Jason Fried (Rework, most Signal v. Noise essays),
Frank Slootman (Amp It Up).

### 3. The Zoom

Start at the most concrete, granular level. A single column name. A single
Slack message where a PM changed a definition. Then pull back, and pull
back again, until the reader sees the systemic pattern the specific detail
was a symptom of.

**Reader engagement:** Vertigo. The shift in altitude IS the argument.
The reader experiences the same "oh" that happens when you realize one
renamed column broke a reporting chain three teams relied on.

**Best for:** Showing how small technical decisions create large
organizational failures. Connecting micro-level data problems to
macro-level business consequences.

**Demands:** A genuinely specific opening detail (not a generic scenario).
Each zoom level must reveal something the previous level couldn't show.
The final altitude must connect to a thesis that matters beyond the
specific example.

**Example move:** Start with `customer_status` changing meaning in one
Snowflake table. Zoom to three teams using it differently. Zoom to the
executive decision made on corrupted data. Zoom to the architectural
pattern that made this inevitable.

**Reference writers:** Tim Urban (Wait But Why), Michael Lewis (the
specific-to-systemic move in The Big Short).

### 4. The Case File

One story, told with narrative tension. A protagonist (can be unnamed, a
company, a role) encounters a problem, tries the obvious solutions, hits
walls. The analysis emerges from the narrative rather than being overlaid
on it.

**Reader engagement:** Narrative tension. The reader stays because they
want to know what happens. The ideas ride the story.

**Best for:** Making abstract architecture concepts visceral. Showing what
semantic drift costs in human terms, not just technical terms.

**Demands:** A real narrative arc: situation, complication, attempts,
failure or resolution. Can be composited from multiple real experiences
but must feel specific. Never invent details, but can anonymize and
composite real ones.

**Example move:** Instead of explaining what semantic drift is, tell the
story of the quarter it cost a company its forecast accuracy. The
explanation becomes unnecessary because the reader lived it.

**Reference writers:** Michael Lewis (Moneyball, The Big Short), Malcolm
Gladwell (the opening anecdote that IS the thesis).

### 5. The Ratchet

Each section raises the stakes. Section one shows the problem at face
value. Section two reveals it's worse than the reader assumed. Section
three reveals the second-order effects. Section four shows the cost over
time. The piece builds like a pressure cooker. By the time you present
the thesis, the reader has been compressed by accumulating pressure and
is ready for the release.

**Reader engagement:** Escalating discomfort. The reader keeps adjusting
their estimate of severity upward.

**Best for:** "The industry is ignoring something dangerous" pieces.
Arguments where the full scope of the problem is genuinely surprising.

**Demands:** Each escalation must be a real, verifiable step up in
severity, not rhetorical inflation. The pressure must earn its release.
If the thesis doesn't match the pressure built, the piece collapses.

**Example move:** Section 1: semantic drift exists. Section 2: no tool
detects it. Section 3: AI agents will amplify it by orders of magnitude.
Section 4: the organizations deploying agents fastest are the most
exposed. Release: the ontology-first thesis.

**Reference writers:** Frank Slootman (the relentless escalation in Amp
It Up), Dave McComb (the accumulating cost argument in Software Wasteland).

### 6. The Reframe

The entire essay is built around a single intellectual move: showing the
reader that the problem they think they have is actually a different
problem. The structure deliberately lets the reader settle into the
original framing (maybe even reinforces it with evidence), then pivots.
Everything before the pivot was setup. Everything after is the real essay.

**Reader engagement:** The "wrong question" reveal. The reader realizes
they've been solving the wrong problem.

**Best for:** The strongest conceptual pieces. Arguments where the core
insight is that the framing itself is the obstacle.

**Demands:** The original framing must be the one the reader actually
holds. The pivot must be a single, clean moment. Everything after the
pivot must feel like it was hiding in plain sight.

**Example move:** "You think you have a data quality problem. You have a
meaning problem." The first half validates the data quality framing with
real examples. The pivot shows that every example was actually a symptom
of missing semantics. The second half reinterprets everything.

**Reference writers:** Paul Graham ("How to Do Great Work" reframes
ambition), Dave McComb (reframing enterprise data as an architecture
problem, not a tooling problem).

### Blending Archetypes

The best essays often blend: a Zoom opening that feeds into a Ratchet. An
Accumulation that culminates in a Reframe. An Inversion that opens with a
Case File scene. The structural brief should explain why the blend serves
the thesis, not just which labels apply.

---

## Metaphor and Analogy Approach

Use visceral, physical metaphors to make abstract concepts tangible. The
best metaphors:

- Require no technical knowledge to understand
- Reward closer inspection
- Can be extended and called back throughout the piece
- Create cognitive dissonance (everything looks fine, but something is wrong)

### How to use metaphors:

1. **Introduce** with full detail early in the piece
2. **Callback** with brief references to reinforce
3. **Extend** to show the concept in action
4. **Payoff** by showing how the solution resolves the metaphor

---

## Formatting Guidelines

### Paragraphs:
- Keep paragraphs short (2-4 sentences typical)
- One idea per paragraph
- Use line breaks to create rhythm and pacing

### Headlines and Subheads:
- Clear, descriptive section headers
- Headers should work as a standalone outline of the argument
- Avoid clever/cute headers that obscure meaning

### Emphasis:
- **Bold** for key terms on first introduction
- `code formatting` for column names, functions, technical terms
- *Italics* sparingly for subtle emphasis or internal voice

### Lists:
- Use sparingly and only when structure genuinely helps
- Prefer prose for nuanced explanation

---

## Syntaxia Thesis (Apply When Relevant)

Syntaxia's core position: ontology and business meaning must be defined
before data is connected or automated. AI can infer definitions with user
approval, reducing the burden of ownership. This nuance matters.

When writing on Syntaxia's behalf, ontology is grounded in business meaning
first; data maps to it. Framing ontology as derived from data patterns
inverts the thesis and must be avoided.

The "meaning tax" / "renting your own meaning back" framing connects
platform data lock-in to institutional ontology capture. This framing has
resonated and can be referenced.

---

## Closing and CTA

End essays with a brief call to action matching the Against Entropy brand:

> "This is the kind of analysis I publish in Against Entropy. If you're
> building data systems and want practical frameworks for problems the
> vendors won't talk about, subscribe below."

Or variations:
> "If you're tired of dashboards that lie to you politely, Against Entropy
> is where I write about the fixes."

---

## Pre-Publish Checklist

Before publishing, verify:

- Opens with a move, not a generic claim
- Problem is grounded in specific examples (tool names, column names, real scenarios)
- Existing tools/approaches acknowledged fairly
- The thesis is defensible (survived adversarial pressure)
- At least one visceral metaphor grounds the concept
- Practical alternatives offered for readers who can't go all-in
- Closes with a memorable line or provocative question
- No em dashes
- No AI-sounding phrases
- No negative contrast structures
- No generic "everyone" / "nobody" claims
- No invented anecdotes
- Punctuation outside quotation marks
- Reads like a smart colleague explaining, not a vendor selling
