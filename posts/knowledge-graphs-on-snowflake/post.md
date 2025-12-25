# Knowledge Graphs on Snowflake: The Architecture Shift Nobody Saw Coming

*From data warehouse to reasoning engine.*

Last month I saw a LinkedIn post that stopped me mid-scroll. Greg Macpherson from RelationalAI had built a knowledge graph to model the Great Artesian Basin, one of the largest freshwater aquifers in the world. The graph connected the Australian federal government, four state governments, BHP, Rio Tinto, aboriginal corporations, the Bureau of Meteorology, environmental legislation, and water rights. All running inside Snowflake. No external graph database. No data movement. No specialized infrastructure.

The visualization showed what no relational schema could: the web of stakeholders, regulations, and resources that govern 1.7 million square kilometers of underground water spanning multiple jurisdictions.

I realized I was looking at something bigger than a clever demo. This was the logical endpoint of a transition that's been building for years, one that most data teams haven't noticed.

Snowflake is no longer just a data warehouse. It's becoming a reasoning engine.

## How Snowflake Became Something Else Entirely

Ten years ago, Snowflake was a cloud data warehouse with a clever architecture: separated storage and compute. You could scale query capacity without scaling storage costs. Revolutionary for its time, but still fundamentally a place to run SQL against structured data.

Today, Snowflake calls itself the "AI Data Cloud." That's marketing language, but the underlying capabilities are real. Let me walk through what actually changed.

**Native App Framework and Snowpark Container Services.** Snowflake now lets third parties run containerized applications directly inside your Snowflake account. Your data never leaves. The compute runs where the data lives. This is the architectural foundation that makes knowledge graphs possible without data extraction.

**Cortex AI.** Snowflake embedded LLMs directly into the platform. You can run sentiment analysis, summarization, and text generation using SQL functions. More importantly, Cortex Analyst lets business users query data in natural language, with the SQL generated automatically based on semantic models you define.

**Semantic Views.** Announced at Summit 2025, semantic views are schema-level objects that define what your data means, not just what it contains. You declare that `amt_ttl_pre_dsc` is actually "gross revenue" and that "net revenue" means gross revenue after discounts. These definitions persist, get governed, and power AI applications.

**Snowflake Intelligence.** Launched in November 2025, this is an agentic AI layer that lets anyone in your organization ask questions of data conversationally. It combines Cortex Analyst, Cortex Search, and AI agents that connect to semantic views and models.

The pattern is clear. Snowflake is building the infrastructure for meaning, not just storage. Data warehouses hold facts. AI Data Clouds understand what those facts mean.

## The Knowledge Graph Coprocessor: RelationalAI

Here's where it gets interesting.

RelationalAI runs as a native app inside Snowflake. It's not a separate graph database. It's a **knowledge graph coprocessor** that creates graph indexes over your existing Snowflake tables. When you query relationships, it reasons over the graph. When you need results, they write back to Snowflake tables that anyone can access with SQL.

The technical architecture works like this:

1. Your data stays in Snowflake tables
2. RelationalAI creates a graph layer with entities and relationships
3. You define your ontology in Python (what concepts exist, how they relate, what rules apply)
4. The knowledge graph materializes without extracting data or building pipelines
5. Results export to Snowflake tables, accessible through standard SQL

This eliminates the traditional knowledge graph adoption problem: you don't need to convince your organization to adopt a new database, learn SPARQL or Cypher, or build integration pipelines. You install an app from the Snowflake Marketplace and start modeling.

RelationalAI announced several new capabilities at Snowflake Summit 2025 that extend what's possible:

**Graph Neural Networks (GNNs).** You can now run predictive models that learn from both the structure and semantics of your data. This enables demand forecasting, churn prediction, and risk scoring that understands relationships, not just individual records.

**Text-to-Reasoner.** Beyond text-to-SQL, you can ask questions that require reasoning: "What's going to happen?" and "What should we do about it?" RelationalAI achieved a top-of-leaderboard result on the Spider 2.0 text-to-SQL benchmark with this capability.

**Mathematical Optimization.** Apps can use optimization solvers to compute optimal decisions given constraints and objectives. Supply chain planning, resource allocation, and scheduling become declarative problems rather than procedural code.

**Interoperability with Snowflake Semantic Views.** RelationalAI's knowledge graph semantics can drive Cortex Analyst accuracy and power BI dimensional models. The semantic layer isn't separate from the reasoning layer. They reinforce each other.

