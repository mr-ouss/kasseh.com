# Writing Guide for Against Entropy (v2)

This skill defines the voice, structural patterns, and editorial rules for
Quentin Kasseh's blog at kasseh.com and the Against Entropy newsletter.

Load this skill before producing any content artifact: thesis documents,
structural briefs, prose drafts, or edit reports.

v2 (2026-08-04) rewrites the voice rules around three directives from
Quentin: first-person narration everywhere, Hormozi-grade bluntness, and
Koe-grade information density. It also legalizes signature moves from his
published corpus that v1 wrongly banned. Evidence base:
`analysis/voice-fingerprint.md` and `analysis/external-voice-references.md`.

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

## The Narrator Rule (non-negotiable, supersedes everything below)

Quentin is a character in every essay, including the most technical ones.
The analysis is his, the scars are his, the prose must be too.

- Write in first person. "I built", "I watched this fail", "let me tell
  you about", "let me make this concrete". The "Let me" gear-shift is his
  native move: use it to open examples, limitations, and walkthroughs.
- Address the reader directly as "you". Order the reader around when
  walking through steps: "Make coffee. Pour in cream." / "Open Settings.
  Go to Data Controls." / "Pick one business term. Just one."
- Use "I" for experience, stake, and biography. Drop "I think" before
  verdicts: state the verdict. "I think most teams skip this step" is
  weaker than "Most teams skip this step. I watched three do it last year."
- Personal proof beats appeals to authority. "I was Director of
  Engineering at RelationalAI" outranks any Gartner citation. Real
  projects, real table names, real costs in hours or dollars.
- Meta-narration is banned in prose: never "this essay", "the reader",
  "the author", "the section below will show". The narrator talks to the
  reader; he does not narrate the document. (Headers and CTA excepted.)
