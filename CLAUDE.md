# tofu-configuration

OpenTofu configurations for managing cloud infrastructure.

> [!NOTE]
> Self-hosted services (Gitea, Uptime Kuma, Tailscale etc.) are managed in [yutakobayashidev/dotnix](https://github.com/yutakobayashidev/dotnix).

## Architecture

- **DigitalOcean**: Mastodon (future migration from Vultr), managed by OpenTofu
- **Cloudflare**: DNS, Email Routing, Email Sending (Mastodon and Gitea send from their own subdomains), R2 (Mastodon media + Obsidian backup), API tokens, notification policies, response header transforms
- **GitHub**: One OpenTofu root per repository using `zunoser/tfmodule-gh-repo-kit`, with state in Google Cloud Storage encrypted by Cloud KMS; see `docs/github-management.md`
- **OpenAI**: Official provider with encrypted R2 state; 162 resources imported (project, tunnels, memberships, settings, rate limits); see `docs/openai-import.md`. Home Assistant and Grafana tunnels are declared separately; see `docs/home-assistant-mcp.md` and `docs/grafana-mcp.md`

- **Supabase**: Official provider with encrypted R2 state for `infra/services/supabase`; three paused projects and one retained settings resource managed (`ticket-dev` deleted, `freeschool-search` paused). Two paused projects’ settings remain blocked. See `docs/supabase-import.md`.

## Stack

| Layer           | Tool            | Purpose                                        |
| --------------- | --------------- | ---------------------------------------------- |
| Infrastructure  | OpenTofu        | DO, Cloudflare, GitHub, OpenAI, Google Cloud   |
| State           | Cloudflare R2, GCS | Remote state storage (GCS for GitHub roots) |
| Lint            | TFLint          | OpenTofu static analysis                       |
| Policy          | Conftest        | OpenTofu plan policy checks                    |
| Dev Environment | Nix flake-parts | Tools, MCP servers, agent skills               |

## Directory Layout

- `infra/global/` — Root module (providers, backend, variables, outputs)
- `infra/services/` — Service resources (R2 buckets, tokens)
- `infra/services/github/repositories/<name>/` — One root per GitHub repository; credentials come from the environment (`docs/github-management.md`)
- `scripts/new-github-repository` — Writes the root for a new GitHub repository
- `infra/services/openai/` — OpenAI provider; use `OPENAI_ADMIN_KEY` for organization administration
- `infra/services/gcp/` — Google Cloud project with KMS keys and Workload Identity Federation that sign GitHub App tokens in CI; read `docs/gcp-github-app-signing.md` before changing it
- `infra/global/domains/yutakobayashi-com/` — DNS records, Email Routing rules, and response header transforms for yutakobayashi.com
- `infra/global/domains/yutakobayashi-dev/` — DNS records and Email Routing rules for yutakobayashi.dev
- `infra/modules/` — Reusable modules (cloudflare-r2, cloudflare-account-token)
- `policy/terraform/` — Conftest policies and unit tests

## Commands

```bash
# OpenTofu (each workspace is independent)
cd infra/global && tofu init && tofu plan && tofu apply
cd infra/services/openai && tofu init && tofu plan && tofu apply

# GitHub repository roots (export the credentials in docs/github-management.md first)
tofu -chdir=infra/services/github/repositories/<name> init
tofu -chdir=infra/services/github/repositories/<name> plan
nix develop -c scripts/new-github-repository <name> "<description>" public

# TFLint
cd infra/global && tflint --init && tflint

# Policy unit tests (from repository root)
conftest verify --policy policy/terraform

# Policy check for a saved plan (from repository root)
tofu -chdir=infra/services/github/repositories/dotnix plan -out=tfplan
tofu -chdir=infra/services/github/repositories/dotnix show -json tfplan | conftest test --policy policy/terraform -
```

Run init, plan, apply, and state commands for any root except the GitHub roots through `op run --env-file=op.env -- tofu ...`; `op.env` holds 1Password references for the R2 credentials, the passphrase, the `infra/global` variables, and `DISCORD_TOKEN` (`docs/service-state.md`). Never write their values to files. The GitHub roots use Google Cloud credentials instead (`docs/github-management.md`). Preserve the Git-ignored `terraform.tfstate.pre-r2` migration backups. OpenAI credentials use `OPENAI_ADMIN_KEY` from the environment.

Supabase credentials use `SUPABASE_ACCESS_TOKEN`.
DB passwords are unmanaged; do not use the import placeholders to create projects.
Do not resume paused projects just to complete import without user authorization.
