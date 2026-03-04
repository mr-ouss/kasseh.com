In May 2025, Salesforce changed Slack's API terms of service, and they did it with the kind of corporate stealth that should make you nervous: no press conference, no blog post with a cutesy header about "the future of responsible AI", [just a terms update that banned third-party](https://www.reuters.com/business/salesforce-blocks-ai-rivals-using-slack-data-information-reports-2025-06-11/?ref=kasseh.com) applications from indexing, copying, or storing Slack messages on a long-term basis. Your company's messages, your institutional knowledge, your years of accumulated context, all locked inside Slack and accessible only through Salesforce's own Real-Time Search API.

The stated reason was data privacy. The actual reason was Agentforce, Salesforce's AI agent platform, which needs your organizational data to be worth anything at all.

A few months later, Meta updated WhatsApp's Business Solution Terms to kick every competing AI chatbot off the platform entirely. Microsoft Copilot got a disconnection notice. Every third-party AI service operating on WhatsApp was handed a January 2026 deadline to either leave voluntarily or be removed. Italy's antitrust authority called it what it was and ordered Meta to suspend the policy, the EU opened a parallel probe, but the intent had already been broadcast to everyone paying attention: Meta wanted WhatsApp's two billion users funneled through Meta AI and nothing else.

Call these what they are: territorial claims over something far more valuable than software licenses.

## The Acquisition Trail Tells the Story

Salesforce did more than lock down Slack. In fact, in November 2025, it closed an $8 billion acquisition of **Informatica**, swallowing the company's data catalog, governance tools, and master data management capabilities into its own platform.   
This follows **MuleSoft** at $6.5 billion, **Tableau** at $15.7 billion, and **Slack** itself at $27.7 billion. Each acquisition extends the same play, and the play requires no decoder ring: own every layer between your business data and whatever intelligence gets built on top of it, because controlling the pipe means controlling the product.

Glean, one of the more prominent enterprise AI search platforms, told its customers in plain language that the Slack changes would prevent them from adding Slack data to their search index or knowledge graph.

> Their exact words: the changes are "hampering your ability to use your data with your chosen enterprise AI platform".

Your data, your platform choice, hampered by someone else's business strategy. That framing should bother you more than it apparently bothers most people.

Meta's version is blunter but structurally identical. For millions of businesses worldwide, WhatsApp has become the primary channel for customer relationships, well beyond casual messaging, and that conversational data (purchase patterns, support interactions, the texture of how a company actually talks to its customers) is exactly what makes AI models useful for a specific business rather than generically impressive. Meta wants that value captured exclusively by Meta AI, and when Italy's regulators intervened, Meta's defense was that WhatsApp isn't "a de facto app store" and that competitors can reach customers through other channels. Which is a bit like saying a restaurant that controls the only road into town isn't a monopoly because people could technically parachute in.

The playbook is remarkably consistent across all of them: make the data easy to generate, painful to extract, and impossible to use anywhere else.

## Everyone Says "Data Is the New Oil" and Nobody Says Who's Drilling on Your Land

The common observation is that whoever owns the data wins, and it's the kind of insight that sounds smart at conferences but fails to tell you anything useful about what's happening right now. True, sure. Also completely insufficient.

What these companies are doing is **converting** **systems of record** into **systems of capture**, and the thing being captured goes well beyond data in the way most people think about it. The thing being captured is meaning.

Your Slack messages carry your organization's decision-making context: who fought about the product roadmap and why, which vendor your team picked and on what basis, what "priority" actually signals when your VP types it in #leadership versus when an individual contributor types it in #bugs. Institutional meaning accumulates across thousands of conversations over years of use, forming exactly the kind of contextual substrate that AI models need to stop being generically helpful and start being specifically valuable for your business.

