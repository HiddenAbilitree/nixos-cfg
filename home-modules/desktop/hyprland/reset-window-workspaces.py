#!/usr/bin/env python3
"""Move Hyprland clients back to workspaces from Lua workspace window rules.

Hyprland applies static `workspace` window-rule effects when a client opens. It
does not expose a documented command to re-run those rules for already-open
clients, so this script rebuilds the workspace mapping from the current
`hyprland.lua` config file and applies it with targeted `movetoworkspacesilent`
dispatches.
"""

from __future__ import annotations

import argparse
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


def iter_lua_call_tables(text: str, function_name: str):
    call_pattern = re.compile(rf"{re.escape(function_name)}\s*\(\s*\{{")

    for match in call_pattern.finditer(text):
        table_start = text.find("{", match.start(), match.end())
        if table_start == -1:
            continue

        depth = 0
        quote: str | None = None
        escaped = False
        line_comment = False

        for index in range(table_start, len(text)):
            char = text[index]
            next_two = text[index : index + 2]

            if line_comment:
                if char == "\n":
                    line_comment = False
                continue

            if quote:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == quote:
                    quote = None
                continue

            if next_two == "--":
                line_comment = True
                continue

            if char in {'"', "'"}:
                quote = char
                continue

            if char == "{":
                depth += 1
                continue

            if char == "}":
                depth -= 1
                if depth == 0:
                    line_number = text.count("\n", 0, match.start()) + 1
                    yield line_number, text[table_start : index + 1]
                    break


LUA_STRING = r'"((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\''


def unescape_lua_string(match: re.Match[str]) -> str:
    raw_value = next(group for group in match.groups() if group is not None)
    # Python and Lua share the simple escapes used in these config regexes.
    return bytes(raw_value, "utf-8").decode("unicode_escape")


def lua_string_field(body: str, field: str) -> str | None:
    match = re.search(rf"\b{re.escape(field)}\s*=\s*(?:{LUA_STRING})", body)
    if not match:
        return None

    return unescape_lua_string(match)


def lua_workspace_field(body: str) -> str | None:
    string_workspace = lua_string_field(body, "workspace")
    if string_workspace is not None:
        return re.sub(r"\s+silent$", "", string_workspace.strip())

    numeric_workspace = re.search(r"\bworkspace\s*=\s*(-?\d+)\b", body)
    if numeric_workspace:
        return numeric_workspace.group(1)

    return None


def lua_match_body(rule_body: str) -> str | None:
    match = re.search(r"\bmatch\s*=\s*\{", rule_body)
    if not match:
        return None

    start = rule_body.find("{", match.start(), match.end())
    depth = 0
    quote: str | None = None
    escaped = False
    line_comment = False

    for index in range(start, len(rule_body)):
        char = rule_body[index]
        next_two = rule_body[index : index + 2]

        if line_comment:
            if char == "\n":
                line_comment = False
            continue

        if quote:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
            continue

        if next_two == "--":
            line_comment = True
            continue

        if char in {'"', "'"}:
            quote = char
            continue

        if char == "{":
            depth += 1
            continue

        if char == "}":
            depth -= 1
            if depth == 0:
                return rule_body[start + 1 : index]

    return None


def parse_lua_window_rule(path: Path, line_number: int, body: str) -> WindowRule | None:
    workspace = lua_workspace_field(body)
    if not workspace or workspace == "unset":
        return None

    match_body = lua_match_body(body)
    if not match_body:
        return None

    matchers = [
        (field, value)
        for field in MATCH_FIELDS
        if (value := lua_string_field(match_body, field)) is not None
    ]

    if not matchers:
        return None

    return WindowRule(
        workspace=workspace,
        matchers=tuple(matchers),
        source=path,
        line_number=line_number,
    )


def load_lua_rules(config_path: Path) -> list[WindowRule]:
    path = config_path.expanduser().resolve(strict=True)
    text = path.read_text()
    return [
        rule
        for line_number, body in iter_lua_call_tables(text, "hl.window_rule")
        if (rule := parse_lua_window_rule(path, line_number, body)) is not None
    ]


def load_rules(config_path: Path) -> list[WindowRule]:
    if not config_path.expanduser().exists():
        raise FileNotFoundError(f"Hyprland config not found: {config_path}")

    if config_path.suffix != ".lua":
        raise ValueError(f"expected a Hyprland Lua config, got: {config_path}")

    return load_lua_rules(config_path)


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
    hypr_config_dir = xdg_config_home / "hypr"
    return hypr_config_dir / "hyprland.lua"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--config",
        type=Path,
        default=default_config_path(),
        help="Hyprland Lua config to parse, default: $XDG_CONFIG_HOME/hypr/hyprland.lua",
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
