# CLAUDE.md

## Repository

This is the content repository for [www.kasseh.com](https://www.kasseh.com)
and the Against Entropy newsletter by Quentin Kasseh.

**Canonical URL:** `https://www.kasseh.com` (always with `www`)

## Key Paths

- Posts: `posts/{slug}/` (post.md, meta.json, schema.json, images/)
- Organizations library: `orgs/organizations.json`
- Schema template: `templates/article-schema.json`
- Ghost sync script: `scripts/ghost_sync.py`
- Ghost push script: `scripts/ghost_push.py`

## Conventions

- No em dashes anywhere (prose, comments, commit messages)
- Punctuation outside quotation marks (British/logical style)
- Post slugs: lowercase, hyphens, no special characters
- `metaTitle`: max 60 characters
- `excerpt`: max 300 characters
- `metaDescription`: max 145 characters
- Verify character counts with `echo -n "[text]" | wc -c`
- `schema.json` is a raw `<script type="application/ld+json">` block,
  not wrapped in a JSON object
- All schema URLs use `https://www.kasseh.com`
- `datePublished`/`dateModified` are placeholders until actual publish

## Writing Rules

Load the `kasseh-writing-guide` skill for full rules. Summary:

- No AI phrases: "leverage," "landscape," "cutting-edge," "delve,"
  "dive in," "robust," "utilize," "synergy"
- No negative contrast: "it's not X, it's Y"
- No generic claims: "everyone knows," "nobody talks about"
- No invented anecdotes
- Start with problems, not solutions
- Real tool names, column names, specific scenarios
- Ontology is grounded in business meaning first; data maps to it

## Ghost Sync

Pull latest from Ghost to keep repo in sync:

```bash
uv run scripts/ghost_sync.py
```

Requires 1Password CLI signed in. Reads API key from
`op://Private/ghost-content-api-key/credential`.

## Ghost Push

Push a local post to Ghost as a draft (or update an existing draft):

```bash
uv run scripts/ghost_push.py posts/{slug}/
```

Requires 1Password CLI signed in. Reads Admin API key from
`op://Private/ghost-admin-api-key/credential`.

The script tracks the Ghost link via `.ghost.json` in the post directory.
First run creates a draft; subsequent runs update it. See the
kasseh-ghost-push skill for details.

---

# Content Debate Engine -- Orchestration Rules

## Content workflow

When the user says "write about [topic]", "new post [topic]", "draft
[topic]", or asks to write a blog post or essay for Against Entropy,
activate the content debate protocol using these subagents:

- **kasseh-thesis-agent** -- owns the argument, produces the hardened thesis
- **kasseh-adversary-agent** -- stress-tests the thesis, finds weaknesses
- **kasseh-structure-agent** -- designs the essay architecture
- **kasseh-draft-agent** -- writes prose section by section
- **kasseh-editor-agent** -- flags violations, produces edit reports
- **kasseh-ghost-publisher** -- packages files for kasseh.com publication

### Starting a session

The user provides a topic seed. This can be:
- A phrase: "semantic drift and AI agents"
- A question: "why does nobody talk about meaning governance?"
- A reaction: "I want to respond to the Gartner DI MQ"
- A rough direction: "something about the gap between semantic layers
  and actual semantics"
- A partial draft or notes they've already written

Collect the seed and any additional context before starting Phase 1.

### Working directory

All intermediate artifacts and final output live in the kasseh.com content
repo under the `posts/` directory:

```
/Users/kasseh/Projects/Personal Utilities/kasseh.com/posts/[post-slug]/
```

Create this directory at the start of the session. The `post-slug` is
derived from a working title (can be revised later). Use lowercase,
hyphens for spaces, no special characters.

This matches the structure used by `ghost_sync.py` and all existing
published posts. Never write post directories to the repo root.

Write these files as the workflow progresses:
- `thesis.md` -- output of the thesis/adversary debate
- `outline.md` -- structural brief from kasseh-structure-agent
- `draft.md` -- working draft, built section by section
- `edit-report.md` -- kasseh-editor-agent's violation flags
- `post.md` -- final approved draft (promoted from draft.md)
- `meta.json` -- Ghost metadata
- `schema.json` -- structured data for code injection

### Debate protocol

**Parsing agent signals:**
- The **kasseh-thesis-agent** ends every response with
  `VERDICT: NEEDS CHALLENGE` or `VERDICT: HARDENED`. If `NEEDS CHALLENGE`,
  route to kasseh-adversary-agent. If `HARDENED`, present to user for
  approval.
- The **kasseh-adversary-agent** ends every response with
  `CONVERGENCE: YES` or `CONVERGENCE: NO -- [reason]`. If `YES`, the
  thesis has survived. If `NO`, relay objections to kasseh-thesis-agent
  for revision.
- The **kasseh-structure-agent** ends every response with
  `VERDICT: COMPLETE`. Present to user for approval.
- The **kasseh-draft-agent** ends every response with
  `VERDICT: SECTION COMPLETE`, `VERDICT: DRAFT COMPLETE`, or
  `VERDICT: REVISION COMPLETE`.
- The **kasseh-editor-agent** ends every response with
  `CONVERGENCE: YES` or `CONVERGENCE: NO -- [n hard failures, m soft failures]`.

---

**Phase 1: Thesis Debate**

1. Send topic seed and any user context to kasseh-thesis-agent: "Produce a
   thesis document from: [seed]"
2. Write the thesis document to `posts/[slug]/thesis.md`
3. Send thesis to kasseh-adversary-agent: "Challenge this thesis. [thesis]"
4. If adversary returns `CONVERGENCE: NO`, relay objections to
   kasseh-thesis-agent: "Address these objections. [objections]"
5. Thesis-agent revises. Update `thesis.md`. Send revision back to
   kasseh-adversary-agent.
6. Repeat until adversary returns `CONVERGENCE: YES` or 3 rounds complete.
7. If same objection bounces 3+ times, surface it to the user as a
   decision point.
8. Present the hardened thesis to user. Get approval before proceeding.

**User checkpoint:** Approve hardened thesis, request changes, or redirect.

---

**Phase 2: Structure**

1. Send hardened thesis to kasseh-structure-agent: "Design the structural
   brief. Thesis at `posts/[slug]/thesis.md`."
2. Write the structural brief to `posts/[slug]/outline.md`
3. Present to user for approval.

**User checkpoint:** Approve structure, request changes to archetype or
section design.

---

**Phase 3: Draft**

1. For each section in the structural brief, send to kasseh-draft-agent:
   "Write section [n]: [title]. Brief at `posts/[slug]/outline.md`.
   Prior sections at `posts/[slug]/draft.md`."
2. Append each completed section to `posts/[slug]/draft.md`
3. After all sections: kasseh-draft-agent returns `VERDICT: DRAFT COMPLETE`
4. Proceed directly to Phase 4 (no user checkpoint).

---

**Phase 4-5: Edit + Revise**

1. Send complete draft to kasseh-editor-agent: "Review this draft. Draft at
   `posts/[slug]/draft.md`. Brief at `posts/[slug]/outline.md`."
2. Write edit report to `posts/[slug]/edit-report.md`
3. If kasseh-editor-agent returns `CONVERGENCE: NO`, send violations to
   kasseh-draft-agent: "Revise these violations. Draft at
   `posts/[slug]/draft.md`. Violations: [list]."
4. Update `posts/[slug]/draft.md` with revisions.
5. Send revised draft to kasseh-editor-agent for re-validation.
6. Repeat until kasseh-editor-agent returns `CONVERGENCE: YES`.
7. Present clean draft and edit report to user.

If a specific violation bounces 3+ times between kasseh-draft-agent and
kasseh-editor-agent, surface it to the user as a judgment call.

**User checkpoint:** Review clean draft, approve for publishing or request
manual edits.

---

**Phase 6: Publish**

1. On user approval of the clean draft, send to kasseh-ghost-publisher:
   "Package for publication. Draft at `posts/[slug]/draft.md`."
2. kasseh-ghost-publisher writes `post.md`, `meta.json`, `schema.json` to
   `posts/[slug]/` and updates `organizations.json` if needed.
3. Present file set to user for final review.
4. Remind user to update `datePublished` and `dateModified` in
   `schema.json` before going live.
5. Offer to push the draft to Ghost:
   `uv run scripts/ghost_push.py posts/[slug]/`

**User checkpoint:** Final approval. User publishes the draft in Ghost.

---

### Orchestration rules

- Every kasseh-thesis-agent output must be validated by the
  kasseh-adversary-agent before the next phase.
- Track and announce phase transitions clearly.
- Present checkpoints at the end of each phase. Get user approval to
  advance.
- If the same objection or violation bounces 3+ times, surface it to
  the user as a decision point. Agents debate; the user decides.
- **Context management:** For articles with 5+ sections, persist all
  intermediate artifacts to the working directory as files rather than
  inlining content in delegation prompts. Reference file paths in
  delegations: "Read the structural brief from
  `posts/[slug]/outline.md`." This prevents context window overflow
  in long writing sessions.
- When delegating, include all prior artifacts in the prompt by reference
  (subagents have no memory between calls). For large artifacts,
  reference file paths instead of inlining.
- The user is the tiebreaker. Agents debate; the user decides.
- **Partial runs:** The user can start at any phase if they bring their
  own input. "Here's a thesis I've already hardened, skip to structure"
  is valid. "I have a draft, just run the editor" is valid. Adapt the
  workflow to what the user brings.
- **Existing drafts:** If the user provides a partial draft or notes,
  the kasseh-thesis-agent should work from those rather than starting
  from scratch. The user's existing thinking is the seed, not a blank
  page.
- **Ghost sync:** If the user wants to revise an existing published post,
  run `uv run scripts/ghost_sync.py` first to ensure the repo has the
  latest version from Ghost. See the kasseh-ghost-sync skill for details.
- **Ghost push:** After Phase 6 packaging, push the draft to Ghost using
  `uv run scripts/ghost_push.py posts/[slug]/`. The script is idempotent:
  first run creates a draft, subsequent runs update it. See the
  kasseh-ghost-push skill for details.