Your CRM encodes a similar depth. Think about what lives inside it: your company's working definition of a "qualified lead", its understanding of how deals actually progress through stages, its implicit model of what "ready to close" looks like based on years of wins and losses.   
When Salesforce integrates Informatica's metadata management into Agentforce, the operation goes well beyond processing your records more efficiently. **Salesforce is extracting your ontology, the conceptual model your business actually runs on, and packaging it into AI agents** that it will sell back to you as a feature upgrade.

For twenty years, the arrangement between enterprise software vendors and their customers was straightforward: you pay for the software, you generate the data, the data is yours.

That deal is being rewritten. **The new arrangement is that you pay for the software, you generate the data, and then you pay a second time to access the intelligence that your own data made possible**. Nobody held a vote on this. Nobody asked for your consent. They just changed the terms of service.

## The Meaning Tax

Think of it as a tax on your own institutional knowledge. You spend years building context inside these platforms as conversations pile up, relationships form, and definitions crystallize through daily use. Then the platform owner drops a gate between you and the intelligence layer, and the only key that opens it is their AI product.

**Marc Benioff**, announcing the Informatica acquisition, put it plainly:

> "Data and context is the true fuel of Agentforce, and without clean, connected, trusted data there is no intelligence, only hallucination"

He's right about the dependency. He's just being very strategic about whose data and context he's describing, because every word of that sentence applies to your organization's information, captured inside his platform.

When Salesforce blocks Glean from indexing your Slack messages, the move protects Salesforce's competitive moat, full stop. The privacy argument collapses the moment you notice that Salesforce itself can still access, index, and process every single message through its own AI products. The data is being shielded from competitive exploitation while remaining fully available for Salesforce's own. "We're reinforcing safeguards around how data accessed via Slack APIs can be stored, used, and shared" is the official line, and translated from corporate into English, it means: we're making sure the only AI that gets to eat this data is ours.

The oldest trick in enterprise software still works: dress up a business power grab in the language of security and governance, and everyone in the room nods along without asking follow-up questions.

## The Lock-In That Should Worry You

Traditional vendor lock-in is annoying but fundamentally survivable. Switching CRMs is painful, sure. You export contacts, opportunities, and activity logs, it takes months, it costs real money, and people complain throughout the entire process. But when it's done, it's done, and you can move on with your business.

Meaning doesn't export. The implicit ontology that formed over a decade of daily use has no CSV format. Nobody (nobody yet, check what [Syntaxia](https://www.syntaxia.com/?ref=kasseh.com) does) has built a migration tool for the contextual web that connects a Slack thread about a pricing concern to a CRM opportunity that stalled for three months to a Tableau dashboard that showed the revenue impact to a decision made by your CEO in a Thursday morning pipeline review. That web of connected meaning is what makes AI agents genuinely useful for your specific business rather than just another chatbot generating plausible-sounding nonsense. Generic models hallucinate. Models trained on your accumulated context actually perform. And now the platform that holds all of that context is telling you there's exactly one AI provider authorized to make sense of it.

Vendor lock-in of a completely different species. The cost of leaving isn't measured in migration fees or engineering hours. The cost is that the thing which makes leaving worthwhile, the intelligence built on your institutional meaning, stays behind when you walk out the door. And unlike a CRM migration, there's no consulting firm that can help you move it, because nobody has ever had to do that before and the platforms are making sure nobody figures out how.

## The Architecture Problem Underneath All of This

