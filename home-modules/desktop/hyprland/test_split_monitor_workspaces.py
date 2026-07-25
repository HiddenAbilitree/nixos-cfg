from __future__ import annotations

import json
import re
import shutil
import stat
import subprocess
import tempfile
import textwrap
import unittest
from pathlib import Path


MODULE_DIR = Path(__file__).resolve().parent
REPO_ROOT = MODULE_DIR.parents[2]
PATCH_PATH = (
    MODULE_DIR
    / "patches"
    / "split-monitor-workspaces-rogue-workspace-exclusions.patch"
)
SMW_REVISION = "08947bcd474fd5e8e4b558cc908dd4b7659f4dc4"
NOCTALIA_REVISION = "034115fb80b4fc5121b7ff26aedd634a04119884"
NOCTALIA_CONFIG_VERSION = 2


def nix_input_path(name: str) -> Path:
    expression = f"(builtins.getFlake (toString ./.)).inputs.{name}.outPath"
    output = subprocess.check_output(
        ["nix", "eval", "--raw", "--impure", "--expr", expression],
        cwd=REPO_ROOT,
        text=True,
    )
    return Path(output.strip())


def lua_executable() -> Path:
    expression = textwrap.dedent(
        """
        let
          flake = builtins.getFlake (toString ./.);
          pkgs = flake.inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
        in
          pkgs.lua5_4
        """
    ).strip()
    output = subprocess.check_output(
        [
            "nix",
            "build",
            "--no-link",
            "--print-out-paths",
            "--impure",
            "--expr",
            expression,
        ],
        cwd=REPO_ROOT,
        text=True,
    )
    return Path(output.strip()) / "bin" / "lua"


def generated_hyprland_config(host: str) -> Path:
    output = subprocess.check_output(
        [
            "nix",
            "build",
            "--no-link",
            "--print-out-paths",
            f".#nixosConfigurations.{host}.config.home-manager.users.ezhang.home.activationPackage",
        ],
        cwd=REPO_ROOT,
        text=True,
    )
    generation = Path(output.strip().splitlines()[-1])
    return generation / "home-files" / ".config" / "hypr" / "hyprland.lua"


def make_writable(path: Path) -> None:
    for entry in [path, *path.rglob("*")]:
        entry.chmod(entry.stat().st_mode | stat.S_IWUSR)


def parse_trace(trace: str) -> dict[str, str]:
    return dict(field.split("=", 1) for field in trace.split("|"))


class SplitMonitorWorkspacesTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.raw_source = nix_input_path("split-monitor-workspaces")
        cls.lua = lua_executable()
        cls.temporary_directory = tempfile.TemporaryDirectory()
        cls.patched_source = Path(cls.temporary_directory.name) / "source"
        shutil.copytree(cls.raw_source, cls.patched_source)
        make_writable(cls.patched_source)
        subprocess.run(
            ["patch", "-p1", "--input", str(PATCH_PATH)],
            cwd=cls.patched_source,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temporary_directory.cleanup()

    def run_lua(self, source: Path, body: str) -> str:
        script = (
            f"package.path = {json.dumps(str(source / 'lua' / '?.lua'))}"
            " .. ';' .. package.path\n"
            + textwrap.dedent(body)
        )
        result = subprocess.run(
            [self.lua, "-"],
            input=script,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        lines = [line for line in result.stdout.splitlines() if line]
        return lines[-1] if lines else ""

    def lifecycle_trace(
        self,
        source: Path,
        monitor_count: int,
        exclusions: tuple[str, ...] | None = None,
    ) -> dict[str, str]:
        exclusion_config = ""
        if exclusions is not None:
            exclusions_lua = ", ".join(json.dumps(value) for value in exclusions)
            exclusion_config = (
                f"rogue_workspace_exclusions = {{ {exclusions_lua} }},"
            )
        body = """
            local requested_count = __MONITOR_COUNT__
            local first = {
              id = 1,
              name = "DP-1",
              is_mirror = false,
              active_workspace = { name = "1", special = false },
            }
            local second = {
              id = 2,
              name = "DP-2",
              is_mirror = false,
              active_workspace = { name = "10", special = false },
            }
            local mirror = {
              id = 3,
              name = "DP-3",
              is_mirror = true,
              active_workspace = { name = "19", special = false },
            }
            local connected = { first }
            if requested_count == 2 then table.insert(connected, second) end
            table.insert(connected, mirror)

            local actions = {}
            local handlers = {}
            local rules = {}
            local windows = {
              { title = "mapped", mapped = true, workspace = { name = "2", special = false } },
              { title = "obsidian", mapped = true, workspace = { name = "obsidian", special = false } },
              { title = "scratch", mapped = true, workspace = { name = "scratch", special = false } },
              { title = "special", mapped = true, workspace = { name = "special:scratch", special = true } },
              { title = "unmapped", mapped = false, workspace = { name = "unmapped", special = false } },
              { title = "missing-workspace", mapped = true },
            }

            local function slice(values, first_index)
              local result = {}
              for index = first_index, #values do
                table.insert(result, values[index])
              end
              return table.concat(result, ",")
            end

            local function workspace_map(globals, monitor_id)
              local workspaces = globals.monitor_workspace_map[monitor_id]
              return workspaces and table.concat(workspaces, ",") or "nil"
            end

            hl = {
              on = function(event, handler) handlers[event] = handler end,
              get_monitors = function() return connected end,
              get_active_monitor = function() return first end,
              get_monitor_at_cursor = function() return nil end,
              get_active_workspace = function(monitor) return monitor.active_workspace end,
              get_workspace = function() return nil end,
              get_windows = function() return windows end,
              get_config = function() return "" end,
              workspace_rule = function(rule)
                table.insert(
                  rules,
                  rule.workspace .. ":" .. tostring(rule.persistent) .. "@" .. tostring(rule.monitor)
                )
              end,
              dsp = {
                focus = function(args) return "focus:" .. args.workspace end,
                workspace = {
                  move = function(args)
                    return "move:" .. args.workspace .. "@" .. args.monitor
                  end,
                },
                window = {
                  move = function(args)
                    return "window:" .. args.window.title .. "->" .. args.workspace
                  end,
                },
              },
              dispatch = function(action) table.insert(actions, action) end,
            }

            local smw = require("split-monitor-workspaces")
            local globals = require("globals")
            smw.setup({
              workspace_count = 9,
              keep_focused = false,
              enable_notifications = false,
              enable_persistent_workspaces = true,
              monitor_priority = { "DP-1", "DP-2" },
              __EXCLUSION_CONFIG__
            })

            handlers["monitor.added"](first)
            if requested_count == 2 then handlers["monitor.added"](second) end
            local initial_map = workspace_map(globals, 1)
            if requested_count == 2 then
              initial_map = initial_map .. ";" .. workspace_map(globals, 2)
            end
            local initial_rules = slice(rules, 1)
            local initial_actions = slice(actions, 1)

            local rules_before_mirror = #rules
            handlers["monitor.added"](mirror)
            local mirror_rule_delta = #rules - rules_before_mirror

            local removed_monitor = requested_count == 2 and second or first
            local rules_before_remove = #rules
            handlers["monitor.removed"](removed_monitor)
            local removed_map = workspace_map(globals, 1)
            if requested_count == 2 then
              removed_map = removed_map .. ";" .. workspace_map(globals, 2)
            end
            local removed_rules = slice(rules, rules_before_remove + 1)

            local rogue_actions = ""
            if requested_count == 2 then
              local actions_before_rogue = #actions
              smw.grab_rogue_windows()()
              rogue_actions = slice(actions, actions_before_rogue + 1)
            end

            local rules_before_readd = #rules
            local actions_before_readd = #actions
            handlers["monitor.added"](removed_monitor)
            local readded_map = workspace_map(globals, 1)
            if requested_count == 2 then
              readded_map = readded_map .. ";" .. workspace_map(globals, 2)
            end
            local readded_rules = slice(rules, rules_before_readd + 1)
            local readded_actions = slice(actions, actions_before_readd + 1)

            local event_names = {}
            for event, _ in pairs(handlers) do table.insert(event_names, event) end
            table.sort(event_names)
            print(table.concat({
              "events=" .. table.concat(event_names, ","),
              "initial_map=" .. initial_map,
              "initial_rules=" .. initial_rules,
              "initial_actions=" .. initial_actions,
              "mirror_map=" .. workspace_map(globals, 3),
              "mirror_rule_delta=" .. tostring(mirror_rule_delta),
              "removed_map=" .. removed_map,
              "removed_rules=" .. removed_rules,
              "rogue_actions=" .. rogue_actions,
              "readded_map=" .. readded_map,
              "readded_rules=" .. readded_rules,
              "readded_actions=" .. readded_actions,
            }, "|"))
        """
        body = body.replace("__MONITOR_COUNT__", str(monitor_count))
        body = body.replace("__EXCLUSION_CONFIG__", exclusion_config)
        return parse_trace(self.run_lua(source, body))

    def number_binding_trace(self, source: Path, monitor_id: int) -> str:
        body = """
            local selected_monitor_id = __MONITOR_ID__
            local first = {
              id = 1,
              name = "DP-1",
              is_mirror = false,
              active_workspace = { name = "1", special = false },
            }
            local second = {
              id = 2,
              name = "DP-2",
              is_mirror = false,
              active_workspace = { name = "10", special = false },
            }
            local monitors = { first, second }
            local selected = selected_monitor_id == 1 and first or second
            local handlers = {}
            local actions = {}

            hl = {
              on = function(event, handler) handlers[event] = handler end,
              get_monitors = function() return monitors end,
              get_active_monitor = function() return selected end,
              get_monitor_at_cursor = function() return nil end,
              get_active_workspace = function(monitor) return monitor.active_workspace end,
              get_workspace = function() return nil end,
              get_config = function() return "" end,
              workspace_rule = function() end,
              dsp = {
                focus = function(args) return "focus:" .. args.workspace end,
                workspace = {
                  move = function(args)
                    return "move:" .. args.workspace .. "@" .. args.monitor
                  end,
                },
              },
              dispatch = function(action) table.insert(actions, action) end,
            }

            local smw = require("split-monitor-workspaces")
            smw.setup({
              workspace_count = 9,
              keep_focused = false,
              enable_notifications = false,
              enable_persistent_workspaces = true,
              monitor_priority = { "DP-1", "DP-2" },
            })
            handlers["monitor.added"](first)
            handlers["monitor.added"](second)

            actions = {}
            selected.active_workspace = { name = "obsidian", special = false }
            for workspace = 1, 9 do
              smw.workspace(tostring(workspace))()
            end
            print(table.concat(actions, ","))
        """
        return self.run_lua(
            source,
            body.replace("__MONITOR_ID__", str(monitor_id)),
        )

    def test_locked_split_monitor_workspaces_revision(self) -> None:
        lock = json.loads((REPO_ROOT / "flake.lock").read_text())

        self.assertEqual(
            lock["nodes"]["split-monitor-workspaces"]["locked"]["rev"],
            SMW_REVISION,
        )

    def test_patch_is_narrow_default_empty_and_generic(self) -> None:
        patch = PATCH_PATH.read_text()
        touched_files = {
            line.removeprefix("+++ b/")
            for line in patch.splitlines()
            if line.startswith("+++ b/")
        }

        self.assertEqual(
            touched_files,
            {"lua/globals.lua", "lua/dispatchers.lua"},
        )
        self.assertNotIn("obsidian", patch.lower())
        globals_text = (self.patched_source / "lua" / "globals.lua").read_text()
        self.assertIn("rogue_workspace_exclusions = {}", globals_text)

    def test_both_generated_configs_use_the_patched_source(self) -> None:
        source_pattern = re.compile(
            r'package\.path = package\.path \.\. ";'
            r'(?P<source>/nix/store/[^\"]+-split-monitor-workspaces-patched)'
            r'/lua/\?\.lua"'
        )

        for host in ("loser", "winner"):
            with self.subTest(host=host):
                config = generated_hyprland_config(host).read_text()
                match = source_pattern.search(config)
                self.assertIsNotNone(match)
                assert match is not None
                patched_source = Path(match.group("source"))
                self.assertIn(
                    "rogue_workspace_exclusions",
                    (patched_source / "lua" / "dispatchers.lua").read_text(),
                )

    def test_shift_tab_moves_window_silently_to_named_workspace(self) -> None:
        expected_move = (
            'hl.bind(mod .. " + SHIFT + Tab", '
            "hl.dsp.window.move({ workspace = obsidian_workspace_selector, "
            "follow = false }))"
        )
        expected_entry = (
            'hl.bind(mod .. " + Tab", '
            "hl.dsp.focus({ workspace = obsidian_workspace_selector }))"
        )
        sources = {
            "repository": (MODULE_DIR / "hyprland.lua").read_text(),
            **{
                host: generated_hyprland_config(host).read_text()
                for host in ("loser", "winner")
            },
        }

        for source, config in sources.items():
            with self.subTest(source=source):
                shift_tab_bindings = [
                    line.strip()
                    for line in config.splitlines()
                    if "SHIFT + Tab" in line
                ]
                self.assertEqual(shift_tab_bindings, [expected_move])
                self.assertIn(expected_entry, config)

    def test_obsidian_starts_exactly_once_from_on_start(self) -> None:
        sources = {
            "repository": (MODULE_DIR / "hyprland.lua").read_text(),
            **{
                host: generated_hyprland_config(host).read_text()
                for host in ("loser", "winner")
            },
        }

        for source, config in sources.items():
            with self.subTest(source=source):
                startup_lists = re.findall(
                    r"^on_start\(\{\n(?P<commands>.*?)^\}\)$",
                    config,
                    flags=re.MULTILINE | re.DOTALL,
                )
                self.assertEqual(len(startup_lists), 1)
                startup_commands = [
                    line.strip().removesuffix(",")
                    for line in startup_lists[0].splitlines()
                    if line.strip()
                ]
                self.assertEqual(startup_commands.count('"obsidian"'), 1)

    def test_default_empty_allowlist_preserves_rogue_recovery(self) -> None:
        raw = self.lifecycle_trace(self.raw_source, monitor_count=2)
        patched = self.lifecycle_trace(self.patched_source, monitor_count=2)

        self.assertEqual(patched["rogue_actions"], raw["rogue_actions"])
        self.assertEqual(
            patched["rogue_actions"],
            "window:obsidian->1,window:scratch->1",
        )

    def test_one_monitor_lifecycle_is_raw_equivalent(self) -> None:
        raw = self.lifecycle_trace(self.raw_source, monitor_count=1)
        patched = self.lifecycle_trace(self.patched_source, monitor_count=1)

        self.assertEqual(patched, raw)
        self.assertEqual(patched["initial_map"], ",".join(map(str, range(1, 10))))
        self.assertEqual(patched["removed_map"], "nil")
        self.assertEqual(patched["readded_map"], patched["initial_map"])
        self.assertIn("1:true@DP-1", patched["initial_rules"])
        self.assertIn("1:false@nil", patched["removed_rules"])
        self.assertIn("focus:1", patched["initial_actions"])
        self.assertIn("move:1@DP-1", patched["initial_actions"])

    def test_two_monitor_lifecycle_is_raw_equivalent(self) -> None:
        raw = self.lifecycle_trace(self.raw_source, monitor_count=2)
        patched = self.lifecycle_trace(self.patched_source, monitor_count=2)
        expected_map = (
            ",".join(map(str, range(1, 10)))
            + ";"
            + ",".join(map(str, range(10, 19)))
        )

        self.assertEqual(patched, raw)
        self.assertEqual(patched["initial_map"], expected_map)
        self.assertEqual(patched["removed_map"], expected_map.split(";")[0] + ";nil")
        self.assertEqual(patched["readded_map"], expected_map)
        self.assertIn("10:true@DP-2", patched["initial_rules"])
        self.assertIn("10:false@nil", patched["removed_rules"])
        self.assertIn("focus:10", patched["initial_actions"])
        self.assertIn("move:10@DP-2", patched["initial_actions"])

    def test_mirror_monitor_is_ignored_by_registered_added_handler(self) -> None:
        trace = self.lifecycle_trace(self.patched_source, monitor_count=2)

        self.assertEqual(trace["mirror_map"], "nil")
        self.assertEqual(trace["mirror_rule_delta"], "0")

    def test_registered_handlers_cleanup_and_restore_persistence(self) -> None:
        trace = self.lifecycle_trace(self.patched_source, monitor_count=2)

        self.assertEqual(
            trace["events"],
            "config.reloaded,monitor.added,monitor.removed",
        )
        self.assertEqual(
            trace["removed_rules"],
            ",".join(f"{workspace}:false@nil" for workspace in range(10, 19)),
        )
        self.assertEqual(
            trace["readded_rules"],
            ",".join(f"{workspace}:true@DP-2" for workspace in range(10, 19)),
        )
        self.assertIn("focus:10", trace["readded_actions"])
        self.assertIn("move:10@DP-2", trace["readded_actions"])

    def test_removed_monitor_recovery_keeps_only_allowlisted_named_workspace(
        self,
    ) -> None:
        trace = self.lifecycle_trace(
            self.patched_source,
            monitor_count=2,
            exclusions=("obsidian",),
        )

        self.assertEqual(trace["rogue_actions"], "window:scratch->1")

    def test_selector_spelling_does_not_exempt_runtime_workspace_name(self) -> None:
        trace = self.lifecycle_trace(
            self.patched_source,
            monitor_count=2,
            exclusions=("name:obsidian",),
        )

        self.assertEqual(
            trace["rogue_actions"],
            "window:obsidian->1,window:scratch->1",
        )

    def test_all_number_bindings_leave_named_workspace_on_first_monitor(self) -> None:
        expected = ",".join(f"focus:{workspace}" for workspace in range(1, 10))

        self.assertEqual(self.number_binding_trace(self.raw_source, 1), expected)
        self.assertEqual(self.number_binding_trace(self.patched_source, 1), expected)

    def test_all_number_bindings_leave_named_workspace_on_second_monitor(self) -> None:
        expected = ",".join(f"focus:{workspace}" for workspace in range(10, 19))

        self.assertEqual(self.number_binding_trace(self.raw_source, 2), expected)
        self.assertEqual(self.number_binding_trace(self.patched_source, 2), expected)


class NoctaliaWorkspaceSourceTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.noctalia_source = nix_input_path("noctalia")

    def test_pinned_backend_includes_named_and_excludes_only_special(self) -> None:
        lock = json.loads((REPO_ROOT / "flake.lock").read_text())
        noctalia_node = lock["nodes"]["noctalia"]
        self.assertEqual(noctalia_node["locked"]["rev"], NOCTALIA_REVISION)

        backend = (
            self.noctalia_source
            / "src"
            / "compositors"
            / "hyprland"
            / "hyprland_workspace_backend.cpp"
        ).read_text()
        self.assertIn('target = "name:" + workspace->name;', backend)
        self.assertIn("if (!isSpecial(workspace))", backend)
        self.assertIn(
            'state.name == "special" || state.name.starts_with("special:")',
            backend,
        )
        self.assertIn("return a->name < b->name;", backend)

        local_config = (
            REPO_ROOT / "home-modules" / "desktop" / "noctalia" / "default.nix"
        ).read_text()
        self.assertIn('"workspaces"', local_config)
        self.assertIn("hide_when_empty = false;", local_config)
        self.assertNotIn("obsidian", local_config.lower())

    def test_pinned_version_matches_persistent_state_schema(self) -> None:
        migrations = (
            self.noctalia_source / "src" / "config" / "config_migrations.cpp"
        ).read_text()
        supported_versions = [
            int(version)
            for version in re.findall(
                r"constexpr int k\w+MigrationVersion = (\d+);", migrations
            )
        ]

        self.assertTrue(supported_versions)
        self.assertEqual(max(supported_versions), NOCTALIA_CONFIG_VERSION)


if __name__ == "__main__":
    unittest.main()
