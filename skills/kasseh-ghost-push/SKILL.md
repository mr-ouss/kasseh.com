# Ghost Push

Push a local post directory to Ghost CMS as a draft, or update an
existing draft with local changes.

Use this skill when the user says "push to ghost," "create a draft on
ghost," "update the ghost draft," or when a post has been written or
revised locally and needs to be pushed to Ghost for preview or
publication.

---

## What it does

The `ghost_push.py` script connects to the Ghost Admin API, reads a
local post directory, and creates or updates a draft post on Ghost.
It reads:

- `post.md`: Markdown content, converted to HTML for Ghost
- `meta.json`: SEO metadata (`metaTitle`, `excerpt`, `metaDescription`)
- `schema.json`: JSON-LD structured data injected into Ghost's code
  injection header, and keywords extracted as Ghost tags

The script tracks the link between a local post and its Ghost draft
via a `.ghost.json` file in the post directory. This file is versioned
so the link persists across machines and clones.

## Prerequisites

1. **1Password CLI** must be installed and signed in. The script reads
   the Ghost Admin API key from 1Password:
   ```
   op://Private/ghost-admin-api-key/credential
   ```
   Create this key in Ghost Admin > Settings > Integrations > Custom
   Integration. Store it in 1Password in `id:secret` format.

2. **uv** must be installed. The script uses PEP 723 inline dependencies
   (`requests`, `PyJWT`, `markdown`), so it runs via `uv run` with no
   separate install step.

## How to run

```bash
uv run scripts/ghost_push.py posts/{slug}/
```

Example:

```bash
uv run scripts/ghost_push.py posts/closed-world-open-world-ontologies/
```

## What to expect

First run (no `.ghost.json`):

```
Ghost Push: closed-world-open-world-ontologies
  API: https://quentin-kasseh.ghost.io
  Dir: /Users/kasseh/.../posts/closed-world-open-world-ontologies

  Creating new draft...

  Created draft: Closed-World and Open-World Ontologies
  Ghost ID: 64f5b3c...
  Status: draft
  URL: https://quentin-kasseh.ghost.io/p/64f5b3c.../
```

Subsequent runs (`.ghost.json` exists):

```
  Updating existing draft (ID: 64f5b3c...)...

  Updated draft: Closed-World and Open-World Ontologies
  Ghost ID: 64f5b3c...
  Status: draft
```

## The .ghost.json file

After a successful push, the script writes `.ghost.json` in the post
directory:

```json
{
  "ghost_id": "64f5b3c...",
  "updated_at": "2026-04-12T15:30:00.000Z",
  "last_pushed": "2026-04-12T15:30:00.000Z",
  "status": "draft"
}
```

This file is versioned (committed to git) so the Ghost link is preserved
as a durable record alongside the content.

## When to use

- **After the debate engine finishes**: Phase 6 produces `post.md`,
  `meta.json`, `schema.json`. Push them to Ghost as a draft for preview.
- **After revisions**: Edit `post.md` locally, push again to update the
  same Ghost draft.
- **Before publishing**: Push the final version as a draft, then
  publish it in Ghost's editor.

## Relationship to Ghost Sync

Ghost Push and Ghost Sync are complementary:

```
Repo (local) --push--> Ghost (draft)
Ghost (live) --sync--> Repo (local)
```

- **Push** sends local content to Ghost as a draft (Admin API, write)
- **Sync** pulls published content from Ghost to the repo (Content API,
  read-only)

## Limitations

- Does not upload images. Posts with local-only images will have broken
  image references on Ghost. Posts pulled from Ghost already have
  CDN-hosted images.
- Does not publish. The script always sets status to "draft". Publishing
  happens in Ghost's editor.
- Markdown-to-HTML conversion may not perfectly match Ghost's Lexical
  editor rendering. Minor formatting differences are expected and
  acceptable for a draft workflow.
