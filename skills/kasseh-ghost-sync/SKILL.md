# Ghost Sync

Sync published posts from Ghost CMS back to the local kasseh.com repo.

Use this skill when the user says "sync from ghost," "pull from ghost,"
"sync blog," or when content has been written or edited directly in the
Ghost editor and the local repo needs to catch up.

---

## What it does

The `ghost_sync.py` script connects to the Ghost Content API, fetches all
published posts, and writes them to the local repo at `posts/{slug}/`. For
each post it produces:

- `post.md`: HTML converted to Markdown, with image URLs rewritten to
  local paths
- `meta.json`: SEO metadata (`metaTitle`, `excerpt`, `metaDescription`)
  extracted from Ghost post fields
- `schema.json`: JSON-LD structured data extracted from Ghost's code
  injection header (if present)
- `images/`: Ghost-hosted images downloaded locally

The script uses `write_if_changed` so it only touches files that actually
differ from what's already on disk. Safe to run repeatedly.

## Prerequisites

1. **1Password CLI** must be installed and signed in. The script reads the
   Ghost Content API key from 1Password:
   ```
   op://Private/ghost-content-api-key/credential
   ```
   If not signed in, the script will fail with a clear error message.

2. **uv** must be installed. The script uses PEP 723 inline dependencies
   (`requests`, `markdownify`), so it runs via `uv run` with no separate
   install step.

## How to run

From the repo root:

```bash
cd "/Users/kasseh/Projects/Personal Utilities/kasseh.com"
uv run scripts/ghost_sync.py
```

Or from anywhere:

```bash
uv run "/Users/kasseh/Projects/Personal Utilities/kasseh.com/scripts/ghost_sync.py"
```

## What to expect

The script prints progress for each post:

```
Ghost Sync: Fetching posts from Ghost CMS...
  API: https://quentin-kasseh.ghost.io
  Repo: /Users/kasseh/Projects/Personal Utilities/kasseh.com

Found 9 published post(s).

  [semantic-drift-vs-syntactic-drift]
    No changes.
  [knowledge-graphs-on-snowflake]
    Updated: post.md, meta.json
  [new-post-slug]
    Created: post.md, meta.json, schema.json, 2 image(s)

--- Summary ---
  Created: 1
  Updated: 1
  Unchanged: 7
```

## When to use

- **After editing in Ghost**: If the user wrote or edited a post directly
  in the Ghost editor, run the sync to pull those changes into the repo.
- **After publishing**: If the user published a new post via Ghost's UI
  (rather than through the content debate pipeline), sync to capture it.
- **Periodic sync**: Run before starting content work to ensure the repo
  reflects the current state of the live blog.
- **Before content debate**: If the user wants to revise an existing
  published post through the debate pipeline, sync first so the
  draft-agent has the current version.

## After syncing

The sync pulls content from Ghost into the repo. It does not push changes
to Ghost. The publishing direction is:

```
Ghost (live) --sync--> Repo (local)
Repo (local) --manual copy--> Ghost (live)
```

If the sync reveals posts that are missing `schema.json` (Ghost code
injection was not set), flag this to the user. The ghost-publisher agent
can generate the missing schema files.

## Limitations

- The script fetches all published posts every run. There is no
  incremental or single-post mode.
- Markdown conversion from HTML is imperfect. Complex Ghost card blocks
  (galleries, embeds, bookmarks) may not convert cleanly. Review the
  `post.md` output for formatting issues.
- The script does not sync draft posts, only published ones.
- `schema.json` is only written if Ghost's code injection header contains
  a JSON-LD block. Posts without code injection will not get a schema file.
