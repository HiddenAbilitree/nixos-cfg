---
name: project-initialization
description: >-
  Initializes new projects to the owner's conventions - Rust crates from HiddenAbilitree/rust-template,
  TypeScript apps on Bun (Elysia APIs, Tailwind-styled frontends in any framework), and Bun/Cargo monorepos
  mixing both - with a Nix flake dev shell, direnv, sops secrets, oxlint/oxfmt via opinionated-defaults,
  the Svelte MCP for Svelte apps, per-level AGENTS.md files, README, and .gitignore.

  Use when setting up, creating, initializing, scaffolding, or bootstrapping a new project, repository,
  or monorepo, or adding a new app to one.
---

# Project initialization

## Delegate when setup is part of a larger request

When the user asks for initialization plus other work (features, implementation, migrations), keep the main context for that work:

1. Spawn one subagent to initialize the project by following the `project-initialization` skill. Give it the target path, project name, one-sentence description, the shape and stack chosen below, whether the project is private and needs secrets, and any secret values supplied. Its result must be the report from step 8.
2. Once it reports, read the generated `AGENTS.md` files and do the remaining work in the main context.

## Defaults

Use these without offering alternatives:

| Concern | Choice |
| --- | --- |
| TypeScript runtime and package manager | Bun (`bun`, `bunx`); never npm, npx, or Node |
| TypeScript API | Elysia |
| Frontend | Tailwind for styling; no preferred framework |
| TypeScript lint and format | oxlint + oxfmt via `@hiddenability/opinionated-defaults` |
| Rust | Cargo, initialized from `HiddenAbilitree/rust-template` |
| Developer dependencies | Top-level `flake.nix`, loaded by `.envrc` with `use flake` |
| Secrets in private projects | sops with age |
| Scripts kept in the repo | TypeScript run with Bun; another language only when interop requires it |

Infer the name, one-sentence description, frontend framework, and whether the project is private and needs secrets from the request. Ask only for what cannot be inferred.

## Shapes

- **Rust**: one crate at the repo root.
- **TypeScript**: one app at the repo root.
- **Monorepo** (Rust and TypeScript, or several apps): each app in `apps/<app>/`, a Bun workspace at the root when any app is TypeScript, one top-level `Cargo.toml` when any app is Rust.

## Workflow

Copy this checklist and skip the steps the shape does not need:

```
- [ ] 1. Root: directory, git, flake, direnv
- [ ] 2. Rust
- [ ] 3. TypeScript apps and opinionated-defaults
- [ ] 4. Svelte MCP
- [ ] 5. Secrets
- [ ] 6. AGENTS.md, README.md, documentation/
- [ ] 7. .gitignore
- [ ] 8. Verify and report
```

Run every command from the repo root unless a step says otherwise.

### 1. Root

1. Create the repo root:
   - Any Rust: `gh repo clone HiddenAbilitree/rust-template <dir> -- --depth=1`. It provides `Cargo.toml`, `Cargo.lock`, `flake.nix`, `flake.lock`, `.envrc`, `.gitignore`, and `src/main.rs`.
   - One TypeScript app: run its step 3 scaffolder with `<dir>` as the target.
   - TypeScript-only monorepo: `mkdir <dir>`.
2. Delete `<dir>/.git` if the clone or scaffolder created it, then run `git init`.
3. `flake.nix`:
   - With Rust, keep the template flake. Add `pkgs.bun` to the dev shell's `buildInputs` when any app is TypeScript.
   - TypeScript only:

     ```nix
     {
       inputs = {
         nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
         systems.url = "systems";
       };

       outputs =
         { nixpkgs, systems, ... }:
         let
           eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
         in
         {
           devShells = eachSystem (pkgs: {
             default = pkgs.mkShell {
               buildInputs = [ pkgs.bun ];
             };
           });
         };
     }
     ```

   All developer dependencies go in this flake. Exception: a dependency that is missing from the binary cache or is several gigabytes gets its own `flake.nix` and an `.envrc` with `use flake` in the directory that needs it; put `source_up` above `use flake` there to keep the root dev shell.
4. `.envrc` contains `use flake`; step 5 extends it.
5. `git add flake.nix` (flakes ignore untracked files), then `direnv allow`. Run toolchain commands through `direnv exec . <command>` when the current shell has not loaded the environment.

