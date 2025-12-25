# What the Hell Is Entropy?

I keep having the same conversation.

I'm sitting with some VP of Data or a technical exec. Smart person. Big title. And at some point I say "entropy".

They nod. They always nod. But I can see them searching. *"Entropy. Physics. Something about disorder?"*

"You mean chaos?"

No. I don't mean chaos. Chaos is random. Entropy is inevitable. There's a difference, and it matters.

I named my newsletter Against Entropy. People think it's branding. It's not. It's the closest I can get to saying what the work actually is.

## The Coffee Problem

Make coffee. Pour in cream. Watch it swirl. Beautiful for about two seconds. Then it's brown. Mixed. Done.

Now unmix it.

You can't. I can't. Nobody can. Not with any tool that exists or will ever exist. Not if you sat there for a billion years. That cream is never coming back.

Here's what bothers me and maybe you as you're reading it: physics says it's allowed. Every molecule could, in theory, wander back to where it started. The math allows it.

But the math also tells you the odds. There are **astronomically more** ways for molecules to arrange themselves into "mixed" than into "separated". The ratio isn't just unfavorable. It has more digits than there are atoms in the observable universe.

![The weight of chance](/content/images/2025/12/the-weight-of-chance-1.png)

You're not beating those odds. Nobody is. Ever.

That's entropy. Not chaos. Not randomness. Just probability, playing out everywhere, all the time, in **one** direction.

