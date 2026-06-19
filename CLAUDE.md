# tofu-configuration

OpenTofu configurations for managing cloud infrastructure.

> [!NOTE]
> Self-hosted services (Gitea, Uptime Kuma, Tailscale etc.) are managed in [yutakobayashidev/dotnix](https://github.com/yutakobayashidev/dotnix).

## Architecture

- **DigitalOcean**: Mastodon (future migration from Vultr), managed by OpenTofu
- **Cloudflare**: DNS, Email Routing, R2 (Mastodon media + Obsidian backup), API tokens
- **AWS SES**: Mastodon email delivery (ap-northeast-1)
- **HCP Terraform**: Remote state management and VCS-connected workspaces
- **GitHub**: Repository settings managed via OpenTofu

## Stack

| Layer           | Tool            | Purpose                                        |
| --------------- | --------------- | ---------------------------------------------- |
| Infrastructure  | OpenTofu        | DO, Cloudflare, AWS SES, GitHub, HCP Terraform |
| State           | HCP Terraform   | Remote state storage (3 workspaces)            |
| Lint            | TFLint          | OpenTofu static analysis                       |
| Policy          | Conftest        | OpenTofu plan policy checks                    |
| Dev Environment | Nix flake-parts | Tools, MCP servers, agent skills               |

## Directory Layout

- `infra/global/` — Root module (providers, backend, variables, outputs)
- `infra/services/` — Service resources (R2 buckets, tokens, SES)
- `infra/services/tfe/` — HCP Terraform self-management (org, VCS-connected workspaces)
- `infra/services/github/` — GitHub repository settings
- `infra/global/domains/yutakobayashi-com/` — DNS records and Email Routing rules for yutakobayashi.com
- `infra/global/domains/yutakobayashi-dev/` — DNS records and Email Routing rules for yutakobayashi.dev
- `infra/modules/` — Reusable modules (cloudflare-r2, cloudflare-account-token)
- `policy/terraform/` — Conftest policies and unit tests

## Commands

```bash
# OpenTofu (each workspace is independent)
cd infra/global && tofu init && tofu plan && tofu apply
cd infra/services/tfe && tofu init && tofu plan && tofu apply
cd infra/services/github && tofu init && tofu plan && tofu apply

# TFLint
cd infra/global && tflint --init && tflint

# Policy unit tests (from repository root)
conftest verify --policy policy/terraform

# Policy check for a saved plan (from repository root)
tofu -chdir=infra/services/github plan -out=tfplan
tofu -chdir=infra/services/github show -json tfplan | conftest test --policy policy/terraform -
```

The workspaces managed from `infra/services/tfe` are connected to `yutakobayashidev/tofu-configuration` through the Terraform Cloud GitHub App.
