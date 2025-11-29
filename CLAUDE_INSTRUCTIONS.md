# Claude Instructions for kasseh.com Content

This file provides instructions for Claude when working on blog content for www.kasseh.com.

## Repository Location

All article content for www.kasseh.com is stored in:
```
/Users/kasseh/Projects/Personal Utilities/kasseh.com
```

## Site URL

The canonical site URL is: **https://www.kasseh.com**

Always use `www.kasseh.com` (not `kasseh.com`) in all schema markup, links, and references.

## Directory Structure

```
kasseh.com/
├── posts/                    # Blog posts (one folder per article)
│   └── {slug}/
│       ├── post.md           # Article content in Markdown
│       ├── meta.json         # SEO metadata (title, excerpt, description)
│       └── schema.json       # JSON-LD schema for SEO
├── orgs/
│   └── organizations.json    # Reusable Organization schema entries
├── templates/
│   └── article-schema.json   # Base template for new posts
├── README.md                 # Repository documentation
└── CLAUDE_INSTRUCTIONS.md    # This file
```

## When Writing a New Article

1. **Create the post folder**: Use the URL slug as the folder name in `posts/`
   - Example: `posts/knowledge-graphs-snowflake-ai-data-cloud/`

2. **Write the article**: Save as `post.md` in the post folder
   - Follow the writing guide in the project files (kasseh-writing-guide.md)
   - No em dashes
   - Concrete examples with specific tool/company names
   - Problem-first structure

3. **Create the meta.json**: Generate SEO metadata
   - `metaTitle`: Full, optimized title for search engines
   - `excerpt`: 1-2 sentence summary for previews and cards
   - `metaDescription`: Max 145 characters for search results

4. **Generate the schema.json**: Create JSON-LD for SEO
   - Copy template from `templates/article-schema.json`
   - Fill in headline, description
   - Add all mentioned organizations to the `mentions` array
   - Wrap in `<script type="application/ld+json">` tags

5. **Update organizations.json**: Add any new companies referenced
   - Use kebab-case keys (e.g., "dbt-labs", "relational-ai")
   - Include official company name and URL

## Meta.json Format

Every post needs a `meta.json` file with this structure:

```json
{
  "metaTitle": "Full Title for Search Engines and Social Sharing",
  "excerpt": "A 1-2 sentence summary of the article for previews, RSS feeds, and social cards.",
  "metaDescription": "Max 145 characters. Appears in Google search results. Keep it compelling."
}
```

**Field guidelines:**

- `metaTitle`: **Max 60 characters.** Optimized for search engines. Can differ from the H1.
- `excerpt`: Brief, informative summary. Used for article cards and social previews.
- `metaDescription`: **Max 145 characters.** This appears directly in search results, so make it compelling.

## Schema.json Format

Every post needs a schema.json file with this structure:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Title Here",
  "description": "Brief description for search results.",
  "author": {
    "@type": "Person",
    "name": "Quentin Kasseh",
    "url": "https://www.kasseh.com"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Against Entropy",
    "url": "https://www.kasseh.com"
  },
  "mentions": [
    {"@type": "Organization", "name": "Company Name", "url": "https://company.com"}
  ]
}
</script>
```

**Important**: The schema.json file should include the `<script>` wrapper so it can be pasted directly into Ghost's code injection.

## Organizations Library

Before adding a new organization to a post's schema, check if it already exists in `orgs/organizations.json`. This file serves as a reusable library of company schemas with verified names and URLs.

## Publishing Workflow

After Claude creates/updates content:

1. Review the Markdown in `post.md`
2. Copy Markdown content into Ghost editor
3. Go to Post Settings:
   - Set meta title from `meta.json`
   - Set meta description from `meta.json`
   - Set excerpt from `meta.json`
4. Go to Code injection → Post Header, paste the contents of `schema.json`
5. Validate with Google Rich Results Test after publishing
6. Commit changes to git

## Writing Style Reference

Refer to the project file `kasseh-writing-guide.md` for:
- Tone and voice guidelines
- Language preferences (words to avoid)
- Content structure patterns
- Formatting rules

Key reminders:
- No em dashes (use commas, colons, periods)
- No AI-sounding phrases ("leverage," "landscape," "cutting-edge")
- Start with problems, not solutions
- Use concrete examples with real tool names
- Acknowledge tradeoffs honestly