[Ludwig Boltzmann](https://grokipedia.com/page/Ludwig_Boltzmann) figured this out in Vienna in the 1870s. He spent his whole career defending it while his colleagues called him crazy. He had the equation carved on his tombstone: "S = k log W". Then he killed himself in 1906, convinced he'd wasted his life.

Ten years later, every physics textbook in the world taught his ideas as settled fact.

I don't know what to do with that story. But I think about it every now and then.

## Time Only Runs One Way

Here's what nobody tells you in the pop science version: entropy is the only thing in physics that knows the **difference** between yesterday and tomorrow.

Throw a ball. It goes up, comes down. Film it, run the film backwards. Looks weird, but nothing breaks. The equations work fine in both directions.

Now film cream swirling into coffee. Run that backwards.

Everyone watching knows something is wrong. Not improbable. *"**Wrong**".* It violates something deeper than equations. It violates what we know about how the world actually works.

![The only way is forward](/content/images/2025/12/only-way-is-forward-1.png)

The [second law of thermodynamics](https://grokipedia.com/page/Second_law_of_thermodynamics): in any closed system, entropy stays flat or goes up. Never down. This has been tested more than any other prediction in science. Never failed. Not once.

This is why you remember yesterday but not tomorrow. Why causes come before effects. Why glass shatters but doesn't unshatter. Entropy picks a direction. That direction is time.

[Christopher Nolan](https://grokipedia.com/page/Christopher_Nolan) spent $200 million on **TENET** trying to fake time running backwards. Bullets flying into guns. Explosions reassembling. Let me correct this. He didn't fake it with CGI, but he cheated. He filmed actors walking backwards. Drove cars in reverse. Blew things up backwards and flipped the footage. Two hundred million dollars and the **only solution was practical effects**.

That's how fundamental this is.

## The Punchline

1948. Bell Labs. [Claude Shannon](https://grokipedia.com/page/Claude_Shannon) is trying to answer a simple question:

> How do you measure information?

He builds a formula. Turns out information is just resolved uncertainty. A message telling you something expected ("sun came up") carries almost nothing. A message that surprises you ("there's a horse in the server room") carries a lot.

Shannon shows his formula to John von Neumann, one of the scariest geniuses who ever lived. Von Neumann looks at it and laughs.

> "Call it entropy. Your equation is identical to Boltzmann's."

Not similar. Identical. Same math, completely different domain.

![Different worlds, same equation](/content/images/2025/12/different-worlds-same-equation-1.png)

Nobody fully understands why. **Information theory and thermodynamics have nothing obvious in common**. But they share the same equation.

The implication is uncomfortable: entropy is also about meaning and information. The universe is drifting toward a state where nothing new can happen and nothing surprising can be said.

## Order From Chaos

But here's the thing that keeps entropy from being purely depressing.

Sometimes, in the middle of all this drift toward disorder, order appears. Not because someone designed it. Not because there's a plan. It just... emerges.

A flock of birds moves like a single organism. Nobody's in charge. No bird knows the pattern. But the pattern exists.

Crystals form. Galaxies spiral. Markets find prices. Cities organize themselves into neighborhoods. Life itself is a temporary, local reversal of entropy, paid for by increasing entropy elsewhere.

![Nobody built this](/content/images/2025/12/nobody-built-this-1.png)

Self-organization. Emergence. Order that nobody ordered.

This doesn't contradict the second law. The universe overall still trends toward disorder. But locally, temporarily, structure can arise from chaos. Not despite entropy, but through it. The same forces that scatter also, sometimes, gather.

I find this weirdly hopeful. The game isn't rigged entirely against us.

## Why I Care About This

I've spent fifteen years building data systems. Built them, watched them fall apart, built more.

Here's what I learned: every system I've ever touched is fighting entropy. Every single one.

Code decays. Not from bugs. From drift. Requirements change, code doesn't. The architect who held the whole thing in her head leaves. Takes the mental model with her. A dozen engineers add a dozen patches. Nobody updates the docs because docs are boring and features ship product. The system keeps running. Stops making sense. But it runs, so nobody notices until disaster.

Data decays the same way. Column called `customer_status`. String type. Values: `active` or `inactive`.

- Six months ago "active" meant "logged in within 30 days"
- Then Product changed it to mean "has a valid subscription"

Nobody told the data team.
Same column. Same values. Completely different meaning.

![The Semantic Drift](/content/images/2025/12/semantic-drift.png)

I call this semantic drift. Structure stays intact while meaning dissolves. The pipeline runs fine. The dashboards look normal. Decisions get made on numbers that don't mean what anyone thinks.

Organizations decay too. Knowledge piles up in people's heads instead of docs. Processes outlive the problems that created them. Each team optimizes its corner while the whole drifts into incoherence.

Entropy doesn't blow things up. That would be obvious.

Entropy hollows things out. Systems keep running. They just stop meaning anything.

## What the Military Taught Me

I spent time at a military academy in Tunisia. Important time in my life.
But one thing I remember clearly: **the difference between amateurs and professionals** isn't talent. It's not skill either.

It's maintenance.

Amateurs build. Professionals maintain.

Building is fun. Greenfield. Visible progress. Dopamine every day. Something from nothing, and everyone notices.

Maintenance is invisible. Updating docs nobody reads. Rewriting code that wasn't broken. Having the same data quality argument for the fifteenth time, knowing you'll have it again next quarter.

Success in maintenance means nothing happened. Nothing broke. Entropy didn't win today.

Everyone wants to build. Almost nobody wants to maintain.

Entropy knows this. Entropy waits.

## What I Actually Do

I started [Syntaxia](https://www.syntaxia.com) because I kept walking into the same wreck. Different company, same disaster. Data hadn't corrupted. It had drifted. Structure intact, meaning gone.

This happens because companies spend money on building, never on maintaining. Six figures for a data platform. Zero for someone to make sure "revenue" means the same thing in all five dashboards.

So what does fighting entropy look like?

- **Lock down definitions.** When "revenue" means 5 things in 5 systems, that's entropy. Fix it with an ontology: formal, versioned, governed. One definition, pushed everywhere. [Dave McComb](https://www.amazon.com/Data-Centric-Revolution-Restoring-Enterprise/dp/1634625404) has been writing about this for decades.
- **Maintain the definitions.** Day-one accuracy is worthless if you've drifted by day 365. Versioning. Change control. Someone whose job is noticing when meanings slide.
- **Use graphs.** A [knowledge graph](https://grokipedia.com/page/Knowledge_graph) stores context, not just data. What things mean relative to each other. That's where you catch drift.
- **Write it down.** Code without explanation is entropy waiting. Architecture decisions made in meetings and never documented are entropy waiting. Every time you skip the writeup, you're betting future-you can reconstruct the context from nothing. You'll lose. At Syntaxia, we have a **decision log** in each **Basecamp** project (we use this project management) we use. The template is simple (title, owner, date, status, description, rationale). Do that, you'll thank me later.

## The Uncomfortable Part

You cannot beat entropy. Not permanently. The second law is the most tested prediction in physics. Entropy rises. Always. Eventually.

But "eventually" matters.

The sun burns out in 5 billion years. Still worth planting a tree. Entropy claims your codebase eventually. Still worth writing clean code.

Fighting entropy isn't about winning. It's about buying time. Making structures that hold longer than they otherwise would. Creating systems that stay meaningful for years instead of months.
This is **what separates craft from hacking**. Hackers build things that work today. Craftspeople build things that work tomorrow.

## Why I Named a Newsletter After This

There's a connection between entropy and everything else I write about.

I don't use AI to write my essays because AI produces averaging. The median take, polished look good and read well. Using it for creative work is a surrender to entropy. You become one more voice in the distribution, indistinguishable from the mean.

I care about semantic drift because it's entropy applied to meaning. The slow decay of the relationship between symbols and reality.

I care about knowledge graphs because they're the closest thing we have to entropy-resistant data architecture. Structure that encodes relationships, not just facts.

"Against Entropy" is a stance.

The easy path is to let things drift. Ship fast, don't document, move on to the next thing. It's faster. It's cheaper. It produces something that looks professional.

The hard path is to maintain. To sit with the unglamorous work of keeping systems coherent. To define terms and enforce them. To write documentation that someone might actually read in two years.

I choose the hard path not because I'm a purist, but because the hard path is the only one that produces work worth doing.

That's the newsletter. That's the company. That's the work.

Against Entropy.

---

*If you're building data systems and want practical frameworks for problems the vendors won't talk about, subscribe below.*

---

## Further Reading

- **On thermodynamic entropy:** [Sean Carroll's "From Eternity to Here"](https://www.amazon.com/Eternity-Here-Quest-Ultimate-Theory/dp/0452296544) is the best popular treatment of entropy I read.
- **On information entropy:** [James Gleick's "The Information"](https://www.amazon.com/Information-History-Theory-Flood/dp/1400096235) tells the story of Claude Shannon and the birth of information theory.
- **On data-centric architecture:** [Dave McComb's "The Data-Centric Revolution"](https://www.amazon.com/Data-Centric-Revolution-Restoring-Enterprise/dp/1634625404) explains why most enterprise data problems are actually architecture problems.
- **On semantic drift:** My article [The Two Ways Your Data Lies to You](/semantic-drift-vs-syntactic-drift/) goes deep on syntactic vs. semantic drift.