### 2. Rust

Rename `[package] name` in `Cargo.toml` from `rust-template` to the project name.

In a monorepo, the template `Cargo.toml` stays at the root. Move `src/main.rs` to `apps/<app>/src/main.rs` and add one binary target per Rust app:

```toml
[[bin]]
name = "<app>"
path = "apps/<app>/src/main.rs"
```

If apps need separate crates, turn the root into a `[workspace]` with members in `apps/`, keeping `cargo-features` and the `[profile.*]` tables at the root.

Run `cargo build` to refresh `Cargo.lock`.

### 3. TypeScript

Monorepo root `package.json`. Bun skips `apps/*` directories without a `package.json`, so Rust apps can live there too:

```json
{
  "name": "<project>",
  "private": true,
  "type": "module",
  "workspaces": ["apps/*"]
}
```

Scaffold each app into its target, `apps/<app>` in a monorepo or `<dir>` for one app. Then delete what the scaffolder created that the repo already covers: any `README.md`, `.git/`, `.vscode/`, `.npmrc`, and lint or format setup (`.oxlintrc.json`, `eslint.config.*`, `.prettierrc*`, the app's `lint`/`format` scripts and their dev dependencies). A leftover app-level lint config overrides the root one for that app, so lint passes without the owner's rules.

- API: `bun create elysia <target>`.
- Frontend: use the framework the request names. Scaffold it in TypeScript, without prompts, with its official creator through Bun (Vite-based: `bun create vite <target> --template <framework>-ts`). Add Tailwind through the framework's official integration (`@tailwindcss/vite` for Vite) and replace the template's CSS with `@import "tailwindcss";`.
- Svelte is the one framework with extra setup: run `bunx sv add ai-tools="ide:other" --cwd <target> --no-git-check --no-install`, keep the `AGENTS.md` it writes (it documents the Svelte MCP tools), and do step 4. For SvelteKit, one command covers the scaffold, Tailwind, and that `AGENTS.md`: `bunx sv create --template minimal --types ts --add tailwindcss="plugins:none" ai-tools="ide:other" --install bun <target>`.

Then, from the TypeScript root (the repo root in a monorepo):

```bash
bun install
bunx @hiddenability/opinionated-defaults@latest
```

The CLI adds oxlint, oxfmt, and the config package as dev dependencies, writes `oxlint.config.ts` and `oxfmt.config.ts`, and adds the `lint`, `lint:fix`, `format`, and `format:check` scripts. At a monorepo root it writes one config pair with per-app overrides and deletes app-level `oxlint.config.ts` and `oxfmt.config.ts`, but no other config formats. It should work there; if it fails, mark it as an error in the final report, with its output.

### 4. Svelte MCP

For any Svelte app, write `.mcp.json` at the repo root, including in monorepos, since agents load it from the directory the session starts in:

```json
{
  "mcpServers": {
    "svelte": {
      "type": "stdio",
      "command": "bunx",
      "args": ["@sveltejs/mcp"]
    }
  }
}
```

### 5. Secrets

Private projects that need secrets use sops.

1. Add `pkgs.sops`, `pkgs.yq-go`, and this editing helper to the dev shell's `buildInputs`:

   ```nix
   (pkgs.writeShellScriptBin "senv" ''
     cd "$(git rev-parse --show-toplevel)"
     sops secrets.dev.yaml
   '')
   ```

2. Copy [sops.yaml](sops.yaml) from this skill's directory to the repo root as `.sops.yaml`. It holds the owner's per-machine age recipients and the creation rule for `secrets.dev.yaml`. Copy the file; never retype the keys.

3. Create the encrypted file, then add each secret as a flat key so plaintext never touches disk. If `sops set` cannot decrypt the file, this machine's age key is missing from `sops.yaml`; report that instead of editing the recipients:

   ```bash
   printf '{}\n' > secrets.dev.yaml
   sops -e -i secrets.dev.yaml
   sops set secrets.dev.yaml '["DATABASE_URL"]' '"postgres://..."'
   ```

4. Replace `.envrc` so direnv exports every secret, then run `direnv allow` again:

   ```bash
   strict_env

   watch_file .sops.yaml secrets.dev.yaml

   use flake

   secret_exports="$(
   	sops -d secrets.dev.yaml |
   		yq -o=shell 'with_entries(select(.value != null))' |
   		sed 's/^/export /'
   )"

   eval "$secret_exports"
   unset secret_exports
   ```

### 6. AGENTS.md, README.md, documentation/

Write one `AGENTS.md` per distinct level. The root file holds shared guidance. Each distinct project variation gets its own file with only its stack-specific guidance, such as the Svelte MCP instructions `sv` generated in `apps/ui/AGENTS.md`. Never repeat root content in a child file. In a one-app project, that guidance goes in the root file instead.

Root `AGENTS.md` template. Replace the example apps under Project Structure with the real ones, giving each its role and data boundary, fill in the Tooling paths, and drop the lines and sections that do not apply:

```markdown
# Project Structure

- `apps/api/` — backend. All data processing happens here.
- `apps/ui/` — frontend. No data processing happens here. Any server functionality must be limited for the purpose of SSR / dynamic meta tags.
- `documentation/` — detailed implementation details that are important for future agents. See per-file comments below.
  - none yet.

# Must-Dos

## Tooling

After any change to `<rust app dirs>`, you must run `cargo clippy --allow-dirty --all-targets --all-features --fix -- -W clippy::pedantic -W clippy::nursery`
After any change to `<typescript app dirs>`, you must run `bun run lint:fix` and `bun run format` from the repository root.

All dev dependencies are declared in the top-level `flake.nix`. Enter the shell with `nix develop`.

You must resolve ALL lint issues, regardless of whether you caused it.

## Language & Style

- TypeScript only. Never JavaScript.
- Bun for runtime and package management. Never Node, never npm.
- Tailwind for styling. Never vanilla CSS.
- Prefer the language's own idioms over hand-rolled equivalents.
- Write any scripting in TypeScript.

## Secrets

- Secrets live in `secrets.dev.yaml`, encrypted with sops, and direnv exports them. Outside direnv, use `sops exec-env secrets.dev.yaml '<command>'`.
- Edit them with `senv`, or add one with `sops set secrets.dev.yaml '["KEY"]' '"value"'`.
- Never print decrypted secrets or write them to plaintext files.

## Docs

- Never edit `README.md`.
- Edit this file only when it actually needs it: high-level structure and global must-dos only. Detailed implementation notes belong in `documentation/`, linked from here with a short comment saying what the file documents.
```

`cargo clippy --fix` refuses to run with uncommitted changes, hence `--allow-dirty`.

Root `README.md`, nothing more:

```markdown
# <name>

<one-sentence description>
```

Create an empty `documentation/` directory.

### 7. .gitignore

Do this last, after every tool has generated its files:

- The root `.gitignore` covers root-level artifacts such as `.direnv`, `target`, and `node_modules`.
- Monorepo: move entries shared by several app `.gitignore` files to the root and delete them from the apps; leave entries specific to one app in that app's file. Unanchor moved patterns (`/build` becomes `build`). Delete app `.gitignore` files that end up empty.
- Never ignore `secrets.dev.yaml`; it is encrypted and committed.

### 8. Verify and report

Inside the dev shell:

- `direnv exec . true` loads without errors.
- Rust: run the clippy command from the root `AGENTS.md` until it reports nothing, then `cargo build`.
- TypeScript: `bun run lint:fix` and `bun run format`, then `bun run lint` and `bun run format:check` must pass. Fresh scaffolds often fail them. Known cases: SvelteKit's empty `src/lib/index.ts` (delete it along with the `"#lib"` entry pointing at it in the app's `package.json` `imports`) and Elysia's `"moduleResolution": "node"` (tsgolint rejects it; use `"bundler"`). Fix every issue.
- Apps with a `check` script (SvelteKit's `svelte-check`): `bun run check` in a one-app project, `bun run --filter '*' check` in a monorepo.
- Secrets: `sops -d secrets.dev.yaml > /dev/null` succeeds.

Final message, which is the subagent's result when delegated: the created tree, each command run with its result, and every error, including opinionated-defaults failing at a monorepo root.
