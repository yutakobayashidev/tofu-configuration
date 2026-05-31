# tofu-configuration

OpenTofu configurations for managing homelab infrastructure.

## Architecture

- **DigitalOcean**: Mastodon (future migration from Vultr), managed by OpenTofu
- **Cloudflare**: DNS, R2 (Mastodon media + Obsidian backup), API tokens
- **AWS SES**: Mastodon email delivery (ap-northeast-1)
- **HCP Terraform**: Remote state management
- **GitHub**: Repository settings managed via OpenTofu

## Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Infrastructure | OpenTofu | DO, Cloudflare, AWS SES, GitHub, HCP Terraform |
| State | HCP Terraform | Remote state storage (3 workspaces) |
| Lint | TFLint | OpenTofu static analysis |
| Dev Environment | Nix flake-parts | Tools, MCP servers, agent skills |

## Directory Layout

- `infra/global/` — Root module (providers, backend, variables, outputs)
- `infra/services/` — Service resources (R2 buckets, tokens, SES)
- `infra/services/tfe/` — HCP Terraform self-management (org, workspaces)
- `infra/services/github/` — GitHub repository settings
- `infra/domains/yutakobayashi-com/` — DNS records for yutakobayashi.com
- `infra/modules/` — Reusable modules (cloudflare-r2, cloudflare-account-token)

## Commands

```bash
# OpenTofu (each workspace is independent)
cd infra/global && tofu init && tofu plan && tofu apply
cd infra/services/tfe && tofu init && tofu plan && tofu apply
cd infra/services/github && tofu init && tofu plan && tofu apply

# TFLint
cd infra/global && tflint --init && tflint
```
