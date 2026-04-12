# Thesis Document: Closed-World vs. Open-World Ontologies (v3)

## 1. Core Claim

The enterprise data industry is adopting ontological vocabulary (knowledge graphs, semantic layers, ontologies) while operating under closed-world assumptions that are correct within individual systems of record but silently break at every integration boundary. The danger is not CWA itself, which is a sound design choice within scoped domains. The danger is that the industry is building more integration boundaries per quarter (data mesh, cross-account sharing, multi-source AI agents) without any mechanism for declaring where completeness ends and uncertainty begins.

AI agents compound this. They do not formally inherit CWA or OWA from their data sources; an agent's response to empty results depends on prompting and training, not the data source's world assumption. But informal mitigations (system prompt instructions, tool description caveats, RAG fallback handlers) do not scale across tools or survive prompt changes because they place the burden on the agent builder rather than the data publisher. The missing layer is completeness metadata published by the data source itself, readable by any consumer without the consumer having to know the source's semantics in advance.

## 2. Why This Matters Now

Three forces are converging, and they are all integration forces.

First, the "knowledge graph" and "semantic layer" market is growing: vendors like Stardog, Neo4j, Atlan, and dbt are all using ontological language in their positioning, but almost none of them surface which world assumption their system operates under. The W3C standards that underpin formal ontology (OWL, RDF, RDFS) were designed under the open-world assumption, while the SQL databases, dbt models, and BI tools that most enterprises run on are closed-world systems by default. The industry is bolting open-world vocabulary onto closed-world infrastructure.

Second, enterprise data architecture is structurally moving toward more cross-boundary integration. Data mesh asks teams to publish domain data products for consumers they don't control. Snowflake Horizons and Databricks Unity Catalog enable cross-account data sharing where a consumer queries data they didn't produce. Every data-sharing contract, every federated query, every cross-domain join is a boundary where an individual system's CWA stops being valid. These integration boundaries are becoming the norm, not the exception.

Third, AI agents are being connected to multiple data sources through tool-use and function-calling architectures. Microsoft's GraphRAG pattern, which augments retrieval with knowledge-graph structure, operates under an implicit CWA: if an entity or relationship is missing from the graph, the retrieval treats it as non-existent rather than unobserved. As more agent architectures adopt graph-augmented retrieval, the CWA assumption bakes deeper into the reasoning layer without anyone naming it.

Schema.org offers a massive-scale illustration of this tension. It was designed as an open-world vocabulary: any property can be absent without implying it doesn't apply. But Google's Rich Results validator treats Schema.org under a closed-world lens, penalizing pages that omit recommended properties. The same vocabulary, interpreted under different world assumptions, produces different outcomes. This is the pattern playing out across enterprise data, just at smaller scale and with higher stakes.

This is the moment where the confusion is becoming load-bearing. Teams are making architectural decisions based on a word ("ontology") that means fundamentally different things depending on which assumption you adopt, and the consequences show up most acutely at the integration seams that every modern data strategy is creating more of.

## 3. The Strongest Counterargument

The strongest counterargument operates at three levels, and all are partially right.

**Level 1: CWA is correct within a system of record, and most work stays within that boundary.** A company's transactional database really does contain all the company's transactions. The `orders` table is the complete set of orders. `customer_status` in the CRM is the authoritative source of customer status. CWA is a design feature, not an accident. If the majority of enterprise data work operates within single-system boundaries, the thesis is describing an edge case.

The thesis concedes the premise and disputes the conclusion. CWA is absolutely correct within a scoped system of record. The argument is about trajectory: the percentage of enterprise data work that crosses system boundaries is growing. Data mesh, cross-account sharing, multi-cloud architectures, and AI agents consuming multiple sources are all integration patterns moving from edge case to default architecture. The thesis is about what happens at the boundaries, and the industry is building more boundaries faster than it is building mechanisms to handle them.

**Level 2: Formal mechanisms for scoped completeness already exist.** Local Closed World Assumption (LCWA) is a formal construct in description logics: for predicate P, the CWA holds for the subset matching condition C. OWL 2 profiles support closure axioms. SPARQL offers `FILTER NOT EXISTS`. SHACL and ShEx constraint languages allow CWA-style validation to be applied over OWA data stores. The union of closed worlds is open only when completeness boundaries are not explicitly declared. The response is: "Declare the scope boundaries."

