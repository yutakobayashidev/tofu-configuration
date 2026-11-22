# tofu-configuration

OpenTofu configurations for managing cloud infrastructure.

> [!NOTE]
> Self-hosted services (Gitea, Uptime Kuma, Tailscale etc.) are managed in [yutakobayashidev/dotnix](https://github.com/yutakobayashidev/dotnix).

## Architecture

```
Cloudflare
├── DNS (yutakobayashi.com)
├── Email Routing
├── R2 (Mastodon media / Obsidian backup)
├── API Tokens
└── Notification Policies

DigitalOcean (future)
├── Droplet (Mastodon)
└── Spaces (backups)

R2 state (homelab-infra-state)
├── Homelab infrastructure
├── Discord server settings
├── HCP Terraform organization and workspace settings
├── GitHub repositories (one state per repository)
├── OpenAI projects (infra/services/openai)
└── Supabase projects and settings (infra/services/supabase)
```

## Prerequisites

- [Nix](https://nixos.org/) (recommended) or install manually:
  - [OpenTofu](https://opentofu.org/) >= 1.10
  - [TFLint](https://github.com/terraform-linters/tflint)
  - [Conftest](https://www.conftest.dev/)
  - [Regal](https://github.com/open-policy-agent/regal)

## Setup

### 1. Development Environment

```bash
# Install all dev tools via Nix flake
nix develop

# MCP servers and agent skills are auto-configured via shellHook
# OpenTofu providers are bundled in the dev shell
```

### 2. R2 backend credentials

[Load the R2 credentials and state passphrase](docs/service-state.md#credentials)
before initializing a root. The `tfe` root also needs HCP Terraform provider
credentials to manage the HCP organization and workspaces.

### 3. OpenTofu

Independent workspaces:

| Directory                                     | Workspace | Manages                                 |
| --------------------------------------------- | --------- | --------------------------------------- |
| `infra/global/`                               | R2        | Cloudflare DNS/R2, DO                   |
| `infra/services/discord/yuta-studio/`         | R2        | Discord server settings                  |
| `infra/services/tfe/`                         | R2        | HCP Terraform organization, workspaces  |
| `infra/services/github/repositories/<name>/`  | R2        | One GitHub repository per root          |
| `infra/services/openai/`                      | R2        | OpenAI projects                         |
| `infra/services/supabase/`                    | R2        | Supabase projects and settings          |

The GitHub repository roots read credentials from the environment instead of
`terraform.tfvars`; see [GitHub management](docs/github-management.md).

```bash
cd infra/global  # or infra/services/tfe

# Create and edit variables file
cp terraform.tfvars.example terraform.tfvars

# Init, plan, apply
tofu init
tofu plan
tofu apply
```

#### Required Secrets (`infra/global/terraform.tfvars`)

| Variable                | Description                                                                         |
| ----------------------- | ----------------------------------------------------------------------------------- |
| `cloudflare_api_token`  | Cloudflare API token (DNS, Email Routing, R2, API tokens, Notifications)            |
| `cloudflare_account_id` | Cloudflare account ID                                                               |
| `cloudflare_zone_id`    | Cloudflare Zone ID                                                                  |
| `domain`                | Root domain name                                                                    |
| `do_token`              | DigitalOcean API token                                                              |

### OpenAI provider

`infra/services/openai` uses the [official OpenAI provider](https://github.com/openai/terraform-provider-openai), bundled in the Nix dev shell. 162 existing resources, including the Default project, four Secure/MCP tunnels, memberships, settings, and 153 model rate limits, are imported. See [import coverage and exclusions](docs/openai-import.md). State is encrypted in R2 at `openai/terraform.tfstate`. Export the [backend credentials](docs/service-state.md) before running OpenTofu.

HCP Terraform setup is not required for this module. Dedicated Home Assistant and Grafana tunnels are also declared; see [Home Assistant MCP](docs/home-assistant-mcp.md) and [Grafana MCP](docs/grafana-mcp.md) for rollout.

For organization administration, provide an [Admin API key](https://platform.openai.com/settings/organization/admin-keys) through `OPENAI_ADMIN_KEY` in the local shell for both plan and apply. Do not put it in `.tfvars` or committed configuration. A regular project API key is not a substitute. The separate `OPENAI_API_KEY` credential is needed only if managing project webhooks.

```bash
# Inject OPENAI_ADMIN_KEY through your secret manager before managing resources.
tofu -chdir=infra/services/openai init
tofu -chdir=infra/services/openai plan
```

### Supabase provider

`infra/services/supabase` uses the official Supabase provider bundled in the Nix
dev shell. Three paused projects and the retained freeschool-search settings are managed in
encrypted R2 state at `supabase/terraform.tfstate`. Settings for two projects could not be imported while paused;
freeschool-search settings were imported before pausing. Settings refresh may
fail while projects are paused.
Use `SUPABASE_ACCESS_TOKEN` for authentication and export the [backend credentials](docs/service-state.md).
See [import coverage and limitations](docs/supabase-import.md).

```bash
tofu -chdir=infra/services/supabase init
tofu -chdir=infra/services/supabase plan
```

## Policy Checks

Conftest evaluates saved OpenTofu plan JSON against the policies in `policy/terraform`.

```bash
tofu -chdir=infra/services/github/repositories/dotnix plan -out=tfplan
tofu -chdir=infra/services/github/repositories/dotnix show -json tfplan | conftest test --policy policy/terraform -

# Run policy unit tests
conftest verify --policy policy/terraform

# Lint Rego policies
regal lint policy/terraform
```

## Directory Structure

```
infra/                              # OpenTofu configuration
├── global/                         # Root module (providers, backend, variables, outputs)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── domains/
│       ├── yutakobayashi-com/      # DNS records and Email Routing rules
│       │   ├── main.tf
│       │   ├── email.tf
│       │   └── variables.tf
│       └── yutakobayashi-dev/      # DNS records and Email Routing rules
│           ├── main.tf
│           └── variables.tf
├── services/                       # Service resources + workspaces
│   ├── main.tf                     # R2 buckets, tokens
│   ├── variables.tf / outputs.tf
│   ├── tfe/                        # HCP Terraform self-management
│   │   ├── main.tf
│   │   ├── organization.tf
│   │   ├── projects.tf
│   │   └── workspaces.tf
│   ├── github/
│   │   └── repositories/<name>/    # One root per GitHub repository
│   └── openai/                     # OpenAI provider workspace
│       ├── main.tf
│       ├── projects.tf
│       ├── members.tf
│       ├── project_settings.tf
│       ├── rate_limits.tf
│       └── tunnels.tf
├── modules/
│   ├── cloudflare-r2/              # R2 bucket + custom domain
│   └── cloudflare-account-token/   # R2 API token
policy/
└── terraform/                       # Conftest policies and unit tests
scripts/
└── new-github-repository           # Root for a new GitHub repository
```

## Managed Resources

| Provider      | Resource         | Details                                                                                                                                                                                                                                             |
| ------------- | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Cloudflare    | DNS records      | fedi.yutakobayashi.com (A), git.yutakobayashi.com (CNAME), git-ssh.yutakobayashi.com (CNAME), niks3.yutakobayashi.com (CNAME), nostr.yutakobayashi.com (CNAME), tag.yutakobayashi.com (CNAME), SES MAIL FROM (MX + TXT), Resend DKIM (TXT), Bluesky DID (TXT) |
| Cloudflare    | DNS records      | yutakobayashi.dev web endpoints, service verification records, and CAA                                                                                                                                                                              |
| Cloudflare    | Response headers | Gitea `X-Robots-Tag: noindex`; see [configuration and verification](docs/gitea-noindex.md) |
| Cloudflare    | Email Routing    | hi@yutakobayashi.com and hi@yutakobayashi.dev to Worker core, disabled catch-all rules                                                                                                                                                              |
| Cloudflare    | Email Sending    | Sending subdomains fedi.yutakobayashi.com (Mastodon) and git.yutakobayashi.com (Gitea), and an SMTP token for each |
| Cloudflare    | R2 buckets       | fediverse (Mastodon media), obsidian (backup), nix-cache-niks3 (Nix cache), homelab-infra-state (infra state)                                                                                                                                       |
| Cloudflare    | R2 tokens        | mastodon-r2, obsidian-r2, nix-cache, homelab-infra-state-r2                                                                                                                                                                                         |
| Cloudflare    | R2 custom domain | fedi-files.yutakobayashi.com                                                                                                                                                                                                                        |
| Cloudflare    | Notifications    | Access service token expiration, passive origin monitoring, Web Analytics metrics, Tunnel Health for B450M-Pro4, R2 usage alerts, Discord status webhook delivery, API-managed budget alerts (`docs/cloudflare-budget-alerts.md`)                    |
| HCP Terraform | Organization     | yutakobayashi (2FA mandatory)                                                                                                                                                                                                                       |
| HCP Terraform | Workspaces       | tfe, homelab, discord                                                                                                                                                                                                                               |
| GitHub        | Repositories     | 11 active repositories, one root each in `infra/services/github/repositories/`; see [GitHub management](docs/github-management.md)                                                                                                                  |

## Future

- Mastodon migration from Vultr to DigitalOcean
