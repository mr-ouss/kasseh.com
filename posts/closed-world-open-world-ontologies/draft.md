## The Same Question, Two Answers

A customer disappears from the `active_customers` table in Snowflake. The CRM has no record of recent activity. One question needs answering: is this customer still active?

System A, the transactional database, gives a clean answer. The customer is not in the `active_customers` table, so the customer is inactive. No rows returned means no. A churn report can be built on this, routed to the account management team, fed into a win-back campaign. The data spoke.

System B is a partner data feed that syncs every 48 hours. The same query returns the same empty result. But System B last synced Tuesday morning and it is now Thursday afternoon. The absence of this customer from the table could mean churn, could mean the sync has not caught up, could mean the partner defines "active" by a different threshold entirely. System B's empty result carries a different meaning: we do not know.

Both systems answered the same query. Both answers are correct given what each system knows and how it treats what it does not know. One system treats absence as fact. The other system's absence is ambiguity wearing the same uniform. And the downstream business conclusion, the one that decides whether a sales rep calls this account or writes it off, diverges completely depending on which system got asked first.

## The Assumption the Database Already Made

The distinction underneath that scenario has a name, and it is older than any tool in a modern data stack. Logicians call it the **closed-world assumption** and the **open-world assumption**.

The closed-world assumption is simple: if something is not stated as true, it is false. Think of a guest list at a private event. If a name is not on the list, that person is not invited. The list is the complete truth. There is no "maybe they were invited but we forgot to write it down". Not on the list, not getting in.

The open-world assumption starts from the opposite position: if something is not stated as true, it is unknown. Think of a birdwatcher's field journal. If a species does not appear in the journal, that does not mean the species does not exist in the area. It means the birdwatcher has not observed it yet. The journal records what has been seen, not what there is to see.

SQL was born under the closed-world assumption. When a `LEFT JOIN` returns `NULL`, that `NULL` is definitive. It means "no matching row exists". The query engine searched the entire relevant table, found nothing, and reported that nothing. This is correct because a relational database is, by design, the complete record of the domain it models. The `orders` table contains all orders. The `customers` table contains all customers. If a customer is not in the table, they are not a customer. The system is closed. Everything inside is known; everything outside does not exist.

dbt reinforces this assumption implicitly. When a model references another model using `ref('stg_customers')`, it assumes that `stg_customers` is a defined, known entity in the project. If the model does not exist, dbt does not conclude "maybe someone has not built it yet". It fails the build. This is useful. It gives teams compile-time guarantees, lineage tracking, and testable contracts. Within a single project that models a single system of record, the closed-world assumption is exactly right.

The open world shows up in a different corner of the technology stack. Knowledge graphs were built under the open-world assumption. If a `Customer` entity has no `phone_number` property, the system does not conclude the customer has no phone number. It concludes that the phone number is unknown. The absence of a statement is not the negation of a statement. These systems were designed for the web, where no single database can claim complete knowledge of anything and where new facts can always arrive from sources not yet seen.

This collision already plays out at massive scale. Schema.org, the vocabulary that websites use to describe their content to search engines, was designed under the open-world assumption: any property on a `Product` or `LocalBusiness` entity can be absent without implying it does not apply. But Google's Rich Results validator interprets Schema.org markup under a closed-world lens, penalizing pages that omit recommended properties like `aggregateRating` or `priceRange`. The same vocabulary, the same property names, evaluated under different assumptions, producing different outcomes. A page without a `priceRange` property is either "we have not specified a price range" or "this business has no price range", and Google chose the second interpretation without ever announcing the switch.

Here is a way to think about all of this. Think of a SQL database as a map. A very good map, drawn with precision, every road measured and labeled. But a map with no border drawn. The cartographer charted every road inside the territory they covered, and within that territory the map is authoritative. The problem is that the map does not tell the reader where its coverage ends. Where the roads stop, the reader cannot tell whether they have reached the edge of civilization or the edge of the cartographer's knowledge. The closed-world assumption is a map without a border. Within its scope, everything it shows is accurate and everything absent is genuinely absent. The question is whether the consumer of that map knows where the scope ends.

## Where Completeness Ends

Within a single system of record, the closed-world assumption is not just convenient. It is correct. The `orders` table in a company's transactional database really does contain all the company's orders. A `LEFT JOIN` that returns `NULL` really does mean "no match exists". Questioning this inside the system that produced the data would be paranoid and counterproductive.

The problem starts at the boundary.

Consider an acquisition. Company A runs a CRM with 40,000 customer records in the US market. Company B runs its own CRM with 28,000 customer records, also US market. Both systems operate under the closed-world assumption internally, and both are correct: each contains the complete set of customers for its respective business. On day one of the merger, someone runs a deduplication query across both systems. A customer appearing in Company A but absent from Company B gets flagged as "Company A only". A customer in Company B but absent from Company A gets the inverse flag.