## Why This Matters: The Problems Knowledge Graphs Actually Solve

I've written before about semantic drift, the silent corruption of meaning in data systems. Knowledge graphs are one of the architectural solutions to that problem. But let me be more concrete about where they deliver real value.

### Anti-Money Laundering and Fraud Detection

Financial crime detection is fundamentally a relationship problem. Money laundering schemes involve multiple intermediaries, layered transactions, shell companies, and obscured beneficial ownership. The United Nations estimates that $2 trillion is laundered globally each year. That's 2-5% of global GDP.

Traditional AML systems use rule-based monitoring on relational databases. They flag individual transactions that exceed thresholds or match suspicious patterns. The result is an avalanche of false positives and a fundamental blindness to network-level schemes.

Knowledge graphs change this.

Consider what becomes possible when you model accounts, customers, transactions, addresses, phone numbers, and corporate registries as a connected graph:

**Tracing ownership chains.** A shell company in the Caymans owns 40% of a Delaware LLC that shares a registered agent with three other entities flagged in the Pandora Papers. A relational query to find this would take hours and require knowing what to look for. A graph query surfaces it in seconds.

**Identifying circular transaction patterns.** Money flows from Account A through B, C, D, and back to A with slight modifications at each step. In a relational system, you'd need to write recursive CTEs and know the depth to search. In a graph, this is a cycle detection algorithm.

**Connecting alerts across cases.** When an analyst investigates a suspicious activity report, the knowledge graph can surface similar historical cases, shared counterparties, and related entities flagged by other teams. Investigation time drops from days to minutes.

**Reducing false positives.** Graph analytics can assign risk scores based on network position, not just individual behavior. An account connected to three entities previously involved in fraud is riskier than its transaction history alone would suggest.

Cash App, Block's mobile payment platform, uses RelationalAI's knowledge graph inside Snowflake for customer intelligence. They run algorithms like PageRank, Louvain Modularity, and InfoMap to identify their most important customers and prioritize retention initiatives. What used to take days now takes minutes.

### Supply Chain Complexity

Blue Yonder, the supply chain software company, announced a collaboration with Snowflake and RelationalAI to build a supply chain knowledge graph. The results are striking.

They replaced thousands of lines of imperative business logic with a small set of declarative rules. The outcome: **90% reduction in legacy code** and processing times that dropped from over a month to several hours.

At the Knowledge Graph Conference 2025, Blue Yonder presented a deep dive on their implementation. They modeled supply chain entities (products, suppliers, warehouses, logistics partners) and their relationships. They embedded semantics into relational structures. They integrated multiple AI reasoners: descriptive (rule-based and graph), prescriptive (optimization), and predictive (graph neural networks).

The key insight from their talk: "Declarative rule-based modeling, embedded in Python for graph traversal and reasoning, formulating optimization modeling, exploring contextual richness for GNN, as well as powering AI Agent with knowledge verbalization."

That last point matters. When you have a knowledge graph with explicit semantics, you can generate natural language explanations of what the system knows. This enables AI agents that can answer questions like "Why is this shipment delayed?" or "What should we do about the supplier disruption in Taiwan?" with grounded, traceable responses.

### Multi-Stakeholder Resource Governance

Back to that Great Artesian Basin example from Greg Macpherson.

The Basin spans four Australian states. It involves federal legislation, state regulations, mining companies, pastoral interests, indigenous rights, township water supplies, and environmental monitoring. The relationships between stakeholders are complex: legislation governs use, companies have extraction rights, aboriginal corporations have cultural and legal claims, weather patterns affect recharge rates.

No single relational database can model this. You'd need to denormalize extensively, create complex join tables, and still lose the ability to traverse relationships dynamically.

With a knowledge graph, you can:

**Start anywhere and build out.** Begin with legislation, add stakeholders as you learn them, connect to external data sources like the Bureau of Meteorology. The graph grows incrementally.

**Share granularly.** Different parties see different subgraphs based on their access rights. Mining companies see their licenses and constraints. Indigenous corporations see cultural heritage sites and traditional use areas. The same underlying graph, different views.

**Answer questions nobody thought to ask.** "Which stakeholders are affected if extraction increases at bore X?" becomes a graph traversal, not a custom report.

This is what data-centric architecture looks like in practice. The knowledge graph becomes the shared truth. Applications become views over it.

