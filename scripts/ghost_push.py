# /// script
# dependencies = ["requests", "PyJWT", "markdown"]
# ///
"""
Push a local post directory to Ghost CMS as a draft.

Creates a new draft or updates an existing one, tracked via .ghost.json
in the post directory. Uses the Ghost Admin API with JWT authentication.

Reads the Admin API key from 1Password:
  op read "op://Private/ghost-content-api-key/Admin API Key"

Usage:
  uv run scripts/ghost_push.py posts/{slug}/
"""

import json
import re
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

import jwt
import markdown
import requests

GHOST_API_URL = "https://quentin-kasseh.ghost.io"


def get_admin_key():
    """Read the Ghost Admin API key from 1Password."""
    try:
        result = subprocess.run(
            ["op", "read", "op://Private/ghost-content-api-key/Admin API Key"],
            capture_output=True, text=True, check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"ERROR: Failed to read Admin API key from 1Password: {e.stderr.strip()}")
        print("Make sure you're signed into 1Password CLI (op signin).")
        print("The key should be at: op://Private/ghost-content-api-key/Admin API Key")
        sys.exit(1)


def make_jwt(admin_key):
    """Generate a Ghost Admin API JWT from an id:secret key."""
    parts = admin_key.split(":")
    if len(parts) != 2:
        print("ERROR: Admin API key must be in id:secret format.")
        sys.exit(1)

    key_id, secret = parts
    iat = int(time.time())

    payload = {
        "iat": iat,
        "exp": iat + 5 * 60,
        "aud": "/admin/",
    }
    token = jwt.encode(
        payload,
        bytes.fromhex(secret),
        algorithm="HS256",
        headers={"kid": key_id},
    )
    return token


def read_post_content(post_dir):
    """Read post.md and convert to HTML."""
    post_md = post_dir / "post.md"
    if not post_md.exists():
        print(f"ERROR: {post_md} not found.")
        sys.exit(1)

    md_text = post_md.read_text(encoding="utf-8")
    html = markdown.markdown(
        md_text,
        extensions=["fenced_code", "tables"],
    )
    return html


def read_meta(post_dir):
    """Read meta.json for SEO fields."""
    meta_path = post_dir / "meta.json"
    if not meta_path.exists():
        print(f"ERROR: {meta_path} not found.")
        sys.exit(1)

    return json.loads(meta_path.read_text(encoding="utf-8"))


def read_schema(post_dir):
    """Read schema.json for code injection and keywords."""
    schema_path = post_dir / "schema.json"
    if not schema_path.exists():
        return None, []

    raw = schema_path.read_text(encoding="utf-8").strip()

    # Extract keywords from the JSON-LD block
    keywords = []
    json_match = re.search(r'\{[\s\S]*\}', raw)
    if json_match:
        try:
            data = json.loads(json_match.group())
            keywords = data.get("keywords", [])
        except json.JSONDecodeError:
            pass

    return raw, keywords


def read_ghost_state(post_dir):
    """Read .ghost.json if it exists."""
    ghost_path = post_dir / ".ghost.json"
    if not ghost_path.exists():
        return None
    return json.loads(ghost_path.read_text(encoding="utf-8"))


def write_ghost_state(post_dir, ghost_post):
    """Write .ghost.json with the Ghost post state."""
    state = {
        "ghost_id": ghost_post["id"],
        "updated_at": ghost_post["updated_at"],
        "last_pushed": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        "status": ghost_post["status"],
    }
    path = post_dir / ".ghost.json"
    path.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")


def build_post_body(post_dir, ghost_state=None):
    """Build the Ghost API request body from local files."""
    html = read_post_content(post_dir)
    meta = read_meta(post_dir)
    schema_raw, keywords = read_schema(post_dir)

    post = {
        "title": meta["metaTitle"],
        "html": html,
        "status": "draft",
        "slug": post_dir.name,
        "custom_excerpt": meta.get("excerpt", ""),
        "meta_title": meta["metaTitle"],
        "meta_description": meta.get("metaDescription", ""),
    }

    if schema_raw:
        post["codeinjection_head"] = schema_raw

    if keywords:
        post["tags"] = [{"name": kw} for kw in keywords]

    if ghost_state:
        post["updated_at"] = ghost_state["updated_at"]

    return {"posts": [post]}