The logic makes sense if both systems together form a complete picture. They do not. Company A defined "customer" as anyone who completed a purchase. Company B defined "customer" as anyone who signed a contract, including prospects in negotiation. Two closed worlds that overlap in scope but diverge in definition. The deduplication query, operating under the closed-world assumption across both, produces false negatives: real customers classified as duplicates or non-customers because the combined system was treated as closed when it was actually the union of two different closures with incompatible boundaries.

There is a formal concept for handling this, called the **Local Closed World Assumption**: declare that for a specific type of data, completeness holds within a specific scope. System A is closed for US purchase-based customers. System B is closed for US contract-based customers. The union preserves correctness only when the consuming query knows the domain boundaries of each source and those boundaries do not overlap in contradictory ways. The concept is sound. The formal machinery for implementing it exists. Outside of healthcare, life sciences, and defense, enterprise adoption of it is near zero.

What the industry built instead is more boundaries. Data mesh asks domain teams to publish data products for consumers they have never met and cannot predict. Snowflake Horizons lets one account query tables owned by another account without knowing how the second account defines completeness, what the sync cadence is, or whether the table represents a full domain or a filtered subset. Databricks Unity Catalog enables cross-workspace sharing that multiplies the number of integration seams per quarter. Every one of these patterns assumes that sources from different teams and systems can be composed into a single queryable surface. Not one of them ships with a mechanism for declaring where a source's closed world ends and uncertainty begins.

The vendors building on top of this infrastructure are not clarifying the situation. Stardog, Neo4j, and Atlan all use "ontology" and "knowledge graph" in their positioning. But the distinction between "absence means false" and "absence means unknown" appears in none of their product stories. The word "ontology" appears across all three. The question of what happens when the ontology encounters something it has never seen is left to the customer to figure out.

Two maps being overlaid, neither showing its borders. The cartographer who drew the US road map and the cartographer who drew the county property map each produced accurate, closed-world documents. Overlay them and the combined map looks authoritative, every road and every parcel accounted for. But one cartographer stopped at state highways and the other stopped at incorporated municipalities, and the blank spaces on the combined map are a mix of "nothing here" and "we did not look". Without borders drawn, the navigator cannot tell which blank spaces are safe to trust and which ones will send a team down a road that does not exist.

## Agents Inherit What Was Never Declared

The integration boundaries above are human-navigable. A data engineer merging two CRMs can, with enough patience and institutional knowledge, learn that System A defines "customer" by purchases and System B defines it by contracts. The knowledge lives in someone's head, in a Confluence page last updated eighteen months ago, in tribal context passed between teammates. It is fragile, but it is available.

AI agents do not have access to any of it.

When an agent framework connects to a data source through tool-use or function-calling, it inherits the source's data without inheriting the source's completeness assumption. Microsoft's GraphRAG pattern illustrates this cleanly. GraphRAG builds a knowledge graph from a document corpus, then retrieves against that graph to augment the agent's reasoning. If an entity was mentioned in a document that was never indexed, the entity does not appear in the graph. The retrieval treats it as non-existent. This is the closed-world assumption operating inside the retrieval layer, and nothing in the pipeline signals to the agent that the graph's completeness is bounded by which documents happened to be ingested. The agent reasons over the graph as if it were the world.

This scales predictably. Today it is 8 data sources connected to an agent orchestration layer: a CRM, a product database, a support ticket system, a billing platform, a few internal APIs, maybe a document store. Next year it is 25. Each source carries its own completeness semantics. The CRM is authoritative for customer records. The billing platform is authoritative for payment history. The support system contains tickets filed through the portal but not issues reported over email or Slack. The document store indexed last quarter's materials but not this quarter's. Eight different closed worlds, each correct within its own boundary, none of them publishing where that boundary is. The agent treats all eight as a single, flat surface of facts.

The instinct is to solve this in the prompt. Add instructions: "When querying the support system, note that it only contains portal-submitted tickets." Add caveats to tool descriptions. This works at small scale. At 25 sources, the system prompt becomes a wall of completeness footnotes that conflict, drift from the actual source behavior, and break silently when someone rewrites the prompt for a different use case. A single prompt revision can strip a caveat that was the only thing preventing the agent from treating a partial dataset as complete. The burden sits on the agent builder, who must independently understand the completeness semantics of every source. The data publisher, who actually knows them, never had to declare them.

The instinct on the other side is equally dangerous. A system that never commits to completeness anywhere produces an agent that hedges everything. "Based on available data, which may be incomplete, there is a possibility that this customer might be inactive, though additional sources could change this assessment". Useless. What works is declaring the completeness boundaries so that the agent can distinguish between warranted confidence ("the billing system is authoritative for payment history, and this customer has no payments") and warranted hedging ("the support system only covers portal tickets, so the absence of complaints does not mean the absence of problems").

