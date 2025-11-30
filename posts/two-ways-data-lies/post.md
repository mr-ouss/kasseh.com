# The Two Ways Your Data Lies to You

*Syntactic drift vs. semantic drift.*

Last week I had lunch with two Snowflake executives. Smart people. Deep product knowledge. But when I brought up semantic drift, I watched something familiar happen: a slight pause, a careful nod, then a pivot to schema evolution features.

This happens every time.

The data industry has spent a decade building sophisticated tooling for one type of data failure while almost completely ignoring another. We can detect when a column disappears. We cannot detect when its meaning changes.

That second problem is the one that actually destroys companies.

## Two Types of Drift, Two Different Failures

Let me make this concrete.

**Syntactic drift** is when the structure of your data changes. A column gets renamed. A data type shifts from integer to string. A table disappears. An API starts returning a new field. These are structural changes to the shape of data.

**Semantic drift** is when the meaning of your data changes while the structure stays identical. The column is still called `customer_status`. It still contains strings. But six months ago "active" meant "logged in within 30 days" and now it means "has a valid subscription." Same column. Same data type. Completely different meaning.

Think of it like three cartographers mapping the same mountain. Each produces a topographic map with identical contour lines. The terrain is the same. But each cartographer calibrated their instruments differently. One map shows the peak at 14,200 feet. Another shows 8,900 feet. The third shows 5,200 feet.

All three maps are technically correct. All three passed quality checks. All three cartographers used calibrated instruments. And if you tried to coordinate a rescue mission using all three maps, you'd send teams to three different elevations.

The structure is identical. The meaning has diverged. That's semantic drift.

Here's why this distinction matters: syntactic drift breaks things loudly. Semantic drift breaks things silently.

When a column disappears, your pipeline throws an error. Your dbt model fails. Airflow sends you an alert at 3 am. You curse, you fix it, you move on. The system worked.

When the meaning of "active customer" quietly shifts because a product team updated their tracking logic, nothing breaks. Your dashboards still render. Your models still run. Your executive team still makes decisions. They're just making decisions on data that no longer means what they think it means.

## Where the Tools Actually Are

The modern data stack is remarkably good at catching syntactic drift. Let me walk through what exists:

**dbt** gives you schema tests. You can assert that columns exist, that they're not null, that they contain expected values. The newer data contracts feature lets you explicitly define the structure your models expect and fail builds when upstream changes break that contract. This is real progress for structural integrity.

**Matillion** has built entire workflows around schema drift detection. Their pattern for dynamic S3 files compares incoming schemas against expected schemas and halts pipelines when structures diverge. Their documentation treats "schema drift" as the primary data quality concern.

**Fivetran**, **Airbyte**, and most ELT tools now include schema change notifications. Column added? You get an email. Column removed? Pipeline pauses. Data type changed? Alert fires.

**Monte Carlo**, **Bigeye**, and the observability platforms monitor for freshness, volume, and schema anomalies. They'll tell you when a table stops updating or when row counts swing wildly.

All of this is genuinely useful. None of it catches semantic drift.

## The Gap No One Talks About

Here's a real scenario I've seen multiple times:
A company tracks "Monthly Active Users" across three teams. Marketing defines it as "unique visitors who viewed any page". Product defines it as "users who completed a core action". Finance defines it as "users tied to a paying account".
All three teams have dashboards. All three dashboards show a metric called "MAU." All three numbers are different. All three are technically correct according to their local definition.
Three maps of the same mountain. Three different elevations. All passing inspection.
Now imagine Product quietly changes their definition. They decide that viewing the settings page no longer counts as a "core action." They update their tracking. Their MAU drops 15%.
What breaks? Nothing. The column is still called mau. The data type is still integer. The pipeline runs perfectly. The schema tests pass. The data contract holds.
But now Product is making roadmap decisions based on a metric that diverged from what it meant six months ago. And no tool flagged it. 
The cartographer recalibrated their instruments. The contour lines didn't change. Only the elevation readings did.

## Why dbt's Semantic Layer Doesn't Solve This

dbt Labs has been building a semantic layer. It's good work. The idea is to centralize metric definitions so that "revenue" means the same thing whether you're querying from Looker, Hex, or a Python notebook.

This solves metric sprawl. It does not solve semantic drift.

The semantic layer ensures that when you query "revenue," you get the same calculation everywhere. But it cannot tell you when that calculation should change. It cannot tell you when the business meaning of "revenue" has evolved but the definition hasn't. It cannot tell you when the underlying data feeding that calculation has shifted in meaning.

The semantic layer is a distribution mechanism for definitions. It assumes the definitions are correct. That's a big assumption.

## What Matillion and the ELT Tools Miss

Matillion's schema drift detection is impressive engineering. They can dynamically infer schemas from messy CSV files, detect when columns appear or disappear, and route pipelines accordingly.

But read their documentation carefully. Every example is structural: "the addition of new columns, alterations in data types, or instances of missing data." They treat schema drift and data drift as synonyms. They're not.

