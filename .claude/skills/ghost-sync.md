# Ghost Sync

Sync published posts from Ghost CMS to the local repository.

## When to use

Use this skill when the user wants to pull the latest content from Ghost into the repo, or check if the repo is in sync with what's published on Ghost.

## Steps

1. Run the sync script:

```bash
uv run scripts/ghost_sync.py
```

The script will:
- Read the Ghost Content API key from 1Password (may prompt for biometric auth)
- Fetch all published posts from Ghost
- For each post: write/update `post.md`, `meta.json`, `schema.json`, and download images
- Report what was created, updated, or unchanged

2. After the script completes, show the user a summary of changes by running:

```bash
git diff --stat
```

3. If there are changes, ask the user if they want to review the diffs or commit.
