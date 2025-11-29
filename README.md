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
│       ├── meta.json         # SEO metadata (title, excerpt, description)
│       └── schema.json       # JSON-LD for Ghost code injection
├── orgs/
│   └── organizations.json    # Reusable Organization schema library
├── templates/
│   └── article-schema.json   # Base schema template
├── CLAUDE_INSTRUCTIONS.md    # Instructions for AI assistance
└── README.md
```

## Post Metadata (meta.json)

Each post includes a `meta.json` file with SEO metadata:

```json
{
  "metaTitle": "Full title for search engines and social sharing",
  "excerpt": "A 1-2 sentence summary of the article for previews and cards.",
  "metaDescription": "Max 145 characters. Appears in search results."
}
```

**Field guidelines:**

- `metaTitle`: Max 60 characters. Optimized for search engines. Can differ from the H1 headline.
- `excerpt`: A brief summary (1-2 sentences) for article cards, RSS feeds, and social previews.
- `metaDescription`: Max 145 characters. This appears in Google search results.

## Workflow

### Creating a New Post

1. Create a new folder in `posts/` with the URL slug as the name
2. Write the post in `post.md`
3. Create `meta.json` with:
   - `metaTitle`: SEO-optimized title
   - `excerpt`: Brief summary for previews
   - `metaDescription`: Max 145 characters for search results
4. Copy `templates/article-schema.json` to `{slug}/schema.json`
5. Fill in the headline, description, and dates
6. Add relevant organizations from `orgs/organizations.json` to the `mentions` array
7. Wrap the JSON in `<script type="application/ld+json">` tags

### Publishing to Ghost

1. Open Ghost editor, create new post
2. Paste Markdown content from `post.md`
3. In post settings (gear icon):
   - Set the meta title from `meta.json`
   - Set the meta description from `meta.json`
   - Set the excerpt from `meta.json`
4. In Code injection → Post Header, paste the contents of `schema.json`
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
- Meta.json requirements
- Writing style reference (see project file: kasseh-writing-guide.md)

## Notes

- Schema files include the `<script>` wrapper, ready to paste into Ghost
- Keep post slugs consistent between this repo and Ghost URLs
- Commit after each publish to maintain version history
- Reference kasseh-writing-guide.md for tone, style, and formatting rules
- Meta descriptions must be 145 characters or fewer to avoid truncation in search results
