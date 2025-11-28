# kasseh.com Content Repository

Version-controlled content for [www.kasseh.com](https://www.kasseh.com) and the Against Entropy newsletter.

## Site URL

**Canonical URL:** https://www.kasseh.com

Always use `www.kasseh.com` in all schema markup and references.

## Structure

```
kasseh.com/
├── posts/                    # Blog posts
│   └── {slug}/
│       ├── post.md           # Markdown content
│       └── schema.json       # JSON-LD for Ghost code injection
├── orgs/
│   └── organizations.json    # Reusable Organization schema library
├── templates/
│   └── article-schema.json   # Base schema template
├── CLAUDE_INSTRUCTIONS.md    # Instructions for AI assistance
└── README.md
```

## Workflow

### Creating a New Post

1. Create a new folder in `posts/` with the URL slug as the name
2. Write the post in `post.md`
3. Copy `templates/article-schema.json` to `{slug}/schema.json`
4. Fill in the headline, description, and dates
5. Add relevant organizations from `orgs/organizations.json` to the `mentions` array
6. Wrap the JSON in `<script type="application/ld+json">` tags

### Publishing to Ghost

1. Open Ghost editor, create new post
2. Paste Markdown content from `post.md`
3. In post settings (gear icon) → Code injection → Post Header
4. Paste the contents of `schema.json`
5. Publish
6. Validate with [Google Rich Results Test](https://search.google.com/test/rich-results)
7. Commit changes to git

### Adding a New Organization

When you reference a new company in a post:

1. Add it to `orgs/organizations.json` with a kebab-case key
2. Use the official company name and URL
3. Copy the entry into your post's `schema.json` mentions array

## AI/Claude Instructions

See `CLAUDE_INSTRUCTIONS.md` for guidance when using Claude to write or edit content. This includes:

- Repository location: `/Users/kasseh/Projects/Personal Utilities/kasseh.com`
- Schema format requirements
- Writing style reference (see project file: kasseh-writing-guide.md)

## Notes

- Schema files include the `<script>` wrapper, ready to paste into Ghost
- Keep post slugs consistent between this repo and Ghost URLs
- Commit after each publish to maintain version history
- Reference kasseh-writing-guide.md for tone, style, and formatting rules
