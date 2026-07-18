from __future__ import annotations

import importlib.util
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock


MODULE_PATH = Path(__file__).with_name("reset-window-workspaces.py")
SPEC = importlib.util.spec_from_file_location("reset_window_workspaces", MODULE_PATH)
assert SPEC is not None
assert SPEC.loader is not None
reset_window_workspaces = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = reset_window_workspaces
SPEC.loader.exec_module(reset_window_workspaces)


class NamedWorkspaceTest(unittest.TestCase):
    def setUp(self) -> None:
        self.client = {
            "address": "0x1",
            "class": "obsidian",
            "initialClass": "obsidian",
            "title": "Obsidian",
        }

    def load_rules(
        self,
        config: str,
    ) -> list[reset_window_workspaces.WindowRule]:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "hyprland.lua"
            path.write_text(config)
            return reset_window_workspaces.load_rules(path)

    def load_obsidian_rule(self) -> list[reset_window_workspaces.WindowRule]:
        return self.load_rules(
            """
hl.window_rule({
  name = "obsidian-workspace",
  match = { initial_class = "obsidian" },
  workspace = "name:obsidian silent",
})
"""
        )

    def load_numeric_rule(self) -> list[reset_window_workspaces.WindowRule]:
        return self.load_rules(
            """
hl.window_rule({
  name = "terminal-workspace",
  match = { class = "kitty" },
  workspace = 12,
})
"""
        )

    def test_client_already_on_named_workspace_is_not_moved(self) -> None:
        self.client["workspace"] = {"id": -1337, "name": "obsidian"}

        moves = reset_window_workspaces.planned_moves(
            self.load_obsidian_rule(), [self.client]
        )

        self.assertEqual(moves, [])

    def test_client_on_numbered_workspace_moves_to_named_workspace(self) -> None:
        self.client["workspace"] = {"id": 1, "name": "1"}

        moves = reset_window_workspaces.planned_moves(
            self.load_obsidian_rule(), [self.client]
        )

        self.assertEqual(len(moves), 1)
        self.assertEqual(moves[0]["workspace"], "name:obsidian")

    def test_client_on_different_named_workspace_moves_to_target(self) -> None:
        self.client["workspace"] = {"id": -1338, "name": "scratch"}

        moves = reset_window_workspaces.planned_moves(
            self.load_obsidian_rule(), [self.client]
        )

        self.assertEqual(len(moves), 1)
        self.assertEqual(moves[0]["workspace"], "name:obsidian")

    def test_named_workspace_rule_strips_silent_suffix(self) -> None:
        rules = self.load_obsidian_rule()

        self.assertEqual(len(rules), 1)
        self.assertEqual(rules[0].workspace, "name:obsidian")

    def test_repository_obsidian_rule_remains_parseable(self) -> None:
        rules = reset_window_workspaces.load_rules(MODULE_PATH.with_name("hyprland.lua"))

        obsidian_rules = [
            rule
            for rule in rules
            if ("initial_class", "obsidian") in rule.matchers
        ]
        self.assertEqual(len(obsidian_rules), 1)
        self.assertEqual(obsidian_rules[0].workspace, "name:obsidian")

    def test_initial_class_matches_after_runtime_class_changes(self) -> None:
        self.client["class"] = "electron-runtime-class"
        self.client["workspace"] = {"id": 1, "name": "1"}

        moves = reset_window_workspaces.planned_moves(
            self.load_obsidian_rule(), [self.client]
        )

        self.assertEqual(len(moves), 1)

    def test_initial_class_match_falls_back_to_runtime_class_when_absent(self) -> None:
        del self.client["initialClass"]
        self.client["workspace"] = {"id": 1, "name": "1"}

        moves = reset_window_workspaces.planned_moves(
            self.load_obsidian_rule(), [self.client]
        )

        self.assertEqual(len(moves), 1)

    def test_known_initial_class_does_not_fall_back_to_runtime_class(self) -> None:
        self.client["initialClass"] = "not-obsidian"
        self.client["workspace"] = {"id": 1, "name": "1"}

        moves = reset_window_workspaces.planned_moves(
            self.load_obsidian_rule(), [self.client]
        )

        self.assertEqual(moves, [])

    def test_numeric_workspace_rule_parses_integer_target(self) -> None:
        rules = self.load_numeric_rule()

        self.assertEqual(len(rules), 1)
        self.assertEqual(rules[0].workspace, "12")

    def test_numeric_workspace_rule_moves_matching_client_to_integer_target(self) -> None:
        client = {
            "address": "0x2",
            "class": "kitty",
            "workspace": {"id": 2, "name": "2"},
        }

        moves = reset_window_workspaces.planned_moves(
            self.load_numeric_rule(), [client]
        )

        self.assertEqual(len(moves), 1)
        self.assertEqual(moves[0]["workspace"], "12")

    def test_move_uses_lua_dispatcher_with_full_named_selector(self) -> None:
        move = {
            "workspace": "name:obsidian",
            "address": "0x1",
        }

        self.assertEqual(
            reset_window_workspaces.lua_move_dispatcher(move),
            'hl.dsp.window.move({ workspace = "name:obsidian", '
            'window = "address:0x1", follow = false })',
        )

    def test_move_dispatcher_preserves_unicode_workspace_names(self) -> None:
        move = {
            "workspace": "name:資料",
            "address": "0x1",
        }

        self.assertIn(
            'workspace = "name:資料"',
            reset_window_workspaces.lua_move_dispatcher(move),
        )

    @mock.patch.object(reset_window_workspaces, "parse_args")
    @mock.patch.object(reset_window_workspaces, "load_rules", return_value=[])
    @mock.patch.object(reset_window_workspaces, "load_clients", return_value=[])
    @mock.patch.object(reset_window_workspaces, "planned_moves")
    @mock.patch.object(reset_window_workspaces.subprocess, "run")
    def test_dispatch_failure_is_not_silenced(
        self,
        run: mock.Mock,
        planned_moves: mock.Mock,
        _load_clients: mock.Mock,
        _load_rules: mock.Mock,
        parse_args: mock.Mock,
    ) -> None:
        parse_args.return_value = reset_window_workspaces.argparse.Namespace(
            config=Path("hyprland.lua"),
            clients_json=None,
            dry_run=False,
            print_rules=False,
        )
        planned_moves.return_value = [
            {"workspace": "name:obsidian", "address": "0x1"}
        ]
        run.side_effect = subprocess.CalledProcessError(1, "hyprctl")

        with self.assertRaises(subprocess.CalledProcessError):
            reset_window_workspaces.main()

        run.assert_called_once_with(
            [
                "hyprctl",
                "dispatch",
                'hl.dsp.window.move({ workspace = "name:obsidian", '
                'window = "address:0x1", follow = false })',
            ],
            check=True,
        )


if __name__ == "__main__":
    unittest.main()
