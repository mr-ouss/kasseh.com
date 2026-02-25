# /// script
# dependencies = ["requests", "markdownify"]
# ///
"""
Sync published posts from Ghost CMS to the local repo.

Pulls all published posts via the Ghost Content API and writes them
into posts/{slug}/ with post.md, meta.json, schema.json, and images.

Reads the API key from 1Password:
  op read "op://Private/ghost-content-api-key/credential"
"""

import json
import os
import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import urlparse

import requests
from markdownify import markdownify as md

GHOST_API_URL = "https://quentin-kasseh.ghost.io"
REPO_ROOT = Path(__file__).resolve().parent.parent
POSTS_DIR = REPO_ROOT / "posts"


def get_api_key():
    """Read the Ghost Content API key from 1Password."""
    try:
        result = subprocess.run(
            ["op", "read", "op://Private/ghost-content-api-key/credential"],
            capture_output=True, text=True, check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"ERROR: Failed to read API key from 1Password: {e.stderr.strip()}")
        print("Make sure you're signed into 1Password CLI (op signin).")
        sys.exit(1)


def fetch_all_posts(api_key):
    """Fetch all published posts from Ghost Content API with pagination."""
    all_posts = []
    page = 1

    while True:
        resp = requests.get(
            f"{GHOST_API_URL}/ghost/api/content/posts/",
            params={
                "key": api_key,
                "include": "tags,authors",
                "formats": "html,plaintext",
                "limit": 100,
                "page": page,
            },
            headers={"Accept-Version": "v5.0"},
        )
        resp.raise_for_status()
        data = resp.json()

        posts = data.get("posts", [])
        all_posts.extend(posts)

        meta = data.get("meta", {}).get("pagination", {})
        if page >= meta.get("pages", 1):
            break
        page += 1

    return all_posts


def extract_schema_json(codeinjection_head):
    """Extract JSON-LD script block from Ghost code injection header."""
    if not codeinjection_head:
        return None

    pattern = r'(<script\s+type="application/ld\+json">[\s\S]*?</script>)'
    match = re.search(pattern, codeinjection_head)
    if match:
        return match.group(1)
    return None


def download_image(url, dest_path):
    """Download an image if it doesn't already exist locally."""
    if dest_path.exists():
        return False  # already downloaded

    dest_path.parent.mkdir(parents=True, exist_ok=True)
    resp = requests.get(url, stream=True)
    resp.raise_for_status()

    with open(dest_path, "wb") as f:
        for chunk in resp.iter_content(chunk_size=8192):
            f.write(chunk)
    return True


def process_images(html, slug, ghost_url):
    """Find image URLs in HTML, download them, return URL mapping."""
    image_map = {}
    # Match Ghost-hosted image URLs
    pattern = re.compile(
        r'(https?://[^"\s]+/content/images/[^"\s]+)', re.IGNORECASE
    )

    for url in set(pattern.findall(html)):
        parsed = urlparse(url)
        filename = Path(parsed.path).name
        local_path = POSTS_DIR / slug / "images" / filename
        relative_path = f"images/{filename}"

        try:
            downloaded = download_image(url, local_path)
            image_map[url] = relative_path
            if downloaded:
                print(f"    Downloaded: {filename}")
        except Exception as e:
            print(f"    WARNING: Failed to download {url}: {e}")

    return image_map


def html_to_markdown(html, image_map):
    """Convert Ghost HTML to Markdown and rewrite image URLs."""
    markdown = md(
        html,
        heading_style="atx",
        bullets="-",
        strip=["script", "style"],
    )

    # Rewrite Ghost image URLs to local relative paths
    for ghost_url, local_path in image_map.items():
        markdown = markdown.replace(ghost_url, local_path)

    # Clean up excessive blank lines
    markdown = re.sub(r"\n{3,}", "\n\n", markdown)

    return markdown.strip() + "\n"


def write_if_changed(filepath, content):
    """Write content to file only if it differs. Returns True if written."""
    filepath.parent.mkdir(parents=True, exist_ok=True)

    if filepath.exists():
        existing = filepath.read_text(encoding="utf-8")
        if existing == content:
            return False

    filepath.write_text(content, encoding="utf-8")
    return True


def sync_post(post):
    """Sync a single Ghost post to the local repo. Returns status string."""
    slug = post["slug"]
    post_dir = POSTS_DIR / slug
    changes = []

    # 1. Process images from HTML
    html = post.get("html", "")
    image_map = process_images(html, slug, GHOST_API_URL)

    # 2. Convert HTML to Markdown -> post.md
    markdown = html_to_markdown(html, image_map)
    if write_if_changed(post_dir / "post.md", markdown):
        changes.append("post.md")

    # 3. Build meta.json
    meta = {
        "metaTitle": post.get("meta_title") or post.get("title", ""),
        "excerpt": post.get("custom_excerpt") or post.get("excerpt", ""),
        "metaDescription": post.get("meta_description") or "",
    }
    meta_content = json.dumps(meta, indent=2, ensure_ascii=False) + "\n"
    if write_if_changed(post_dir / "meta.json", meta_content):
        changes.append("meta.json")

    # 4. Extract schema.json from code injection
    schema = extract_schema_json(post.get("codeinjection_head"))
    if schema:
        schema_content = schema.strip() + "\n"
        if write_if_changed(post_dir / "schema.json", schema_content):
            changes.append("schema.json")

    if image_map:
        changes.append(f"{len(image_map)} image(s)")

    return changes


def main():
    print("Ghost Sync: Fetching posts from Ghost CMS...")
    print(f"  API: {GHOST_API_URL}")
    print(f"  Repo: {REPO_ROOT}\n")

    api_key = get_api_key()
    posts = fetch_all_posts(api_key)
    print(f"Found {len(posts)} published post(s).\n")

    created = []
    updated = []
    unchanged = []

    for post in posts:
        slug = post["slug"]
        post_dir = POSTS_DIR / slug
        is_new = not post_dir.exists()

        print(f"  [{slug}]")
        changes = sync_post(post)

        if not changes:
            unchanged.append(slug)
            print("    No changes.")
        elif is_new:
            created.append(slug)
            print(f"    Created: {', '.join(changes)}")
        else:
            updated.append(slug)
            print(f"    Updated: {', '.join(changes)}")

    print("\n--- Summary ---")
    print(f"  Created: {len(created)}")
    print(f"  Updated: {len(updated)}")
    print(f"  Unchanged: {len(unchanged)}")

    if created:
        print(f"\n  New posts: {', '.join(created)}")
    if updated:
        print(f"  Modified posts: {', '.join(updated)}")


if __name__ == "__main__":
    main()
