# tofu-configuration

OpenTofu configurations for managing homelab infrastructure.

## Architecture

```
Cloudflare
├── DNS (yutakobayashi.com)
├── R2 (Mastodon media / Obsidian backup)
└── API Tokens

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

## Setup

### 1. Development Environment

```bash
# Install all dev tools via Nix flake
nix develop

# MCP servers and agent skills are auto-configured via shellHook
```

### 2. HCP Terraform

State is managed by [HCP Terraform](https://app.terraform.io/). Authenticate once:

```bash
tofu login app.terraform.io
```

### 3. OpenTofu

Three independent workspaces:

| Directory | Workspace | Manages |
|-----------|-----------|---------|
| `infra/` | homelab | Cloudflare DNS/R2, AWS SES, DO |
| `infra/tfe/` | tfe | HCP Terraform organization, workspaces |
| `infra/github/` | github | GitHub repository settings |

```bash
cd infra  # or infra/tfe, infra/github

# Create and edit variables file
cp terraform.tfvars.example terraform.tfvars

# Init, plan, apply
tofu init
tofu plan
tofu apply
```

#### Required Secrets (`infra/terraform.tfvars`)

| Variable | Description |
|----------|-------------|
| `cloudflare_api_token` | Cloudflare API token (Zone:DNS:Edit, Zone:Zone:Read) |
| `cloudflare_account_id` | Cloudflare account ID |
| `cloudflare_zone_id` | Cloudflare Zone ID |
| `aws_access_key` | AWS access key (for SES) |
| `aws_secret_key` | AWS secret key |
| `aws_region` | AWS region (ap-northeast-1) |
| `domain` | Root domain name |
| `do_token` | DigitalOcean API token |

#### Required Secrets (`infra/github/terraform.tfvars`)

| Variable | Description |
|----------|-------------|
| `github_token` | GitHub Personal Access Token |

## Directory Structure

```
infra/                              # OpenTofu - infrastructure
├── main.tf                        # providers, R2 buckets, tokens
├── dns.tf                         # Cloudflare DNS records
├── ses.tf                         # AWS SES (email)
├── variables.tf / outputs.tf
├── .tflint.hcl
├── modules/
│   ├── cloudflare-r2/             # R2 bucket + custom domain
│   └── cloudflare-account-token/  # R2 API token
├── tfe/                           # HCP Terraform self-management
│   ├── main.tf                    # tfe provider
│   ├── organization.tf            # org settings (2FA mandatory)
│   ├── projects.tf
│   └── workspaces.tf              # homelab, github workspaces
└── github/                        # GitHub repository management
    ├── main.tf                    # github provider
    ├── variables.tf
    └── repositories.tf            # repo settings, topics
```

## Managed Resources

| Provider | Resource | Details |
|----------|----------|---------|
| Cloudflare | DNS records | fedi.yutakobayashi.com (A), SES DKIM (CNAME x3) |
| Cloudflare | R2 buckets | fediverse (Mastodon media), obsidian (backup) |
| Cloudflare | R2 tokens | mastodon-r2, obsidian-r2 |
| Cloudflare | R2 custom domain | fedi-files.yutakobayashi.com |
| AWS | SES | fedi.yutakobayashi.com (domain identity + DKIM) |
| HCP Terraform | Organization | yutakobayashi (2FA mandatory) |
| HCP Terraform | Workspaces | tfe, homelab, github |
| GitHub | Repositories | tofu-configuration, dotnix, repiq, ava |

## Future

- Mastodon migration from Vultr to DigitalOcean
