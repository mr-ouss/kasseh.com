---
name: against-entropy
description: Use when writing Against Entropy posts (kasseh.com). Runs the content debate engine via Hermes subagents (thesis, adversary, structure, draft, editor), captures Quentin's feedback into the learning loop, packages for Ghost.
---

# Against Entropy Content Engine (Hermes)

Multi-agent writing workflow for Quentin Kasseh's blog at www.kasseh.com and
the Against Entropy newsletter. This is the Hermes port of the Content Debate
Engine originally built for Claude Code. The repo is the source of truth for
all voice rules, agent roles, and post artifacts.

**Repo root:** `/Users/kasseh/Projects/Personal Utilities/kasseh.com`
(referred to as `$REPO` below)

Trigger phrases: "write about [topic]", "new post [topic]", "draft [topic]",
"revise [post]", or any request to produce or edit Against Entropy content.

---

## Session start protocol (always, before any content work)

Read these four files. Do not skip any:

1. `$REPO/skills/kasseh-writing-guide/SKILL.md` (voice, archetypes, language rules)
2. `$REPO/skills/kasseh-voice-reference/SKILL.md` (calibration excerpts)
3. `$REPO/analysis/feedback-log.md` (accumulated lessons from Quentin's feedback)
4. `$REPO/CLAUDE.md` (repo conventions, metadata limits, Ghost scripts)

From the feedback log, extract all entries with status `directive` or
`recurring` into an **Active Lessons** list. This list must be injected into
the context of every draft-agent and editor-agent delegation this session.

## Post directory layout

Every post lives at `$REPO/posts/[slug]/` (lowercase, hyphens, no special
characters). Never write post dirs at repo root. Artifacts:

- `thesis.md` (hardened thesis from debate)
- `challenge-round-N.md` (adversary objections per round)
- `outline.md` (structural brief)
- `draft.md` (working draft, built section by section)
- `edit-report.md` (editor violations)
- `post.md` (final approved draft)
- `meta.json`, `schema.json` (Ghost metadata; limits in CLAUDE.md)

## Workflow phases

Each phase delegates to a Hermes subagent (leaf, no nesting). The agent role
definitions live in the repo and are passed BY PATH. Children read them
directly. Artifacts on disk are the truth: after every delegation, read the
artifact file the child claims to have written and verify the verdict line.
Child summaries are self-reports.

Standard delegation context block (include in every child):

```
You are playing a defined role. Read your role definition FIRST:
$REPO/agents/[path-to-role].md
Then load calibration:
$REPO/skills/kasseh-writing-guide/SKILL.md
$REPO/skills/kasseh-voice-reference/SKILL.md
Active Lessons (from Quentin's feedback, these OVERRIDE the guide where
they conflict): [inline the Active Lessons list]
Working post directory: $REPO/posts/[slug]/
Note: the role file mentions Claude Code skills/tools. Ignore frontmatter;
read the referenced skill files by path instead. Follow the role body,
including the exact VERDICT/CONVERGENCE line at the end of your summary.
Style hard rules: no em dashes anywhere, punctuation outside quotes.
Write your output to [artifact path] and end your summary with the verdict line.
```

### Phase 1: Thesis debate

1. Delegate to **thesis role** (`agents/content-shaping/kasseh-thesis-agent.md`)
   with the topic seed and any notes from Quentin. Child writes `thesis.md`.
2. If verdict is `NEEDS CHALLENGE`, delegate to **adversary role**
   (`agents/content-shaping/kasseh-adversary-agent.md`). Child reads
   `thesis.md`, writes `challenge-round-N.md`, returns `CONVERGENCE: YES/NO`.
3. On `NO`, delegate thesis role again to revise `thesis.md` addressing the
   challenge file. Loop until `CONVERGENCE: YES` or 3 rounds.
4. Same objection bouncing 3+ times: stop, surface to Quentin as a decision.
5. **Checkpoint:** present hardened thesis to Quentin. Wait for approval.

### Phase 2: Structure

1. Delegate to **structure role**
   (`agents/content-shaping/kasseh-structure-agent.md`). Child reads
   `thesis.md` and challenge files, writes `outline.md`.
2. **Checkpoint:** present archetype choice and section design to Quentin.

### Phase 3: Draft (serial, never parallel)

1. One delegation per section, in order. Each child reads `outline.md`,
   `thesis.md`, and the current `draft.md`, then APPENDS its section to
   `draft.md`. Sections must be serial: voice continuity depends on reading
   prior prose. Never batch sections in parallel.
2. Verify each append landed before dispatching the next section.
3. Role: `agents/content-production/kasseh-draft-agent.md`.

### Phase 4-5: Edit loop

1. Delegate to **editor role**
   (`agents/content-production/kasseh-editor-agent.md`). Child reads
   `draft.md` + `outline.md` + Active Lessons, writes `edit-report.md`,
   returns `CONVERGENCE: YES/NO`.
2. On `NO`, delegate draft role with the specific violations for targeted
   revision. Re-run editor. Loop until `CONVERGENCE: YES`.
3. Violation bouncing 3+ times: surface to Quentin as a judgment call.
4. **Checkpoint:** present clean draft + edit report summary to Quentin.

### Phase 6: Iterate with Quentin (THE core phase)

This is where the engine earns its keep. Quentin reads the draft and gives
feedback. For EVERY piece of feedback, no matter how small:

1. Apply it to the draft (directly or via a targeted draft-role delegation).
2. Capture it in the feedback log IMMEDIATELY (see protocol below). Never
   batch captures for later; later never comes.
3. Confirm the revised passage with him before moving on when the change is
   interpretive (tone, angle); skip confirmation for mechanical fixes.

### Phase 7: Package and publish

1. Promote approved `draft.md` to `post.md`. Produce `meta.json` and
   `schema.json` per `$REPO/CLAUDE.md` limits (metaTitle 60, excerpt 300,
   metaDescription 145; verify with `echo -n "..." | wc -c`). The publisher
   role file (`agents/content-production/kasseh-ghost-publisher.md`) has the
   full spec; this step can be done by the orchestrator directly, no
   delegation needed.
2. Update `$REPO/orgs/organizations.json` for newly mentioned companies.
3. Ask Quentin before pushing: `uv run scripts/ghost_push.py posts/[slug]/`
   (creates or updates a Ghost DRAFT; requires 1Password CLI signed in).
   Run from `$REPO`.
4. Remind him: `datePublished`/`dateModified` in schema.json are placeholders
   until actual publish.
5. Offer to commit the post dir + any feedback-log/guide changes to git.

### Partial runs

Quentin can enter at any phase. "Here is a thesis, skip to structure" is
valid. "I have a draft, run the editor" is valid. "Punch this paragraph up"
needs no delegation at all: apply the guide + Active Lessons directly. For
revising a published post, run `uv run scripts/ghost_sync.py` first so the
repo copy is current.

---

## Feedback capture protocol (the learning loop)

File: `$REPO/analysis/feedback-log.md`. Append-only during sessions. Format
is defined at the top of that file.

**Capture rule:** any time Quentin corrects, redirects, or expresses a
preference about the writing (word choice, rhythm, density, structure,
angle, examples, titles, anything), append an entry with:

- date, post slug, phase
- what he said (short, faithful paraphrase or quote)
- the before/after when it is a concrete edit
- the GENERALIZED rule (written so it applies to future drafts)
- status: `raw` (seen once), `recurring` (2+ occurrences), `directive`
  (explicit "always/never" from Quentin), `promoted` (now encoded in the
  writing guide), `retired` (superseded)

**Promotion rule:** when a lesson hits `recurring` or arrives as a
`directive`, propose a concrete patch to
`$REPO/skills/kasseh-writing-guide/SKILL.md` (show him the diff, get
approval, apply, then mark the log entry `promoted` with the date). The
guide is the compiled artifact; the log is the raw signal. Both are
git-versioned: commit after promotions.

**Injection rule:** Active Lessons (all `directive` + `recurring` entries
not yet `promoted`) go into every draft and editor delegation. Lessons
OVERRIDE the writing guide where they conflict; the conflict itself is a
signal the guide needs a promotion pass.

**Post-mortem (optional but offer it):** after a post ships, offer a retro:
diff `draft.md` (pre-feedback state, use git history) against final
`post.md`, extract patterns from what Quentin changed, log them.

---

## Hermes-specific notes

- Children are leaf agents: they cannot delegate further. The orchestrator
  (main session) runs the loop, parses verdicts, and owns all checkpoints.
- Never run thesis+adversary or draft sections in parallel; every step
  feeds the next. Parallelism is only safe for research side-quests.
- Children inherit the session model. The original engine pinned opus for
  shaping roles; quality of the shaping phases matters more than speed.
- Verify every child file write by reading the file. A child claiming
  "written" is not evidence.
- Ghost push/sync run in the MAIN session (1Password `op` CLI interaction),
  never in a child.
- Ask Quentin before any push to Ghost, any git push, and any write a
  client or teammate would see. Local repo writes and commits are fine to
  do proactively.

## Style invariants (enforce everywhere, including analysis files)

- No em dashes. Ever. Use commas, colons, periods, parentheses.
- Punctuation outside quotation marks (logical/British style).
- No AI-sounding phrases (full list in the writing guide).
- Metadata limits from CLAUDE.md are hard limits.
- These invariants apply to every artifact written into the repo, not just
  post prose.

## Related repo docs

- `$REPO/CLAUDE.md` (conventions + original orchestration spec)
- `$REPO/README.md` (repo layout, Claude Code installation, historical)
- `$REPO/analysis/voice-fingerprint.md` (corpus voice analysis)
- `$REPO/analysis/external-voice-references.md` (Koe density, Hormozi bluntness patterns)