## The Open Semantic Interchange: Where This Is Going

In September 2025, Snowflake, Salesforce, dbt Labs, BlackRock, and RelationalAI announced the **Open Semantic Interchange (OSI)**, an open-source initiative to standardize how semantic models are defined and shared across platforms.

The problem they're solving: every tool today interprets business metrics differently. Your Tableau dashboard defines "revenue" one way. Your dbt model defines it another. Your AI agent has a third interpretation. The result is confusion, slow adoption, and eroded trust in AI-driven insights.

OSI introduces a vendor-neutral specification for business, domain, and industry semantics. Define your concepts once, use them everywhere. From Snowflake Cortex Agent to third-party BI tools to external AI applications.

The coalition includes 17 vendors: Alation, Atlan, Blue Yonder, Cube, dbt Labs, Hex, Honeydew, Mistral AI, Omni, RelationalAI, Salesforce, Select Star, Sigma, Snowflake, and ThoughtSpot.

This isn't just about convenience. It's about making AI reliable. When every tool speaks the same semantic language, AI agents can reason across systems without losing meaning in translation.

As Molham Aref, CEO of RelationalAI, put it: "With Open Semantic Interchange, RelationalAI has the opportunity to bring relational knowledge graph semantics into OSI to enable decision intelligence more broadly, and give customers and partners a durable way to define semantics once and use them everywhere."

## The Uncomfortable Trade-offs

I've been bullish so far. Let me acknowledge what's hard.

**Ontology design is still work.** RelationalAI makes it easier to operationalize a knowledge graph, but someone still needs to decide what entities exist, how they relate, and what rules apply. This requires domain expertise and cross-functional alignment. It's not something you install and forget.

**The ecosystem is young.** RelationalAI is the most mature knowledge graph coprocessor for Snowflake, but it's still relatively new. The case studies are impressive (Cash App, Blue Yonder, AT&T, Spark NZ), but the pattern isn't yet widespread.

**Costs scale with complexity.** Running graph algorithms over large datasets inside Snowflake Container Services consumes compute. For simple analytics, traditional SQL is cheaper and faster. Knowledge graphs make sense when relationship complexity justifies the overhead.

**Skills gap.** Most data engineers are comfortable with SQL and Python. Fewer have experience with ontology design, graph algorithms, or declarative reasoning. Hiring and training are real constraints.

## What You Can Do Now

If you're curious but not ready for a full ontology project, here's where to start:

**Identify a relationship-heavy domain.** Fraud detection, supply chain, customer networks, regulatory compliance. If you find yourself writing recursive CTEs or building bridge tables to connect entities across multiple hops, that's a signal.

**Try Snowflake's semantic views.** Even without RelationalAI, you can start defining what your data means. Build semantic views for your core business metrics. Connect them to Cortex Analyst. See what natural language querying surfaces.

**Explore the RelationalAI quickstarts.** There's a public quickstart on building a knowledge graph for question answering using RelationalAI and Snowflake Cortex. It walks through installing the native app, creating a graph over Snowflake tables, and running natural language queries.

**Watch the Blue Yonder case study.** Their Knowledge Graph Conference talk is a masterclass in how to transform legacy, code-heavy systems into a knowledge-first architecture. The 90% code reduction isn't hype. It's what happens when you replace imperative logic with declarative rules.

## The Shift Nobody Talks About

The data industry spent the last decade optimizing for storage efficiency, query performance, and pipeline reliability. These problems are largely solved. What's not solved is meaning.

We can move petabytes across clouds. We can run complex transformations in seconds. We can monitor freshness and volume with precision. But we still build systems where "active customer" means something different to every team that uses the term.

Knowledge graphs on Snowflake represent a different bet: that the next decade of value comes from encoding what data means, not just how to store it. That relationships between entities are as important as the entities themselves. That reasoning, not just querying, is what organizations actually need.

Snowflake started as a data warehouse. It's becoming the substrate for organizational knowledge. The companies that figure out how to use that capability will have an unfair advantage over those still treating their data cloud as a big spreadsheet.

The Great Artesian Basin has been forming for two million years. It takes a million years for water to flow from entry to exit. The knowledge graph that models it was built in weeks.

That's the shift.

---

*This is the kind of analysis I publish in Against Entropy. If you're building data systems and want practical frameworks for problems the vendors won't talk about, subscribe below.*
