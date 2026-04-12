# Structural Brief: Closed-World vs. Open-World Ontologies

## 1. Archetype Selection

**Primary: Reframe, with a Ratchet spine in the second half.**

The thesis makes a single, clean intellectual move: the word "ontology" conceals a choice most teams have never consciously made, and that hidden choice breaks at integration boundaries. This is a Reframe. The reader enters thinking ontology is a vocabulary problem (or a vendor choice, or a tooling category). The essay shows that ontology is actually a *completeness assumption* problem, and the completeness assumption is the thing no one is surfacing.

The Reframe is the right primary archetype because the thesis depends on the reader seeing the same word differently by the end. The pivot moment, where the reader realizes that every system they run has already made the CWA/OWA choice for them, is the essay's center of gravity. Everything before the pivot is setup. Everything after is reinterpretation.

Once the reframe lands, the stakes escalate naturally (single-system to multi-system to AI agents), so the second half borrows the Ratchet's escalation spine.

## 2. Reader Journey

The reader enters believing that "ontology" is a category they either use or do not use, a tooling decision about knowledge graphs and semantic layers. By the midpoint, they realize that every database they operate already embodies an ontological assumption about completeness, one they never chose. By the time AI agents enter the picture, the reader understands that this unchosen assumption is about to be amplified across dozens of data sources with no mechanism for declaring where certainty ends. The closing line lands because the reader can now hear the question they should have been asking their vendors all along: when a query returns nothing, does that mean "no" or "we haven't looked"?

## 3. Section Design

### Section 1: The Same Question, Two Answers
- **Purpose:** Ground the CWA/OWA distinction in a single, visceral scenario the reader can feel before they understand it conceptually. Establish cognitive dissonance: two systems, same query, contradictory conclusions, both "correct".
- **Archetype function:** Reframe: setup. The reader sits in a concrete problem before the essay names the abstraction underneath it.
- **Specificity requirements:** The `customer_status` / `active_customers` table example. Two systems: one where absence means "inactive" (CWA), one where absence means "unknown" (OWA or stale sync). Specific column name, specific staleness window (48-hour sync lag), and the downstream business conclusion that diverges. One system says "this customer churned." The other says "we don't know."
- **Tension level:** Medium. Dissonance, not alarm.
- **Estimated length:** 3-4 paragraphs.

### Section 2: The Assumption Your Database Already Made
- **Purpose:** Name the CWA/OWA distinction formally. Explain what closed-world and open-world assumptions are with precision but without academic heaviness. Show the reader that SQL, dbt, and BI tools all operate under CWA by default, and that this is a *design feature* within a scoped system of record.
- **Archetype function:** Reframe: deepening the setup. The reader learns the vocabulary for the dissonance they just felt. Crucially, CWA is presented as correct and useful within its scope.
- **Specificity requirements:** SQL LEFT JOIN NULL semantics vs. OWL open-world property absence. dbt's `ref()` and `source()` as implicit CWA (if a model is not defined, it does not exist). The OWL contrast: an instance without a property means unknown, not absent. Schema.org designed under OWA but Google Rich Results validating it under CWA. Introduce the map metaphor: a SQL database is a map with no border drawn.
- **Tension level:** Low-Medium. Instructive.
- **Estimated length:** 5-6 paragraphs.

### Section 3: Where Completeness Ends
- **Purpose:** The pivot section. Show that CWA is correct within a system of record but breaks at every integration boundary. The reader's mental model shifts: the problem is not CWA vs. OWA as a binary choice, but the absence of any mechanism for declaring where one ends and the other begins.
- **Archetype function:** Reframe: the pivot.
- **Specificity requirements:** The M&A scenario (Company A + Company B, overlapping customer domains, false negatives from CWA assumptions post-merger). The LCWA concept in plain language (the union of closed worlds preserves CWA only when domain boundaries are non-overlapping and visible). Data mesh and cross-account sharing (Snowflake Horizons, Databricks Unity Catalog) as integration patterns that multiply boundaries. The vendor positioning gap: Stardog, Neo4j, Atlan marketing "ontology" without specifying world assumption. Map metaphor callback: two maps being overlaid, neither shows its borders.
- **Tension level:** High. This is where the reader's assumptions crack.
- **Estimated length:** 5-6 paragraphs.

### Section 4: Agents Inherit What You Never Declared
- **Purpose:** Ratchet the stakes from cross-boundary integration to AI agents. Show that agents do not formally inherit CWA or OWA from their sources, and that informal mitigations (system prompts, tool descriptions) do not scale.
- **Archetype function:** Ratchet: escalation step. Peak tension.
- **Specificity requirements:** GraphRAG as implicit CWA (entity missing from unindexed document treated as non-existent). Tool-count trajectory: "today it's 8 data sources connected to your agent layer, next year it's 25." System prompt fragility argument. OpenAPI `x-` extension fields as informal signals that do not scale. **Must acknowledge OWA failure modes:** an open-world system that never commits to completeness produces an agent that hedges everything and is useless. The answer is not "switch everything to OWA." The answer is "declare your completeness boundaries." Map metaphor callback: a navigator using 8 maps from 8 cartographers, none of whom drew their borders.
- **Tension level:** Peak.
- **Estimated length:** 5-6 paragraphs. (OWA failure mode = 2-3 sentences, not a subsection.)

