#!/usr/bin/env python3
# /// script
# requires-python = ">= 3.11"
# ///

"""Scaffold a new plugin in this Claude Code marketplace.

Creates plugins/<name>/ with both manifests (Claude Code and
agent-plugins.org), a README with the install line, and registers the
plugin in .claude-plugin/marketplace.json.

Usage:
    uv run scripts/create_plugin.py --name my-plugin --description "What it does."
    uv run scripts/create_plugin.py --name my-plugin --description "..." --marketplace path/to/marketplace.json
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

NAME_PATTERN = re.compile(r"[a-z0-9][a-z0-9._-]{0,79}")
AGENT_PLUGINS_SCHEMA = "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"


def die(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def find_marketplace(start: Path) -> Path | None:
    for candidate in (start, *start.parents):
        manifest = candidate / ".claude-plugin" / "marketplace.json"
        if manifest.is_file():
            return manifest
    return None


def git_origin(root: Path) -> str | None:
    try:
        result = subprocess.run(
            ["git", "-C", str(root), "remote", "get-url", "origin"],
            capture_output=True,
            text=True,
            timeout=10,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    url = result.stdout.strip()
    return url or None


def normalize_repo_url(url: str) -> str:
    match = re.search(r"github\.com[:/]([^/]+)/([^/]+?)(?:\.git)?$", url)
    if match:
        return f"https://github.com/{match.group(1)}/{match.group(2)}"
    return url


def owner_repo(root: Path, marketplace: dict) -> str | None:
    """Return "owner/repo" for the install line, or None if unknowable."""
    origin = git_origin(root)
    if origin:
        # https://github.com/owner/repo(.git) or git@github.com:owner/repo(.git)
        match = re.search(r"github\.com[:/]([^/]+)/([^/]+?)(?:\.git)?$", origin)
        if match:
            return f"{match.group(1)}/{match.group(2)}"
    owner = marketplace.get("owner", {}).get("name")
    if owner:
        return f"{owner}/{root.name}"
    return None


def validate_name(name: str) -> None:
    if not NAME_PATTERN.fullmatch(name):
        die(
            f"invalid plugin name {name!r}: use 1-80 chars, lowercase letters, "
            "digits, '.', '_' or '-', starting with a letter or digit"
        )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Scaffold a new plugin in this marketplace.")
    parser.add_argument("--name", required=True, help="Plugin directory name, e.g. my-plugin")
    parser.add_argument("--description", required=True, help="One-line plugin description")
    parser.add_argument(
        "--marketplace",
        type=Path,
        default=None,
        help="Path to marketplace.json (default: discover by walking up from cwd)",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    validate_name(args.name)

    if args.marketplace is not None:
        marketplace_path = args.marketplace
        if not marketplace_path.is_file():
            die(f"marketplace file not found: {marketplace_path}")
    else:
        found = find_marketplace(Path.cwd().resolve())
        if found is None:
            die("no .claude-plugin/marketplace.json found above cwd; pass --marketplace")
        marketplace_path = found

    if marketplace_path.parent.name != ".claude-plugin":
        die(
            f"marketplace file must live at <root>/.claude-plugin/marketplace.json: {marketplace_path}"
        )
    root = marketplace_path.parent.parent
    plugin_dir = root / "plugins" / args.name
    if plugin_dir.exists():
        die(f"plugin directory already exists: {plugin_dir}")

    try:
        marketplace = json.loads(marketplace_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        die(f"cannot parse {marketplace_path}: {exc}")
    entries = marketplace.get("plugins")
    if not isinstance(entries, list):
        die(f"{marketplace_path} has no 'plugins' list")

    owner = marketplace.get("owner", {}).get("name")
    repo_url = None
    origin = git_origin(root)
    if origin and origin.startswith(("http", "git@")):
        repo_url = normalize_repo_url(origin)

    claude_manifest: dict = {
        "name": args.name,
        "description": args.description,
        "version": "0.1.0",
    }
    if owner:
        claude_manifest["author"] = {"name": owner}
    if repo_url:
        claude_manifest["repository"] = repo_url
    claude_manifest["license"] = "MIT"

    agent_manifest = {"$schema": AGENT_PLUGINS_SCHEMA, **claude_manifest}

    install_target = owner_repo(root, marketplace) or "<owner>/<repo>"
    readme = (
        f"# {args.name}\n\n{args.description}\n\n"
        "## Installation\n\n```\n"
        f"/plugin install {args.name} --marketplace {install_target}\n```\n"
    )

    (plugin_dir / ".claude-plugin").mkdir(parents=True)
    (plugin_dir / ".claude-plugin" / "plugin.json").write_text(
        json.dumps(claude_manifest, indent=4) + "\n", encoding="utf-8"
    )
    (plugin_dir / "plugin.json").write_text(
        json.dumps(agent_manifest, indent=4) + "\n", encoding="utf-8"
    )
    (plugin_dir / "README.md").write_text(readme, encoding="utf-8")

    source = f"./plugins/{args.name}"
    if any(e.get("name") == args.name or e.get("source") == source for e in entries):
        print(f"marketplace already lists {args.name!r}; leaving {marketplace_path} unchanged")
    else:
        entries.append({"name": args.name, "source": source})
        marketplace_path.write_text(json.dumps(marketplace, indent=4) + "\n", encoding="utf-8")
        print(f"registered {args.name!r} in {marketplace_path}")

    print(f"created {plugin_dir}")
    print("next steps:")
    print(f"  - add skills under {plugin_dir}/skills/ (just add {args.name} <skill>)")
    print("  - add a row to the plugins table in README.md")
    print("  - run just validate")


if __name__ == "__main__":
    main()
