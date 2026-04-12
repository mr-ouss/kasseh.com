# Voice Reference for Against Entropy

This skill provides published article excerpts as voice calibration
references. Load this alongside the writing-guide skill when producing
prose drafts.

The purpose is not to copy these passages but to internalize their rhythm,
specificity, and tone. The draft should sound like it was written by the
same person who wrote these.

---

## Reference 1: "The Two Ways Your Data Lies to You"

Published on kasseh.com. This is the benchmark piece for Against Entropy
voice.

### Opening (scene-setting, cognitive dissonance):

> Last week I had lunch with two Snowflake executives. Smart people. Deep
> product knowledge. But when I brought up semantic drift, I watched
> something familiar happen: a slight pause, a careful nod, then a pivot
> to schema evolution features.
>
> This happens every time.
>
> The data industry has spent a decade building sophisticated tooling for
> one type of data failure while almost completely ignoring another. We can
> detect when a column disappears. We cannot detect when its meaning
> changes.
>
> That second problem is the one that actually destroys companies.

**What to internalize:** The opening is a scene, not a claim. It earns the
thesis by showing a moment of cognitive failure in smart people. The short
paragraph "This happens every time." is earned by the scene before it.
The two-sentence contrast ("We can detect... We cannot detect...") lands
because it's specific and parallel.

### Technical specificity (real tools, real columns, real scenarios):

> Syntactic drift is when the structure of your data changes. A column gets
> renamed. A data type shifts from integer to string. A table disappears.
> An API starts returning a new field. These are structural changes to the
> shape of data.
>
> Semantic drift is when the meaning of your data changes while the
> structure stays identical. The column is still called customer_status.
> It still contains strings. But six months ago "active" meant "logged in
> within 30 days" and now it means "has a valid subscription." Same column.
> Same data type. Completely different meaning.

**What to internalize:** Real column names (`customer_status`). Real values
("active"). Real definitions with timelines ("six months ago"). The
explanation is concrete enough that a reader can point to it in their own
warehouse.

### Tool acknowledgment (fair, specific, not dismissive):

> dbt gives you schema tests. You can assert that columns exist, that
> they're not null, that they contain expected values. The newer data
> contracts feature lets you explicitly define the structure your models
> expect and fail builds when upstream changes break that contract. This
> is real progress for structural integrity.

**What to internalize:** Tools named specifically. Features described
accurately. Credit given where due ("This is real progress"). The
dismissal comes later, after the fair hearing.

### The gap statement (earned, not declared):

> All of this is genuinely useful. None of it catches semantic drift.

**What to internalize:** Two sentences. The first validates everything
that came before. The second delivers the thesis. The contrast is
structural (the position of the sentences), not lexical (no "but" or
"however").

### Closing (quiet, confident, memorable):

> The data doesn't break. It just stops being true.

**What to internalize:** No exclamation. No call to arms. A quiet
observation that sticks because it reframes everything the reader just
absorbed. The verb "stops" does the work: it implies a process, not an
event.

---

## Voice Markers to Match

These patterns recur across Quentin's writing and should be present in
any draft:

### Sentence rhythm
Long sentences that build (developing an idea across clauses), followed
by short sentences that land (delivering the payoff). The short sentence
earns its punch from the momentum before it.

### Specificity as authority
Real tool names (dbt, Matillion, Monte Carlo, Fivetran, Airbyte). Real
column names (`customer_status`, `mau`). Real business scenarios with
numbers ("drops 15%"). This specificity signals builder credibility.

### Fair hearing before critique
Tools and approaches get genuine credit before their gaps are identified.
The critique lands harder because the reader already trusts the fairness
of the analysis.

### Tension through structure, not adjectives
The writing doesn't tell you something is "dangerous" or "critical." It
shows you the scenario and lets the danger become obvious. Implicit
tension over explicit alarm.

### Inclusive framing
"We can detect" not "You can detect." "Most companies want a tool" not
"Your company wants a tool." The reader is included in the observation,
not lectured at.

---

## Anti-Patterns to Avoid

These are patterns that would break the voice:

### The vendor pitch
> "Ontology-driven architecture offers a transformative approach to
> ensuring semantic consistency across the enterprise data ecosystem."

This sounds like a whitepaper. No.

### The hot take
> "Semantic layers are dead. Here's what's replacing them."

Clickbait framing. The voice is confident, not performative.

### The lecture
> "You need to understand that semantic drift is fundamentally different
> from syntactic drift. Let me explain why this matters."

Condescending. The reader already knows they're reading. Don't narrate
the explanation.

### The hedge pile
> "It could potentially be argued that in some cases, semantic drift
> might possibly create challenges for certain organizations."

The voice is opinionated. State the claim. Acknowledge the tradeoff.
Do not hedge the claim itself.

### The AI assistant
> "Let's dive into the fascinating world of semantic drift and explore
> how it impacts modern data architectures."

If a sentence could appear in a ChatGPT response to "explain semantic
drift," it does not belong in Against Entropy.
