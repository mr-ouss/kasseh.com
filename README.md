# kasseh.com Content Repository

Version-controlled content for [www.kasseh.com](https://www.kasseh.com) and the Against Entropy newsletter.

## Structure

```
kasseh-content/
├── posts/                    # Blog posts
│   └── {slug}/
│       ├── post.md           # Markdown content
│       └── schema.json       # JSON-LD for Ghost code injection
├── orgs/
│   └── organizations.json    # Reusable Organization schema library
├── templates/
│   └── article-schema.json   # Base schema template
└── README.md
```

## Workflow

### Creating a New Post

1. Create a new folder in `posts/` with the URL slug as the name
2. Write the post in `post.md`
3. Copy `templates/article-schema.json` to `{slug}/schema.json`
4. Fill in the headline, description, and dates
5. Add relevant organizations from `orgs/organizations.json` to the `mentions` array

### Publishing to Ghost

1. Open Ghost editor, create new post
2. Paste Markdown content from `post.md`
3. In post settings (gear icon) → Code injection → Post Header
4. Paste the contents of `schema.json`
5. Publish

### Adding a New Organization

When you reference a new company in a post:

1. Add it to `orgs/organizations.json` with a kebab-case key
2. Use the official company name and URL
3. Copy the entry into your post's `schema.json` mentions array

### Validating Schema

After publishing, test your structured data:

1. Go to [Google Rich Results Test](https://search.google.com/test/rich-results)
2. Enter your post URL
3. Verify no errors in the Article schema

## Organization Library

The `orgs/organizations.json` file contains pre-built schema entries for commonly referenced companies:

- Snowflake
- dbt Labs
- RelationalAI
- Matillion
- Monte Carlo
- Fivetran
- Airbyte
- Stardog
- Bigeye
- Looker
- Hex

Add new organizations as needed.

## Notes

- Schema files include the `<script>` wrapper, ready to paste into Ghost
- Keep post slugs consistent between this repo and Ghost URLs
- Commit after each publish to maintain history