The thesis concedes that the formal machinery exists and argues that enterprise adoption of it is near zero outside healthcare/life sciences (SNOMED CT, HL7 FHIR binding strengths, FDA-mandated pharmaceutical ontologies) and defense/intelligence. These regulated sectors have made CWA/OWA management explicit and operational at scale. They prove this is practical, not theoretical. The question the essay poses: why has the rest of the industry not followed? The tools most enterprises actually use (dbt, Looker, Tableau, Power BI, Snowflake) have no mechanism for declaring completeness boundaries per entity type or per source.

**Level 3: Informal completeness signals already exist in agent tooling.** OpenAPI 3.1 supports `x-` extension fields that teams use for freshness, source system, and caveats. Function-calling tool descriptions informally communicate constraints ("this endpoint only returns data from the last 90 days"). RAG systems include "no results found" handling.

The thesis acknowledges these exist and argues they are insufficient at scale. When an organization has 40 tools connected to an agent orchestration layer, the "just add instructions to the system prompt" approach requires every agent builder to independently understand and encode the completeness semantics of every data source. This is the same pattern that made data documentation fail at scale: it works for 3 sources, it collapses at 30. Informal conventions are convention-dependent, fragile to prompt changes, and place the burden on the consumer rather than the publisher. The alternative: completeness metadata published by the data source itself, standardized and machine-readable, so any consumer can interpret empty results without source-specific knowledge.

## 4. Syntaxia Thesis Connection

Direct and structural. Syntaxia's position is that ontology must be grounded in business meaning first, with data mapped to it afterward. The closed-world vs. open-world distinction is a concrete technical expression of this: a business ontology needs to declare what it knows, what it doesn't know, and how to handle the gap.

Most "semantic layer" products skip this entirely because they inherit the closed-world assumption from their SQL substrate without ever surfacing it as a design choice. Syntaxia's ontology-first approach requires making this choice explicit: which concepts in this business domain are closed (we have all the customers, we have all the products) and which are open (we do not have all the competitive intelligence, we do not have all the market context, we do not have complete knowledge of how partner organizations define "active user").

This maps directly to the completeness metadata argument: an ontology-first platform could publish concept-level completeness declarations that travel with the data, so an agent consuming the ontology knows whether absence means "false" or "unobserved" without the agent builder encoding that knowledge into prompt instructions. Making this distinction visible is a core differentiator for any ontology platform that claims to support reasoning, not just querying.

## 5. Implied Audience

**Primary:** Analytics engineers and data architects who have started hearing "ontology" and "knowledge graph" in vendor pitches and internal strategy discussions, have maybe read a few blog posts about semantic layers, but haven't encountered the closed-world/open-world distinction and don't realize their current stack has already made that choice for them. The person who reads this essay and forwards it is the one who just sat through a knowledge graph demo and felt something was off but couldn't articulate what. This essay gives them the vocabulary.

**Secondary:** Data leaders evaluating whether to invest in ontological infrastructure, who need to understand that "ontology" is not one thing and that the choice between CWA and OWA has real architectural consequences they should be asking vendors about.

**Tertiary:** Platform engineers connecting data sources to AI agent frameworks (LangChain, CrewAI, Semantic Kernel) who are encountering completeness problems in practice but framing them as "hallucination" rather than as a world-assumption mismatch.

## 6. Closing Provocation

Every database you run already has an ontology. The question is whether it's one you chose or one that SQL chose for you, and whether "not in the table" means "false" or "we haven't looked yet" is a decision with consequences that most teams have never consciously made.

## 7. Key Examples Needed

- **The `customer_status` column under CWA vs. OWA.** In a closed-world system, if a customer doesn't appear in the `active_customers` table, they are inactive. Full stop. In an open-world system, their absence means unknown. Show how this difference changes downstream conclusions when reasoning over a table that was last synced 48 hours ago or when a second system has a different definition of the same entity.

- **dbt's `ref()` and `source()` as implicit CWA.** dbt assumes that the models and sources it knows about are the complete universe. If a metric isn't defined in the semantic layer, it doesn't exist. This is useful for validation but dangerous when teams assume the semantic layer is the complete ontology rather than a closed projection of a larger open world. **Concrete implementation:** In a dbt project, add a `meta` block in the YAML with `completeness: closed | open | partitioned`, `domain_boundary: "US customers only"`, and `last_verified: 2025-01-15`. This is 10 lines of YAML, zero infrastructure investment, and it converts an implicit assumption into an explicit declaration.