### Section 5: Industries That Already Solved This
- **Purpose:** Release valve. After peak tension, show that this is not theoretical. Healthcare and life sciences have made CWA/OWA management explicit and operational.
- **Archetype function:** Ratchet: pressure release with a twist. Proof the solution exists elsewhere reframes the problem as organizational will, not technical impossibility.
- **Specificity requirements:** SNOMED CT, HL7 FHIR binding strengths, FDA-mandated pharmaceutical ontologies. Brief, concrete.
- **Tension level:** Medium. Relief from peak, but implication sustains pressure.
- **Estimated length:** 2-3 paragraphs. Deliberately short.

### Section 6: What You Can Do Monday Morning
- **Purpose:** Practical takeaways. Give the reader actions they can take without a multi-year transformation.
- **Archetype function:** Resolution. The Ratchet built pressure; this section channels it into action.
- **Specificity requirements:** Four concrete actions:
  1. Audit integration seams (spreadsheet exercise listing cross-boundary queries and authority gaps).
  2. Add completeness declarations to dbt models via `meta` config (exact YAML snippet: `completeness: closed`, `domain_boundary`, `last_verified`).
  3. Tag agent tool schemas with `completeness_scope` field.
  4. The vendor question with plain-language translation: "When a query returns no results, does that mean the thing doesn't exist, or that your system doesn't know about it?"
- **Tension level:** Low. Practical, grounded, forward-looking.
- **Estimated length:** 5-6 paragraphs.

### Section 7: Closing
- **Title:** (No header. Final 2-3 paragraphs set apart.)
- **Purpose:** Land the thesis as a quiet observation. Callback to the opening scenario.
- **Archetype function:** Reframe: payoff.
- **Specificity requirements:** Callback to the opening query that returned two answers. The closing provocation: every database you run already has an ontology; the question is whether "not in the table" means "false" or "we haven't looked yet".
- **Tension level:** Low. Quiet. Confident.
- **Estimated length:** 1-2 paragraphs.

## 4. Metaphor Plan

**Metaphor: The map and the edge of the map.**

Old cartographers drew the known world and then, at the edges, wrote "Here be dragons" or left the space blank. A closed-world map says: "This is all there is. Beyond this border, nothing." An open-world map says: "This is what we've charted. Beyond this border, we don't know." The danger is a map that has no border drawn at all, so the reader of the map cannot tell whether the blank space means "empty" or "uncharted."

- **Introduced:** Section 2, after explaining CWA and OWA formally.
- **Called back:** Section 3. The M&A scenario is two maps being overlaid with no visible borders.
- **Called back:** Section 4. An AI agent is a navigator using 8 maps from 8 cartographers, none of whom drew their borders.
- **Pays off:** Section 7. The industry is building better maps without ever drawing the borders that tell the navigator where certainty ends.

## 5. Opening Move

Open with a concrete, minimal scenario: a single query run against two systems, returning two contradictory answers. One question: "Is this customer active?" One query. System A says no. System B says unknown. Both are correct. The reader feels the dissonance before the essay explains it.

## 6. Closing Target

The last 2-3 sentences callback to the opening scenario, now reinterpreted through the full thesis, and leave the reader with the central question as something they will carry into their next vendor evaluation or architecture discussion. The final sentence lands on the distinction between "false" and "we haven't looked yet" as a decision with consequences most teams have never consciously made. No call to arms. Quiet. Confident.

## 7. Debate Insights to Preserve

1. **OWA is not a free lunch.** Must appear in Section 4, positioned after the GraphRAG example. The answer is not "switch everything to OWA." The answer is "declare your completeness boundaries so consumers can distinguish warranted confidence from warranted hedging."

2. **The vendor question needs a plain-language translation.** Must appear in Section 6 as exact phrasing: "When a query returns no results, does that mean the thing doesn't exist, or that your system doesn't know about it?"

3. **The tool-count needs trajectory framing.** Must appear in Section 4 as: "today it's 8 data sources connected to your agent orchestration layer, next year it's 25." Not a bare "40."

4. **LCWA and formal mechanisms exist.** The essay concedes the formal machinery exists and shows that enterprise adoption is near zero outside regulated sectors. This concession makes the Section 5 healthcare proof point land.

## 8. Risk Points

- **Section 2 to Section 3 transition:** Section 2 is instructive and risks feeling like a textbook. The map metaphor introduced at the end of Section 2 must create enough curiosity to pull the reader into the pivot.
- **Section 4 length:** Carries the most arguments (GraphRAG, tool scaling, system prompt fragility, OWA failure modes). Risks bloating. Discipline required.
- **Section 5 brevity:** At 2-3 paragraphs, needs to land as "proof this is practical" without expanding into a healthcare case study.