- Never grant the reader permission to disagree ("the reader is welcome to
  hold the other view"). Make the claim. Handle the objection. Move on.

Target profile, derived from his best published work: 15 to 40 first-person
sentences per 100, 15 to 35 direct-address sentences per 100, in every
essay including technical deep dives.

---

## Voice Calibration

Direct, opinionated, technically grounded. Bourdain's nonchalant confidence
for the scenes, Hormozi's bluntness for the verdicts, Koe's density for the
argument. Ideas build within sentences. Paragraphs stay light. The writing
is observational and aphoristic.

Write for readers already familiar with terms like semantic layer,
ontology, AI debt, agent orchestration, and decision intelligence. These
do not need definition.

### Too formal:
> "Organizations must consider the implications of semantic inconsistency
> across their data infrastructure."

### Too casual:
> "Your data is basically lying to you and nobody's gonna tell you."

(The problem words are "basically" and "gonna". A "Look," opener is fine
and in the published corpus: "Look, I'm not here to tell you to stop using
AI. That ship has sailed.")

### Just right:
> "There are two ways your data can fail you. One is loud. The other is
> silent. The entire data industry has organized itself around the loud
> one.
>
> This is a mistake."

---

## Writing Influences

- **Alex Hormozi**: verdict sentences, zero hedging, personal proof with
  numbers, objection stated then crushed, complexity dismissal
- **Dan Koe**: letter format, one idea per paragraph, reframe chains,
  aphorism landings, transition economy
- **Anthony Bourdain**: scene-setting, a person in the first frame,
  nonchalant confidence
- **Dave McComb**: data-centric architecture, ontologies, the case against
  application-centricity
- **Jason Fried**: direct, contrarian business thinking
- **Frank Slootman**: no-nonsense escalation, bias toward action
- **Tim Urban**: complex concepts through analogy and humor
- **William Zinsser**: remove unnecessary words, no fluff

---

## Language Rules (Non-Negotiable)

### Punctuation
Punctuation goes outside quotation marks (logical/British style).
Correct: "this is correct".  Wrong: "this is incorrect."
No em dashes. Use commas, colons, periods, or parentheses.

### Prohibited
- Meta-narration: "this essay", "the reader", "the author", any sentence
  that narrates the document instead of making the argument.
- Trailing hedges and hedge-parentheticals: "maybe", "perhaps", "IMO",
  "arguably", "it could be argued", "(more often than you'd think)".
  Honest uncertainty is allowed only as a verdict: "I don't know. Nobody
  knows." / "Is it for everyone? No."
- The flabby single-sentence contrast template: "it's not just X, it's Y".
- Cliché collective filler: "nobody talks about", "everyone knows",
  "nobody asks the harder question", "the pattern nobody talks about",
  "here's the uncomfortable truth".
- Invented anecdotes. Composite and anonymize real ones only. (Personal
  proof makes this self-enforcing: only real stories have table names.)
- AI phrases: "leverage", "cutting-edge", "delve", "dive in", "robust",
  "utilize", "landscape", "paradigm shift", "synergy". If a sentence could
  appear in a generic LLM answer, delete it.
- Hyperbole adjectives: "insane", "fantastic", "game-changing". Verdicts
  must be checkable, not loud.

### Explicitly allowed (v1 banned these; his published corpus runs on them)
- **Two-beat parallel verdicts**, his single most recognizable move:
  "The data does not break. It just stops being true." / "It's not. A
  knowledge graph is a pattern." / "The tools got better. The outcomes got
  worse." Two short sentences, parallel shape, second one turns the knife.
- **Fragment triples**: "Not chaos. Not randomness. Just probability." /
  "No recordings. No listeners. No reuse."
- **Staccato runs** when walking the reader through something physical or
  landing a verdict: "Make coffee. Pour in cream. Watch it swirl.
  Beautiful for about two seconds. Then it's brown. Mixed. Done." The test
  is earned momentum, not sentence count.
- **Rhetorical absolutes in verdict position**: "You're not beating those
  odds. Nobody is. Ever." Ban stays only on the lazy filler forms listed
  above.
- **"quietly"** and similar quiet-failure vocabulary. His benchmark piece
  uses it twice.
- **"Look," openers** and honest asides. He is a person, not a whitepaper.

### Preferred Substitutions

| Avoid | Prefer |
|-------|--------|
| leverage | use |
| utilize | use |
| landscape | space, industry, field |
| cutting-edge | new, recent, modern |
| paradigm shift | change, transition |
| "I think X" (before a verdict) | "X." |
| "most people" (unsupported) | a countable population: "of the last five data teams I worked with, four" |

---

## Density Rules (Koe register)

Every sentence advances the argument, reframes the idea, or sets up the
next move. If it does none of those, delete it.

- Paragraphs in running argument: 1 to 3 sentences, under 45 words. Roughly
  60% single-sentence paragraphs in argument sections. Longer paragraphs
  are allowed only for worked examples (a failing pipeline, a real schema,
  a migration story).
- Verdict sentences get their own paragraph. "This is a mistake." never
  hides mid-paragraph.
- Transition economy: no "however", "furthermore", "additionally". Use
  standalone "Because...", "So...", "In other words...", or a short
  question ("Why does this fail?").
- Reframe chains for causal arguments: each sentence hands its object to
  the next as subject. "The pipeline feeds the metric. The metric feeds
  the forecast. The forecast feeds the headcount plan."
- Parallel definition pairs instead of definition sections: "A schema
  describes storage. An ontology describes meaning."
- Concrete triplets to ground abstractions: "dbt marts nobody queries,
  Collibra glossaries nobody reads, LookML nobody trusts."
- Aphorism landings: one standalone quotable line per 100 to 150 words.
  Every major section ends on one.
- Named frameworks as compression handles: coin the term early ("semantic
  drift", "meaning governance"), pay the plain-words definition once,
  spend the token everywhere. Every named abstraction gets one plain
  definition on first use.
- Disbelief pre-emption: after a strong claim, concede the reaction in
  under six words ("This sounds extreme.") and proceed. Never hedge the
  claim itself.

## Bluntness Rules (Hormozi register)

- End evidence blocks with a 3 to 6 word absolute: "The glossary is not
  governance." / "Nobody owns that number."
- Define by fiat when the industry has blurred a term: "A metric is a
  decision rule with a number attached. That's all." Then instances, then
  restate.
- Zero hedging on things actually known from direct experience. Reserve
  uncertainty for genuinely uncertain claims, stated once, plainly: "I
  have seen this fail twice; that is my whole sample."
- Objection handling: quote the objection in the reader's words, answer in
  one line, move on.
- Imperatives ship with a built-in test the reader can run this week:
  "Ask three teams to define churn. Count the answers."
- Complexity dismissal after reducing a vendor-inflated topic to its 2 or
  3 real moving parts: "That's the whole mechanism."
- Load-bearing conclusions under 8 words.
- Do not import: money flexing, hard-sell CTAs, urgency mechanics,
  profanity, gym anecdotes, unsupported universal openers.

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

### 7. The Letter (dispatch format)

For newsletter dispatches and personal essays. Cold-open in first person
("I owe you an email."), talk to the reader as one person, walk through
what happened or what was built, close with what's next. This is the Koe
skeleton: claim about the reader's world up top, argument in the middle,
one operational section at the end.

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

One extended metaphor per essay. Two competing metaphors dilute both.

---

## Formatting Guidelines

### Paragraphs:
- 1 to 3 sentences. One idea per paragraph.
- Verdict lines stand alone.
- Use line breaks to create rhythm and pacing.

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

The vendor is the recurring villain: "problems the vendors won't talk
about", "not from a vendor's sales deck". Anti-vendor skepticism is brand
infrastructure. Fair hearing first, then the knife.

---

## Closing and CTA

End essays with a brief call to action matching the Against Entropy brand:

> "This is the kind of analysis I publish in Against Entropy. If you're
> building data systems and want practical frameworks for problems the
> vendors won't talk about, subscribe below."

Or variations:
> "If you're tired of dashboards that lie to you politely, Against Entropy
> is where I write about the fixes."

One CTA, at the end, quietly. Nothing on kasseh.com is a funnel step.

---

## Pre-Publish Checklist

Before publishing, verify:

- The narrator is present: 15+ first-person sentences per 100, from the
  first section, not just the intro
- Direct address throughout: the reader is "you", ordered around in the
  practical sections
- Opens with a move, not a generic claim; a person or scene in frame one
- Zero meta-narration ("this essay", "the reader", "the author")
- Zero trailing hedges ("maybe", "perhaps", "IMO", hedge-parentheticals)
- Verdict sentences isolated on their own lines
- Paragraphs 1 to 3 sentences in argument sections
- At least one two-beat parallel contrast per major section
- Problem grounded in specific examples (tool names, column names, real
  scenarios); personal proof over cited authority
- Existing tools/approaches acknowledged fairly before critique
- One extended visceral metaphor, introduced, called back, paid off
- Practical exit ramp with a built-in test the reader can run this week
- Every named abstraction defined once in plain words
- Closes with an aphoristic line that reframes the piece
- No em dashes; punctuation outside quotation marks
- No AI-sounding phrases; no hyperbole adjectives
- Reads like Quentin telling you something he knows, not a vendor selling
  and not a ghost-writer summarizing