def create_draft(token, post_dir):
    """Create a new draft on Ghost."""
    body = build_post_body(post_dir)
    resp = requests.post(
        f"{GHOST_API_URL}/ghost/api/admin/posts/",
        params={"source": "html"},
        json=body,
        headers={
            "Authorization": f"Ghost {token}",
            "Accept-Version": "v5.0",
        },
    )

    if not resp.ok:
        print(f"ERROR: Failed to create draft. Status {resp.status_code}")
        print(resp.text)
        sys.exit(1)

    ghost_post = resp.json()["posts"][0]
    write_ghost_state(post_dir, ghost_post)

    slug = ghost_post["slug"]
    if slug != post_dir.name:
        print(f"  WARNING: Ghost assigned slug '{slug}' instead of '{post_dir.name}'")

    return ghost_post


def update_draft(token, post_dir, ghost_state):
    """Update an existing Ghost draft."""
    ghost_id = ghost_state["ghost_id"]
    body = build_post_body(post_dir, ghost_state)

    resp = requests.put(
        f"{GHOST_API_URL}/ghost/api/admin/posts/{ghost_id}/",
        params={"source": "html"},
        json=body,
        headers={
            "Authorization": f"Ghost {token}",
            "Accept-Version": "v5.0",
        },
    )

    if resp.status_code == 404:
        print("  Ghost draft not found (deleted?). Creating a new one...")
        (post_dir / ".ghost.json").unlink(missing_ok=True)
        return create_draft(token, post_dir)

    if resp.status_code == 409:
        print("  Conflict: Ghost draft was modified externally. Fetching latest state...")
        fetch_resp = requests.get(
            f"{GHOST_API_URL}/ghost/api/admin/posts/{ghost_id}/",
            headers={
                "Authorization": f"Ghost {token}",
                "Accept-Version": "v5.0",
            },
        )
        if fetch_resp.ok:
            fresh = fetch_resp.json()["posts"][0]
            fresh_state = {
                "ghost_id": fresh["id"],
                "updated_at": fresh["updated_at"],
            }
            body = build_post_body(post_dir, fresh_state)
            retry = requests.put(
                f"{GHOST_API_URL}/ghost/api/admin/posts/{ghost_id}/",
                params={"source": "html"},
                json=body,
                headers={
                    "Authorization": f"Ghost {token}",
                    "Accept-Version": "v5.0",
                },
            )
            if retry.ok:
                ghost_post = retry.json()["posts"][0]
                write_ghost_state(post_dir, ghost_post)
                return ghost_post

        print(f"ERROR: Failed to resolve conflict. Status {resp.status_code}")
        print(resp.text)
        sys.exit(1)

    if not resp.ok:
        print(f"ERROR: Failed to update draft. Status {resp.status_code}")
        print(resp.text)
        sys.exit(1)

    ghost_post = resp.json()["posts"][0]
    write_ghost_state(post_dir, ghost_post)
    return ghost_post


def main():
    if len(sys.argv) != 2:
        print("Usage: uv run scripts/ghost_push.py posts/{slug}/")
        sys.exit(1)

    post_dir = Path(sys.argv[1]).resolve()
    if not post_dir.is_dir():
        print(f"ERROR: {post_dir} is not a directory.")
        sys.exit(1)

    slug = post_dir.name
    print(f"Ghost Push: {slug}")
    print(f"  API: {GHOST_API_URL}")
    print(f"  Dir: {post_dir}\n")

    admin_key = get_admin_key()
    token = make_jwt(admin_key)

    ghost_state = read_ghost_state(post_dir)

    if ghost_state:
        print(f"  Updating existing draft (ID: {ghost_state['ghost_id']})...")
        ghost_post = update_draft(token, post_dir, ghost_state)
        action = "Updated"
    else:
        print("  Creating new draft...")
        ghost_post = create_draft(token, post_dir)
        action = "Created"

    print(f"\n  {action} draft: {ghost_post['title']}")
    print(f"  Ghost ID: {ghost_post['id']}")
    print(f"  Status: {ghost_post['status']}")
    preview_url = ghost_post.get("url", "")
    if preview_url:
        print(f"  URL: {preview_url}")


if __name__ == "__main__":
    main()
