---
name: cf-cli
description: Cloudflare's official cf CLI (beta) for the public Cloudflare API and Workers projects. Use for finding and running Cloudflare commands from the terminal — sign-in and profiles, cf cli search, cf schema, cf deploy/dev/build, resource commands for DNS, zones, D1, KV, and R2 — and for choosing between cf and Wrangler in a project.
---

# Cloudflare CLI (`cf`)

`cf` is Cloudflare's command-line interface for the public Cloudflare API (2,900+ commands, most generated from API schemas) and for Workers projects. It is in beta: commands, configuration, and Build Output can change before the stable release.

**Prefer retrieval over pre-trained knowledge.** Describe the task to `cf cli search`, inspect the match with `cf schema` or `--help`, and preview with `--dry-run` before running a command you have not verified.

Docs index: https://developers.cloudflare.com/cf/llms.txt

## Documentation

| Topic | Page |
|-------|------|
| Install, sign in, credential and account selection | https://developers.cloudflare.com/cf/get-started/index.md |
| First Worker with `cf init`, `cf dev`, `cf deploy` | https://developers.cloudflare.com/cf/get-started/first-worker/index.md |
| Find, create, and delete resources from the terminal | https://developers.cloudflare.com/cf/get-started/resources/index.md |
| `cf` for Wrangler users | https://developers.cloudflare.com/cf/wrangler/index.md |
| Migrate a Wrangler project with `cf migrate` | https://developers.cloudflare.com/cf/wrangler/migrate/index.md |
| Wrangler-to-`cf` command and config reference | https://developers.cloudflare.com/cf/wrangler/reference/index.md |
| Develop, build, and deploy; modes and previews | https://developers.cloudflare.com/cf/projects/index.md |
| Typed `cloudflare.config.ts` | https://developers.cloudflare.com/cf/projects/cloudflare-config/index.md |
| Using `cf` with coding agents (safety rules) | https://developers.cloudflare.com/cf/agents/index.md |
| CI, API tokens, unattended authentication | https://developers.cloudflare.com/cf/ci/index.md |
| Environment variables | https://developers.cloudflare.com/cf/environment-variables/index.md |

## Find commands

```bash
cf cli search "create a DNS record"   # local, no credentials; quote the whole task; up to 5 JSON matches
cf schema d1 create                   # API request shape: method, path, params, body fields
cf <command> --help                   # arguments and options (e.g. cf deploy --help)
```

`cf cli search` takes the task as one argument — unquoted words after the first are parsed as unknown commands. `cf schema` covers generated API commands; for command arguments and options use `--help`.

## Read output

- Results are JSON on standard output; status messages and errors go to standard error, so piping to `jq` or redirecting needs no extra flags.
- Lists print one JSON array page; paging options differ per command — check `--help`.
- A failed command exits non-zero and prints the error to standard error.

## Run commands safely

- **Preview first.** `--dry-run` prints the request as JSON without sending it, and needs no credentials.
- **Aborted deletes still exit 0.** In a non-interactive session, a destructive command without `--force` prints `Aborted.` to standard error and exits `0` — a zero exit does not mean the resource was deleted.
- **Review `--force` before allowing it.** On some commands `--force` is also an API parameter (for example, `cf workers delete --force` also deletes a Worker that other Workers reference).
- **`--local` is limited.** It works for KV keys, D1 databases (`cf d1 raw`, `cf d1 migrations list|apply`), and R2 objects; other commands (including `cf d1 query`) return an error instead of calling the API.

## Commands `cf` does not support yet

`cf` does not support every Wrangler command yet. Run these with `npx wrangler` instead of adding Wrangler to the project. Wrangler does not read `cloudflare.config.ts`, so pass the Worker name:

- Live logs: `npx wrangler tail <WORKER_NAME>`.
- A single secret: `npx wrangler secret put <SECRET_NAME> --name <WORKER_NAME>`. Or upload secrets with a new Worker version by passing `--secrets-file <PATH>` to `cf deploy` or `cf workers versions create`.

For the current list, refer to "Commands not yet supported" in the [Wrangler to cf reference](https://developers.cloudflare.com/cf/wrangler/reference/index.md).
