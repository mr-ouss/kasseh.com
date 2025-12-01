# What the Hell Is Entropy? (And Why I Named My Newsletter After Fighting It)

Everyone knows entropy exists. Almost nobody can explain it without sounding like a physics textbook or a LinkedIn influencer.

I named my newsletter "Against Entropy" not because I wanted to sound clever, but because it describes the only work I've ever found worth doing. Before I get into what that means for data systems, let me tell you what entropy actually is. Not the hand-wavy version. The real thing.

## The Coffee Cup Problem

Pour cream into black coffee. Watch it swirl. Wait thirty seconds.

You now have brown coffee. Uniform. Mixed. And here's the strange part: you will never, not once in the history of this universe, watch that brown coffee spontaneously separate back into black coffee and white cream.

Why not?

Not because physics forbids it. Every molecule could, in theory, wander back to its original position. Nothing in the equations prevents it.

But the math also tells you the odds. There are astronomically more configurations that look "mixed" than configurations that look "separated." The ratio has more zeros than there are particles in existence. You could wait until every star burns out and you still wouldn't see it happen.

This is entropy. Not "disorder" in some vague sense. A precise mathematical claim: systems drift toward configurations that have more ways of being realized.

The Austrian physicist [Ludwig Boltzmann](https://grokipedia.com/Ludwig_Boltzmann) worked this out in the 1870s and spent his remaining years defending the idea against colleagues who thought he'd lost his mind. He had the equation carved into his tombstone. S = k log W. The link between entropy (S) and the count of possible configurations (W). He died believing he'd failed to convince anyone. A decade later, the scientific community agreed he'd been right all along.

## The Arrow of Time

Here's the strange thing about entropy: it's the only physical law that distinguishes past from future.

Toss a ball in the air. It goes up, comes down. Play the video in reverse and you see a ball going up, then coming down. Odd looking, but the physics permits it either way. Newton's equations work identically forward and backward.

Now play a video of cream swirling into coffee, then run it backward. Anyone watching knows immediately that something's off. The unmixing doesn't just look improbable. It looks wrong.

Entropy is what gives time its direction. It explains why we have memories of yesterday but not tomorrow. Why effects follow causes. Why buildings crumble into rubble but rubble never reassembles itself into buildings.

The [second law of thermodynamics](https://grokipedia.com/Second_law_of_thermodynamics) states that entropy within an isolated system never decreases. It can stay flat. It can climb. It cannot fall. This is the deepest asymmetry we know of in the physical world.

Everything disperses. Everything dilutes. Everything blends.

## From Physics to Information

In 1948, [Claude Shannon](https://grokipedia.com/Claude_Shannon) (yes, his actual name) was working at Bell Labs on what seemed like a narrow engineering question: how do you put a number on information? If you're transmitting a message down a telegraph wire, what exactly have you sent?

Shannon figured out that information and uncertainty are two sides of the same coin. A message carries information to the degree that it resolves uncertainty. Tell me "the sun came up this morning" and you've communicated almost nothing. I already expected that. Tell me "there's a rhinoceros standing in your kitchen" and you've communicated quite a lot. I did not see that coming.

Shannon needed a formula to capture this. He derived one. Then he showed it to John von Neumann, who told him to name it "entropy" because the formula matched Boltzmann's thermodynamic version exactly.

This wasn't an analogy. It wasn't a metaphor. The underlying mathematics are identical.


**Information entropy** captures average surprise. When entropy is high, you have high uncertainty, many possible outcomes, substantial information conveyed when you learn the answer. When entropy is low, outcomes are predictable, possibilities are few, and learning the answer tells you little.

The bridge between physics and [information theory](https://grokipedia.com/Information_theory) ranks among the most profound discoveries of the twentieth century. At some bedrock level, heat and information obey the same laws. The universe is slowly exhausting its capacity to surprise.

## Entropy and Art

Here's where it gets interesting.

Every artist is fighting entropy. Not as a metaphor. Literally.

Consider what a painting is. Canvas and pigment, left to themselves, tend toward brown mush. Colors fade. Fibers decay. Meaning dissolves. A painting is a temporary configuration of matter that imposes structure. It declares: "These specific molecules, arranged precisely this way, for this brief window."

The painter [Robert Smithson](https://grokipedia.com/Robert_Smithson) grasped this better than almost anyone. His most famous piece, *Spiral Jetty*, is a 1,500-foot coil of mud and basalt extending into Utah's Great Salt Lake. He constructed it knowing it would erode. Knowing the lake level would rise and fall, burying and revealing it. Knowing entropy would ultimately win.

That was the point.

[IMAGE SUGGESTION: Spiral Jetty aerial photograph]

Smithson described his work as "entropy made visible." He wasn't resisting entropy. He was working alongside it, creating art that admitted its own transience.

Music operates the same way. A song is structure carved out of silence. The composer shapes sound waves into configurations that push back against the pull toward noise. Then the final note fades, the reverberations die, and quiet returns. Entropy claims another victory.

The Japanese have a phrase for this: *mono no aware*. The bittersweet recognition of impermanence. Cherry blossoms are beautiful because they fall. The song moves us because it ends.

Art that pretends to permanence is telling a lie. Art that acknowledges entropy is telling the truth about our universe.

## Entropy in Systems

Now we arrive at the part that matters for my work.

Every system you've ever built is battling entropy. Your codebase, your data warehouse, your organization, your documentation. All of it.

Left unattended, code degrades. Not from bugs. From the gap between changing requirements and static implementation. From the architect who left and took the mental model with them. From twelve engineers making twelve "quick patches" with no one updating the shared understanding. The code still executes. It just stops making sense.

Left unattended, data degrades. I've written about this at length in [The Two Ways Your Data Lies to You](/two-ways-data-lies). A column named `customer_status` still holds strings. The pipeline still completes. But six months ago "active" meant "logged in within 30 days" and now it means "has a valid subscription." Same structure. Different meaning. Entropy didn't destroy your data. It severed the link between your data and reality.

[IMAGE SUGGESTION: Diagram showing same data structure with silently changing meaning over time]

Left unattended, organizations degrade. Tribal knowledge piles up in individual heads instead of shared documentation. Processes that fit one context persist long after that context disappeared. Teams optimize their own corners while system-wide coherence erodes. Everyone is busy. No one knows why.

This is the pattern: **entropy doesn't destroy systems. It drains them of meaning**.

The building doesn't collapse. It becomes uninhabitable. The data doesn't vanish. It stops being true. The organization doesn't dissolve. It stops functioning.

## Why "Against Entropy"

So why name a newsletter after this?

Because fighting entropy is the only game worth playing.

I spent time in a military academy in Tunisia. It taught me uncomfortable lessons about discipline, commitment, and showing up when you'd rather not. One insight stayed with me: the difference between amateurs and professionals isn't talent. It's maintenance.

Amateurs build things. Professionals maintain them.

Building is the fun part. Blank slate. Imposing order on chaos. Visible progress every day. Dopamine on demand.

Maintaining is the hard part. Fighting decay. Updating documentation nobody reads. Refactoring code that already works. Having the same data quality conversation for the fifteenth time. Progress is invisible because progress means things didn't get worse.

Most people want to build. Almost nobody wants to maintain. That's why entropy wins so often.

I started [Syntaxia](https://syntaxia.io) because I kept seeing the same pattern: companies drowning in data that technically exists but practically means nothing. Dashboards that render correctly while telling lies. Metrics that everyone uses and nobody trusts. The data didn't break. It degraded.

[Semantic drift](/two-ways-data-lies) is what I call this phenomenon. The silent corruption of meaning. And it happens because organizations don't invest in maintenance. They build pipelines but not governance. They hire analysts but not ontologists. They buy tools but not discipline.

## What Fighting Entropy Looks Like

I want to be concrete here.

Fighting entropy in data systems means:

**Defining things once and enforcing those definitions everywhere.** When "revenue" means five different things across five dashboards, that's not a technical problem. That's entropy. The fix isn't a better BI tool. It's an ontology: a formal, versioned, governed specification of what "revenue" means, propagated across every system. [Dave McComb](https://www.amazon.com/Data-Centric-Revolution-Restoring-Enterprise/dp/1634625404) has been making this case for years. Almost nobody does it because governance is less exciting than building new dashboards.

**Maintaining semantic integrity over time.** Defining things correctly on day one isn't enough. You have to keep them correct on day 365 and day 1,000. This requires change management. Versioning. Active stewardship. Boring, essential work.

**Investing in knowledge graphs and ontologies.** These aren't buzzwords. They're technologies built specifically to capture and preserve meaning. A relational database stores facts. A [knowledge graph](https://grokipedia.com/Knowledge_graph) stores facts plus the connections between them. That relationship layer is what allows you to notice when meanings start to drift.

**Treating documentation as a first-class deliverable.** Code without documentation is entropy waiting to happen. Architecture without rationale is entropy waiting to happen. Decisions without context are entropy waiting to happen. Writing things down is maintenance. Maintenance is the work.

## The Uncomfortable Truth

Here's the part nobody wants to hear.

You cannot defeat entropy. Not in the long run. The second law stands as the most thoroughly tested prediction in all of physics. Entropy climbs. Always. Eventually.

But "eventually" matters.

The sun will exhaust its fuel in about five billion years. That doesn't mean you shouldn't plant a tree. Entropy will someday claim your codebase. That doesn't mean you shouldn't write clean code. Your data governance program will eventually be forgotten by employees who won't understand why it mattered. That doesn't mean you shouldn't build it.

Fighting entropy isn't about victory. It's about extending the window of meaning. Building systems that hold together longer than they otherwise would. Creating structures that persist, even knowing they won't persist forever.

This is what separates craft from hacking. Hackers build things that work today. Craftspeople build things that work tomorrow.

## Why This Matters Now

We're in the middle of an interesting moment.

AI can produce content faster than humans ever could. This is remarkable for productivity. It's also an entropy accelerator. More data. More documents. More code. More dashboards. All generated instantly, with no maintenance plan.

The bottleneck is no longer creation. It's curation. It's knowing what's true.

An organization that generates ten thousand AI-written documents per week without any system for verifying their accuracy has an entropy problem, not a productivity gain. They've traded signal for noise.

The companies that will matter in ten years aren't the ones generating the most content. They're the ones preserving the most coherence. They're the ones who figured out how to fight entropy at scale.

## The Work

I write Against Entropy because I believe the work matters.

Not the glamorous work of building new AI models or launching startups or announcing features. The mundane work of preserving meaning. Of defining terms. Of governing data. Of writing documentation that future engineers will actually read.

Engineers are artists who often don't know it. We compose systems the way composers shape sound. We make choices about elegance, tension, resolution. The best code has rhythm. The best architectures have a point of view.

And like all artists, we're fighting entropy. Trying to carve temporary order out of a universe that trends toward disorder. Knowing we won't win forever. Doing it anyway.

That's the newsletter. That's the company. That's the work.

Against Entropy.

---

*This is the kind of thinking I publish in Against Entropy. If you're building data systems and want practical frameworks for problems the vendors won't talk about, [subscribe here](#).*

---

## Further Reading

If this topic interests you, here's where to go deeper:

**On thermodynamic entropy:** [Sean Carroll's "From Eternity to Here"](https://www.amazon.com/Eternity-Here-Quest-Ultimate-Theory/dp/0452296544) is the best popular treatment of entropy, time, and cosmology I've encountered.

**On information entropy:** [James Gleick's "The Information"](https://www.amazon.com/Information-History-Theory-Flood/dp/1400096235) tells the story of Claude Shannon and the birth of information theory.

**On data-centric architecture:** [Dave McComb's "The Data-Centric Revolution"](https://www.amazon.com/Data-Centric-Revolution-Restoring-Enterprise/dp/1634625404) explains why most enterprise data problems are actually architecture problems.

**On semantic drift:** My article [The Two Ways Your Data Lies to You](/two-ways-data-lies) goes deep on syntactic vs. semantic drift and what to do about it.