The same pattern repeats across the industry. When vendors say "drift detection," they mean structural drift. They mean syntactic changes. They have no answer for semantic changes because semantic changes don't show up in metadata.

## The Uncomfortable Truth

Syntactic drift is a technical problem with technical solutions. You can write tests. You can build contracts. You can automate detection.

Semantic drift is harder. When the meaning of a business concept changes, it happens in meetings. It happens in Slack threads. It happens when a product manager updates a spec and forgets to tell the data team. It happens when a new analyst inherits a dashboard and interprets a column name differently than its creator.

No schema test catches this. No data contract prevents it. No observability platform detects it.

The question is whether you need a cultural fix or an architectural one. The answer is both, but the architectural solution is more complete than most people realize.

## The Solution That Exists But Nobody Wants

HHere's the part the data industry doesn't want to hear: this problem was solved decades ago. Ontologies. Knowledge graphs. Semantic technologies. The entire discipline of formal knowledge representation exists precisely to capture meaning, not just structure.
Dave McComb has been writing about this for years. His core argument is that most enterprise data problems stem from a fundamental architectural mistake: we treat applications as primary and data as a byproduct. Every system defines its own local vocabulary. "Customer" means something different in Salesforce than in your billing system than in your analytics warehouse. We then spend enormous effort reconciling these competing definitions downstream.
The alternative is data-centric architecture. You define your business concepts once, formally, in an ontology. "Customer" has explicit relationships to "Account," "Contract," "Transaction". These aren't column names. They're semantic definitions that encode what things mean and how they relate. Applications become views over this shared conceptual model rather than sources of competing truth.
Knowledge graphs operationalize this. Companies like RelationalAI are building graph capabilities directly into Snowflake, letting you layer semantic relationships over your existing warehouse. When you query "active customers," the system doesn't just return rows. It understands what "active" means in relation to "customer" and can enforce that meaning consistently.
This actually solves semantic drift. If your ontology defines "active" as "has logged in within 30 days", and someone wants to change that definition, they have to change the ontology. That change is versioned, visible, and propagates everywhere. You can't quietly update tracking logic in one system and have the meaning silently diverge.

## Why Almost Nobody Does This

So why isn't everyone using knowledge graphs and ontologies?
Because it requires the entire enterprise to commit to being data-centric. You can't bolt an ontology onto one team's workflow and call it done. The value comes from shared semantics across the organization. That means executive sponsorship, cross-functional governance, and a multi-year architectural transformation.
Most companies want a tool. They want something they can install, configure, and check off a list. Ontology-driven architecture isn't a tool. It's a worldview.
The vendors know this. Selling a schema testing feature is easy. Selling "restructure your entire relationship with data" is nearly impossible. So the industry keeps shipping incremental improvements to syntactic detection while ignoring the deeper problem.
RelationalAI, Stardog, and others are trying to lower the barrier. Graph databases have gotten easier. Semantic layer tools are borrowing concepts from the ontology world. But we're still far from a world where formal knowledge representation is the default.

## What Works Today (Without Boiling the Ocean)

If your organization isn't ready for full data-centric transformation, you can still reduce semantic drift. Here's what I've seen work:

**Metric registries with enforced ownership.** Every business-critical metric has an owner. Changes require approval. This sounds bureaucratic until you realize the alternative is silent data corruption.

**Definition-as-code with mandatory context.** The calculation lives in version control. But so does the business context: why this definition exists, what assumptions it encodes, when it was last validated against business intent.

**Regular reconciliation rituals.** Quarterly sessions where data teams sit with business stakeholders and verify that the numbers still mean what everyone thinks they mean. Tedious. Essential.

**Semantic versioning for metrics.** When a metric definition changes materially, it gets a new version. The old definition remains available for historical comparison. Downstream consumers must explicitly opt into the new version.

These are band-aids. They manage semantic drift rather than eliminating it. But they're achievable without a five-year transformation program.

The honest answer is that the complete solution exists. It just requires more commitment than most organizations are willing to make.

## The Real Conversation

When I talk to data leaders, I ask two questions.

First: "When was the last time you verified that your top five metrics still mean what your executive team thinks they mean?"

The honest answer is usually "never" or "I don't know."

Second: "Would your organization commit to defining business concepts formally and governing them across every system?"

The honest answer is usually a long pause followed by "that would be hard".

That's the gap. Not schema tests. Not data contracts. Not observability platforms. The gap is that we've industrialized the detection of structural failures while ignoring the silent corruption of meaning. And the solutions that actually address meaning require more organizational commitment than most companies are willing to make.

Syntactic drift is solved, or at least solvable. The tools exist. The patterns are documented. The industry has moved on.

Semantic drift has a solution too. Ontologies. Knowledge graphs. Data-centric architecture. The theory is mature. The technology works. But adoption requires treating data as a strategic asset rather than a byproduct of applications.

Until that shift happens, we'll keep building dashboards that lie to us politely.

The data doesn't break. It just stops being true.

---

*This is the kind of analysis I publish in Against Entropy. If you're building data systems and want practical frameworks for problems the vendors won't talk about, subscribe below.*