[Dave McComb](https://www.linkedin.com/in/davemccomb?ref=kasseh.com) has been writing for years about the original sin of enterprise software: treating applications as primary and data as a byproduct, so that every system invents its own vocabulary and "Customer" means one thing in Salesforce, another in HubSpot, and something else entirely in your data warehouse. We then burn enormous effort reconciling these competing definitions downstream, which is expensive and demoralizing but at least was a problem you could throw engineers at.

**The AI lock-in problem is that same mistake replicated one level up.** We treated platforms as primary and meaning as a byproduct. We let Salesforce define what "qualified lead" means operationally for our organizations. We let Slack become the system of record for institutional decisions that never got documented anywhere else. We let these platforms accumulate the conceptual model of our businesses over years without ever bothering to extract it, version it, or govern it independently, because the data felt like ours even as the meaning was silently becoming theirs.

Now those platforms are saying something that shouldn't surprise anyone but somehow does: that conceptual model powers our AI, and our AI is the only one allowed to touch it.

The fix is the same one McComb has been advocating for decades, just applied to a new and more urgent problem: **externalize your ontology**. Define your business concepts formally, in a system you own, outside any vendor's walls. Own the semantic layer that describes what your data means rather than just how it's structured. If your definitions of "active customer", "qualified pipeline", and "strategic account" **live in a** [**knowledge graph**](https://www.kasseh.com/a-knowledge-graph-is-not-a-technology/) **you control,** then **no single platform can hold your meaning hostage** regardless of what they do with their API terms. [The two ways your data lie to you](https://www.kasseh.com/semantic-drift-vs-syntactic-drift/).

Most companies don't even know they have an implicit ontology, which is the real vulnerability here. They've never thought about it because the definitions just formed organically inside Salesforce and Slack and tools they don't own, like sediment accumulating at the bottom of a river you forgot you were swimming in. Salesforce, Meta, and every other platform giant understand this better than their customers do, and they are moving fast to capitalize on that asymmetry.

## What to Do Before It Gets Worse

You're not ripping out Salesforce this quarter. I know. But a few things actually help if you take them seriously rather than treating them as items on a governance checklist that nobody reads.

**Audit your meaning dependencies,** and I mean meaning, specifically. Where does your organization's institutional knowledge actually live? Which platforms hold the context, definitions, and decision history that make your records interpretable? Those are your highest-risk positions, and most companies have never mapped them because nobody told them they should.

**Start externalizing definitions.** Build a metric registry, document what your key business terms mean formally and outside any vendor system, version those definitions, and track when they change. Boring, unglamorous, deeply unsexy work. Also the only insurance policy that will matter when Salesforce or whoever else decides to change their terms again.

**Treat data portability as a procurement weapon.** Before signing your next enterprise contract, ask whether you can export the relationships and metadata that make your records meaningful, beyond just the records themselves. If the vendor pauses or pivots to a speech about security and responsible data stewardship, you have your answer, and the answer is no.

**Watch the regulatory pressure, but don't count on it to save you.** Italy moved fast against Meta, and the EU's Digital Markets Act is creating real friction for platform owners. But regulators are structurally a step behind companies that can rewrite terms of service overnight, and these companies have legal teams the size of small armies with nothing to do but find creative workarounds for whatever rules get written. Build your own exit before someone else decides to board up the door.

## The War

The data industry spent a decade arguing about pipelines, warehouses, and dashboards, and those were interesting problems that are now mostly solved or at least solvable with off-the-shelf tooling.

**The next decade will be about meaning**: who defines it, who owns it, who gets to build intelligence on top of it, and who pays for the privilege. Right now the platforms have the advantage because they hold your data, they hold your context, and they're building walls faster than any regulator can tear them down, all while framing the whole operation as "responsible AI" and "data protection" which is a masterclass in saying one thing while doing the opposite.

But meaning doesn't have to live inside Salesforce, or Meta, or anyone else's infrastructure. **It can live in an ontology your organization governs, in a knowledge graph you control, in formal definitions that travel with your business regardless of which tools sit underneath**. The companies that figure this out in the next few years will have a structural advantage that compounds over time, because owning what your data means turns out to be worth considerably more than owning the data itself.

Everyone else will keep renting their own intelligence from landlords who have absolutely no reason to stop raising the price.

💡

****A note on process****  
Everything you just read was written by a human.   
The illustrations were drawn by hand. I don't use AI to generate content for Against Entropy.   
If you want to know why, or how these essays come together, [here's the process.](https://www.kasseh.com/why-i-dont-use-ai-to-write/)
