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

AWS
└── SES (Mastodon email delivery)

DigitalOcean (future)
├── Droplet (Mastodon)
└── Spaces (backups)

HCP Terraform
├── tfe workspace (HCP Terraform self-management)
├── homelab workspace (infrastructure state)
└── github workspace (GitHub repository settings)
```

## Prerequisites

- [Nix](https://nixos.org/) (recommended) or install manually:
  - [OpenTofu](https://opentofu.org/) >= 1.6
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

### 2. HCP Terraform

State is managed by [HCP Terraform](https://app.terraform.io/). OpenTofu runs locally against HCP-managed state because HCP remote execution does not run OpenTofu. Authenticate once:

```bash
tofu login app.terraform.io
```

The workspaces managed from `infra/services/tfe` are VCS-connected to this repository through the Terraform Cloud GitHub App and use local execution mode.

### 3. OpenTofu

Three independent workspaces:

| Directory                | Workspace | Manages                                |
| ------------------------ | --------- | -------------------------------------- |
| `infra/global/`          | homelab   | Cloudflare DNS/R2, AWS SES, DO         |
| `infra/services/tfe/`    | tfe       | HCP Terraform organization, workspaces |
| `infra/services/github/` | github    | GitHub repository settings             |

```bash
cd infra/global  # or infra/services/tfe, infra/services/github

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
| `aws_access_key`        | AWS access key (for SES)                                                            |
| `aws_secret_key`        | AWS secret key                                                                      |
| `aws_region`            | AWS region (ap-northeast-1)                                                         |
| `domain`                | Root domain name                                                                    |
| `do_token`              | DigitalOcean API token                                                              |

#### Required Secrets (`infra/services/github/terraform.tfvars`)

| Variable       | Description                  |
| -------------- | ---------------------------- |
| `github_token` | GitHub Personal Access Token |

## Policy Checks

Conftest evaluates saved OpenTofu plan JSON against the policies in `policy/terraform`.

```bash
tofu -chdir=infra/services/github plan -out=tfplan
tofu -chdir=infra/services/github show -json tfplan | conftest test --policy policy/terraform -

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
│   ├── main.tf                     # R2 buckets, tokens, SES
│   ├── ses.tf
│   ├── variables.tf / outputs.tf
│   ├── tfe/                        # HCP Terraform self-management
│   │   ├── main.tf
│   │   ├── organization.tf
│   │   ├── projects.tf
│   │   └── workspaces.tf
│   └── github/                     # GitHub repository management
│       ├── main.tf
│       ├── variables.tf
│       └── repositories.tf
├── modules/
│   ├── cloudflare-r2/              # R2 bucket + custom domain
│   └── cloudflare-account-token/   # R2 API token
policy/
└── terraform/                       # Conftest policies and unit tests
```

## Managed Resources

| Provider      | Resource         | Details                                                                                                                                                                                                                                             |
| ------------- | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Cloudflare    | DNS records      | fedi.yutakobayashi.com (A), git.yutakobayashi.com (CNAME), git-ssh.yutakobayashi.com (CNAME), niks3.yutakobayashi.com (CNAME), nostr.yutakobayashi.com (CNAME), tag.yutakobayashi.com (CNAME), SES DKIM (CNAME x3), SES MAIL FROM (MX + TXT), Resend DKIM (TXT), Bluesky DID (TXT) |
| Cloudflare    | DNS records      | yutakobayashi.dev web endpoints, service verification records, and CAA                                                                                                                                                                              |
| Cloudflare    | Email Routing    | hi@yutakobayashi.com and hi@yutakobayashi.dev to Worker core, disabled catch-all rules                                                                                                                                                              |
| Cloudflare    | R2 buckets       | fediverse (Mastodon media), obsidian (backup), nix-cache-niks3 (Nix cache), homelab-infra-state (infra state)                                                                                                                                       |
| Cloudflare    | R2 tokens        | mastodon-r2, obsidian-r2, nix-cache, homelab-infra-state-r2                                                                                                                                                                                         |
| Cloudflare    | R2 custom domain | fedi-files.yutakobayashi.com                                                                                                                                                                                                                        |
| Cloudflare    | Notifications    | Access service token expiration, passive origin monitoring, Web Analytics metrics, Tunnel Health for B450M-Pro4, R2 usage alerts, Discord status webhook delivery, API-managed budget alerts (`docs/cloudflare-budget-alerts.md`)                    |
| AWS           | SES              | fedi.yutakobayashi.com (domain identity + DKIM)                                                                                                                                                                                                     |
| HCP Terraform | Organization     | yutakobayashi (2FA mandatory)                                                                                                                                                                                                                       |
| HCP Terraform | Workspaces       | tfe, homelab, github                                                                                                                                                                                                                                |
| GitHub        | Repositories     | tofu-configuration, dotnix, repiq, ava                                                                                                                                                                                                              |

## Future

- Mastodon migration from Vultr to DigitalOcean