A navigator using 8 maps from 8 cartographers, none of whom drew their borders. Some maps are detailed and complete within their territory. Some are partial sketches. The navigator cannot tell which is which because no cartographer marked where their charting ended. Every blank space looks the same, and the navigator plans routes across all of them as if silence means "clear road ahead".

## An Industry That Already Solved This

Healthcare and life sciences crossed this bridge decades ago, because regulators forced them to.

Think about what happens when a doctor checks a drug interaction database before prescribing two medications together. The database returns no known interactions. In a closed-world system, "no result" means "safe to co-prescribe". In a system that has not been updated for the newest drug on the market, "no result" might mean "we have not evaluated this combination yet". The difference between those two interpretations is, quite literally, life and death. So the pharmaceutical industry, under FDA mandate, built the metadata layer that declares where certainty ends. A drug interaction database publishes its completeness scope, and downstream systems know whether "no interaction found" means "safe" or "not yet evaluated".

The same principle runs through clinical terminology. SNOMED CT, the coding system that most of the developed world's hospitals use for diagnoses, makes completeness explicit at the concept level: a code set declares what it covers and what falls outside its scope. HL7 FHIR, the standard for healthcare data exchange, takes it further with **binding strengths**: when a medical record references a set of valid codes, the binding strength tells the consuming system how much authority that code set claims. A "required" binding is closed-world: if the code is not in the set, it is invalid. An "extensible" binding is explicitly open-world: the set covers the common cases, but valid codes can exist outside it. The world assumption is a declared, machine-readable property of the data contract.

The operational precedent exists. The question is whether the rest of the data industry will wait for a forcing function as blunt as the FDA before making the same choice healthcare made twenty years ago.

## Monday Morning

The formal tools for managing completeness assumptions exist, and they work. Most teams are not there yet, and they do not need to be. There are four actions that move the needle without requiring a knowledge graph migration or a philosophy seminar.

**First: audit the integration seams.** Open a spreadsheet. List every cross-source join, every federated query, every data-sharing agreement the team operates. For each one, write down which source is the system of record for which entity. Flag the rows where authority is ambiguous or shared. This is not a technology project. It is a clarity exercise, and most teams discover on their first pass that 20-30% of their cross-boundary queries are treating partial sources as authoritative without anyone having made that decision consciously.

**Second: add completeness declarations to dbt models.** dbt's `meta` config accepts arbitrary key-value pairs. Use it:

```yaml
models:
  - name: stg_customers
    meta:
      completeness: closed
      domain_boundary: "US direct-purchase customers only"
      last_verified: "2025-01-15"
```

This is ten lines of YAML and zero infrastructure investment. It converts an implicit assumption into an explicit declaration that travels with the model's documentation. When another team builds on top of `stg_customers`, they can see that the model is closed for US direct-purchase customers and does not claim coverage of partner-channel or international customers. The declaration is human-readable today and machine-readable whenever tooling catches up.

**Third: tag agent tool schemas with a `completeness_scope` field.** For teams building tool-use pipelines for AI agents, add a structured field to each tool definition that declares what the tool is authoritative for and what falls outside its coverage. This is more precise than blanket hedging instructions in the system prompt because it lets the agent distinguish per tool. The billing API returns "no payments found" and the agent can treat that as definitive. The support ticket search returns "no tickets found" and the agent knows to caveat the absence because the tool only covers portal-submitted tickets. Per-tool completeness metadata replaces prompt-level guesswork with source-level declarations.

**Fourth: ask vendors one question.** When evaluating any product that uses the words "ontology", "knowledge graph", or "semantic layer" in its pitch: "When a query returns no results, does that mean the thing doesn't exist, or that your system doesn't know about it?" Simpler: can the system be configured, per entity type or per source, so that absence means false in some contexts and absence means unknown in others? If the vendor does not understand the question, that tells you how deeply they have thought about the ontological foundations they are marketing. If they do understand it and have an answer, that is a vendor worth the next meeting.

---

The customer from the opening is still missing from the `active_customers` table. The query still returns no rows. Nothing in this essay changed that. What changed, or what can change, is whether the system consuming that empty result knows what it means. Whether "not in the table" is a fact or a limitation. Whether the map's blank space is an empty field or the edge of the cartographer's knowledge.

Every database already has an ontology, a set of assumptions about what exists and what absence means. Most teams never chose it. SQL chose it for them, and the closed-world assumption that makes SQL powerful within a single system of record is the same assumption that breaks at every boundary where two systems meet, every feed that syncs on a delay, every agent that queries five sources and treats them as one. The industry is building better maps every quarter. Faster queries, cleaner pipelines, sharper dashboards. The borders that tell the navigator where certainty ends remain undrawn.
