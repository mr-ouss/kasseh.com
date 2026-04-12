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

## When to use

- **After the debate engine finishes**: Phase 6 produces `post.md`,
  `meta.json`, `schema.json`. Push them to Ghost as a draft for preview.
- **After revisions**: Edit `post.md` locally, push again to update the
  same Ghost draft.
- **Before publishing**: Push the final version as a draft, then
  publish it in Ghost's editor.

## Relationship to Ghost Sync

```
Repo (local) --push--> Ghost (draft)
Ghost (live) --sync--> Repo (local)
```

Push sends local content to Ghost (write). Sync pulls published content
from Ghost to the repo (read-only).