- **The merger/acquisition scenario (thesis anchor).** Company A has a closed-world ontology of its customers. Company B has a closed-world ontology of its customers. Post-merger, the combined entity operates in an open world: neither system has complete knowledge. Show how tools that assume CWA produce false negatives. **Precision:** The union of closed worlds preserves CWA when their domain boundaries are non-overlapping and the querying agent knows the boundaries (e.g., System A has all US customers, System B has all EU customers, same definition). The CWA breaks when domain boundaries overlap or when the querying agent cannot see the boundaries.

- **OWL's open-world assumption vs. SQL LEFT JOIN.** When you define a class in OWL and an instance doesn't have a property, OWL doesn't conclude the property is absent. It concludes the property is unknown. Contrast this with a SQL LEFT JOIN where NULL means "no match" and is treated as a definitive absence. Show how the same business question produces different answers depending on which system you ask.

- **Vendor positioning audit.** Stardog, Neo4j, and Atlan all use "ontology" and "knowledge graph" in marketing without specifying which world assumption their system operates under. Verified against current vendor materials.

- **GraphRAG as implicit CWA.** Microsoft's GraphRAG builds a knowledge graph from documents and retrieves against it. If an entity was mentioned in a document that wasn't indexed, GraphRAG treats it as non-existent. The graph's completeness is bounded by the document corpus, but nothing in the retrieval pipeline signals this to the agent.

- **The "40 tools in the system prompt" failure mode.** An organization connects 40 data sources to an agent orchestration layer. Each source has different completeness semantics. The "solution" is to encode these in the system prompt or individual tool descriptions. This works for 3 sources. At 40, it is unmaintainable: prompt instructions conflict, tool descriptions drift from reality, and a single prompt rewrite can silently remove completeness caveats.

- **Schema.org as CWA/OWA tension at scale.** Schema.org was designed under OWA: any property can be absent. Google's Rich Results validator interprets it under CWA: missing recommended properties are flagged. The same vocabulary, two world assumptions, different outcomes.

- **Healthcare/life sciences as proof of concept.** SNOMED CT, HL7 FHIR binding strengths, pharmaceutical ontologies under FDA mandates. These sectors have made CWA/OWA management explicit and operational at scale. They prove this is practical, not theoretical.

## 8. Practical Takeaways

- **Audit your integration seams.** For every cross-source join, federated query, or data-sharing agreement, ask: does the consumer know which source is the system of record for which entity? If not, CWA is being applied where OWA applies. This can be a spreadsheet exercise: list every cross-boundary query, note which source is authoritative, flag the ones where authority is ambiguous.

- **Add completeness declarations to data contracts.** When publishing a dbt model or data product, declare what the model is complete for in its documentation or contract. "This model contains all orders placed through the web channel. It does not contain orders from partner channels or in-store purchases." Use dbt's `meta` config: `completeness: closed`, `domain_boundary: "web channel orders, US region"`, `last_verified: 2025-01-15`. This is LCWA in plain language, no description logic required.

- **Tag tool schemas with source authority.** If building AI agent tool-use pipelines, include metadata in tool descriptions that indicates whether an empty result means "definitively not found" or "not found in this source". Add a `completeness_scope` field to function-calling tool definitions. This is more precise than blanket "always hedge" prompt instructions because it lets the agent distinguish between warranted confidence and warranted hedging per tool.

- **Ask your vendors the question.** When evaluating knowledge graph or semantic layer products, ask: "Does your system treat missing information as false or as unknown? Can I configure this per entity type or per source?" If the vendor doesn't understand the question, that tells you something about how deeply they've thought about the ontological foundations they're marketing.

---

## Trace

- Skills loaded: kasseh-writing-guide, kasseh-voice-reference
- Thesis version: 3
- Key changes from v2: distinguished schema-level vs prompt-level completeness signals; added "40 tools" scaling argument; added healthcare/life sciences exception with SNOMED CT, HL7 FHIR; tightened "union of closed worlds" with domain-partition counterexample; added GraphRAG, Schema.org examples; concrete dbt YAML implementation in takeaways
- Key changes from v1: core claim narrowed to integration boundaries; AI agent mechanism specified (completeness metadata gap); LCWA acknowledged; practical takeaways added

VERDICT: HARDENED
