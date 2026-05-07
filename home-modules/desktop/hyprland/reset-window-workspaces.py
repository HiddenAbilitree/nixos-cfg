#!/usr/bin/env python3
"""Move Hyprland clients back to workspaces from workspace window rules.

Hyprland applies static `workspace` window-rule effects when a client opens. It
does not expose a documented command to re-run those rules for already-open
clients, so this script rebuilds the workspace mapping from the current config
file and applies it with targeted `movetoworkspacesilent` dispatches.
"""

from __future__ import annotations

import argparse
import glob
import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


MATCH_FIELDS = {
    "class": ("class",),
    "initial_class": ("initialClass", "initial_class", "class"),
    "title": ("title",),
    "initial_title": ("initialTitle", "initial_title", "title"),
}


@dataclass(frozen=True)
class WindowRule:
    workspace: str
    matchers: tuple[tuple[str, str], ...]
    source: Path
    line_number: int


def strip_comment(line: str) -> str:
    return line.split("#", 1)[0].strip()


def expand_config_path(raw_path: str, base_dir: Path) -> list[Path]:
    expanded = os.path.expanduser(os.path.expandvars(raw_path.strip()))
    path = Path(expanded)
    if not path.is_absolute():
        path = base_dir / path

    if any(char in str(path) for char in "*?["):
        return [Path(match) for match in glob.glob(str(path))]

    return [path]


def iter_config_lines(config_path: Path, seen: set[Path] | None = None):
    seen = seen or set()
    path = config_path.expanduser()

    try:
        resolved = path.resolve(strict=True)
    except FileNotFoundError:
        print(f"warning: config source not found: {path}", file=sys.stderr)
        return

    if resolved in seen:
        return

    seen.add(resolved)

    try:
        lines = resolved.read_text().splitlines()
    except OSError as error:
        print(f"warning: cannot read {resolved}: {error}", file=sys.stderr)
        return

    for line_number, raw_line in enumerate(lines, start=1):
        line = strip_comment(raw_line)
        source = re.match(r"^source\s*=\s*(.+)$", line)
        if source:
            for sourced_path in expand_config_path(source.group(1), resolved.parent):
                yield from iter_config_lines(sourced_path, seen)
            continue

        yield resolved, line_number, raw_line


def parse_window_rule(path: Path, line_number: int, raw_line: str) -> WindowRule | None:
    line = strip_comment(raw_line)
    if not re.match(r"^windowrule\s*=", line):
        return None

    body = line.split("=", 1)[1].strip()
    parts = [part.strip() for part in body.split(",") if part.strip()]
    workspace: str | None = None
    matchers: list[tuple[str, str]] = []

    for part in parts:
        match = re.match(r"^match:(class|initial_class|title|initial_title)\s+(.+)$", part)
        if match:
            matchers.append((match.group(1), match.group(2).strip()))
            continue

        workspace_match = re.match(r"^workspace\s+(.+)$", part)
        if workspace_match:
            workspace = re.sub(r"\s+silent$", "", workspace_match.group(1).strip())

    if not workspace or workspace == "unset" or not matchers:
        return None

    return WindowRule(
        workspace=workspace,
        matchers=tuple(matchers),
        source=path,
        line_number=line_number,
    )


def load_rules(config_path: Path) -> list[WindowRule]:
    if not config_path.expanduser().exists():
        raise FileNotFoundError(f"Hyprland config not found: {config_path}")

    rules: list[WindowRule] = []

    for path, line_number, line in iter_config_lines(config_path):
        rule = parse_window_rule(path, line_number, line)
        if rule:
            rules.append(rule)

    return rules


def client_value(client: dict[str, Any], field: str) -> str:
    for key in MATCH_FIELDS[field]:
        value = client.get(key)
        if value is not None:
            return str(value)

    return ""


def regex_matches(pattern: str, value: str) -> bool:
    negated = pattern.startswith("negative:")
    pattern = pattern.removeprefix("negative:")

    try:
        matched = re.fullmatch(pattern, value) is not None
    except re.error as error:
        print(f"warning: unsupported regex {pattern!r}: {error}", file=sys.stderr)
        return False

    return not matched if negated else matched


def rule_matches_client(rule: WindowRule, client: dict[str, Any]) -> bool:
    return all(
        regex_matches(pattern, client_value(client, field))
        for field, pattern in rule.matchers
    )


def matching_workspace(rules: list[WindowRule], client: dict[str, Any]) -> str | None:
    workspace: str | None = None

    for rule in rules:
        if rule_matches_client(rule, client):
            workspace = rule.workspace

    return workspace


def current_workspace_matches(client: dict[str, Any], target: str) -> bool:
    workspace = client.get("workspace")
    if not isinstance(workspace, dict):
        return False

    if target.startswith("name:"):
        return str(workspace.get("name", "")) == target.removeprefix("name:")

    return str(workspace.get("id", "")) == target


def load_clients(clients_json: Path | None) -> list[dict[str, Any]]:
    if clients_json:
        with clients_json.open() as handle:
            clients = json.load(handle)
    else:
        result = subprocess.run(
            ["hyprctl", "-j", "clients"],
            check=True,
            stdout=subprocess.PIPE,
            text=True,
        )
        clients = json.loads(result.stdout)

    if not isinstance(clients, list):
        raise ValueError("hyprctl clients JSON must be a list")

    return clients


def planned_moves(
    rules: list[WindowRule],
    clients: list[dict[str, Any]],
) -> list[dict[str, str]]:
    moves: list[dict[str, str]] = []

    for client in clients:
        address = str(client.get("address", ""))
        if not address:
            continue

        target = matching_workspace(rules, client)
        if not target or current_workspace_matches(client, target):
            continue

        moves.append(
            {
                "address": address,
                "workspace": target,
                "class": str(client.get("class", "")),
                "initialClass": str(client.get("initialClass", "")),
                "title": str(client.get("title", "")),
            }
        )

    return moves


def default_config_path() -> Path:
    explicit = os.environ.get("HYPRLAND_RESET_WORKSPACES_CONFIG")
    if explicit:
        return Path(explicit)

    xdg_config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    return xdg_config_home / "hypr" / "hyprland.conf"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--config",
        type=Path,
        default=default_config_path(),
        help="Hyprland config to parse, default: $XDG_CONFIG_HOME/hypr/hyprland.conf",
    )
    parser.add_argument(
        "--clients-json",
        type=Path,
        help="Read hyprctl clients JSON from this file instead of the live compositor",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print planned moves as JSON without dispatching them",
    )
    parser.add_argument(
        "--print-rules",
        action="store_true",
        help="Print parsed workspace rules as JSON and exit",
    )

    return parser.parse_args()


def main() -> int:
    args = parse_args()
    rules = load_rules(args.config)

    if args.print_rules:
        print(
            json.dumps(
                [
                    {
                        "workspace": rule.workspace,
                        "matchers": rule.matchers,
                        "source": str(rule.source),
                        "line": rule.line_number,
                    }
                    for rule in rules
                ],
                indent=2,
            )
        )
        return 0

    clients = load_clients(args.clients_json)
    moves = planned_moves(rules, clients)

    if args.dry_run:
        print(json.dumps(moves, indent=2))
        return 0

    for move in moves:
        subprocess.run(
            [
                "hyprctl",
                "dispatch",
                "movetoworkspacesilent",
                f"{move['workspace']},address:{move['address']}",
            ],
            check=False,
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
