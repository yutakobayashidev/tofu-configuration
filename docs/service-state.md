# OpenTofu state

Every root keeps its state in Google Cloud Storage in the `yuta-gh-signer`
project, encrypted with Cloud KMS through the OpenTofu `gcp_kms` key provider.
Both buckets use Object Versioning (20 noncurrent versions), so an overwritten
or deleted state can be restored. Both enforce public access prevention and
uniform bucket-level access. `infra/services/gcp` manages the buckets and keys.

| Roots | Bucket | KMS key | Access |
| --- | --- | --- | --- |
| `infra/global` (`homelab`), Discord (`discord`), OpenAI (`openai`), Supabase (`supabase`), `infra/services/gcp` (`gcp`) | `yuta-gh-signer-tfstate`, prefix in parentheses | `tofu-state/services` | Project owner only |
| `infra/services/github/repositories/<name>` | `yuta-gh-signer-github-tfstate`, prefix `repositories/<name>` | `tofu-state/github-repositories` | Owner, and the CI service accounts through WIF; see [GitHub App signing](gcp-github-app-signing.md#github-repository-state) |

The gcp root stores its state in a bucket it manages, as Google's bootstrap
module does. `force_destroy = false` on the buckets, `prevent_destroy` on the
keys, and `deletion_policy = "PREVENT"` on the project keep an apply from
removing what holds that state.

To restore an earlier version, list it with
`gcloud storage ls --all-versions gs://<bucket>/<prefix>/` and copy the chosen
generation over `default.tfstate`.

## Credentials

State access needs only Google Cloud credentials:

```bash
gcloud auth application-default login
```

Provider credentials live in 1Password (Personal vault). `op.env` at the
repository root lists their references, never their values. Run OpenTofu
through `op run`:

```bash
op run --env-file=op.env -- tofu -chdir=infra/global plan
```

| 1Password item | Provides |
| --- | --- |
| `tofu-configuration-global` | `infra/global` variables (Cloudflare) |
| Discord bot token (yuta-studio) | `DISCORD_TOKEN` for the Discord root |
| `tofu-configuration-gcp` | `TF_VAR_billing_account` for the gcp root |
| `tofu-configuration-openai` | `OPENAI_ADMIN_KEY` for the OpenAI root |

For Supabase resource refresh and changes, also provide `SUPABASE_ACCESS_TOKEN`.

## History

- 2026-11-22: OpenAI and Supabase moved from local files to R2. The MacBook
  copies were the source (OpenAI serial 4 with 164 instances, Supabase serial
  7 with 4). The originals remain as Git-ignored `terraform.tfstate.pre-r2`
  files beside each root.
- 2026-11-22: the `discord`, `homelab`, and `tfe` HCP Terraform workspaces
  moved to R2 (serials 641, 106, and 10).
- 2026-11-23: the GitHub repository roots moved to GCS so that CI reaches
  their state without a static credential.
- 2026-11-24: HCP Terraform was retired. The `tfe` root destroyed the
  `discord` and `homelab` workspaces and was removed; the organization was
  deleted by hand.
- 2026-11-24: the remaining roots moved from R2 to GCS because R2 has no object
  versioning. Each state was read back and compared on resources and outputs,
  and every root planned with no changes. The `homelab-infra-state` R2 bucket
  now holds only dotnix's states. The R2 copies were deleted the same day, and
  the R2 key and passphrase items were archived in 1Password.
