# R2 state

The OpenTofu roots use encrypted state in the `homelab-infra-state` R2
bucket. They require OpenTofu 1.10 or later, use S3 lock files, and enforce
AES-GCM encryption for state and saved plans.

| Root | State key |
| --- | --- |
| `infra/global` | `homelab/terraform.tfstate` |
| `infra/services/discord/yuta-studio` | `discord/terraform.tfstate` |
| `infra/services/tfe` | `tfe/terraform.tfstate` |
| `infra/services/openai` | `openai/terraform.tfstate` |
| `infra/services/supabase` | `supabase/terraform.tfstate` |
| `infra/services/gcp` | `gcp/terraform.tfstate` |

The GitHub repository roots moved to Google Cloud Storage on 2026-11-23 so that
CI can reach their state without a static credential. See
[GitHub App signing](gcp-github-app-signing.md#github-repository-state). Their
earlier objects under `github/repositories/` in this bucket remain as a rollback
copy, encrypted with the shared passphrase, and are no longer updated.

## Credentials

Load the R2 credentials and encryption passphrase before running OpenTofu.

```bash
source ~/.config/tofu-configuration/r2.env
export TF_VAR_state_encryption_passphrase="$(cat ~/.config/tofu-configuration/state-passphrase)"
```

On a new machine, restore the R2 S3 access key, secret access key, and account
endpoint from your secret store. Export them as `AWS_ACCESS_KEY_ID`,
`AWS_SECRET_ACCESS_KEY`, and `AWS_ENDPOINT_URL_S3`, or save the three exports
in `r2.env` with mode 600. The endpoint has the form
`https://<cloudflare_account_id>.r2.cloudflarestorage.com`. Keep these
credentials outside OpenTofu so `infra/global` can open its own state.
Restore the existing state passphrase from its password-manager backup.

For resource refresh and changes, also provide `OPENAI_ADMIN_KEY` or
`SUPABASE_ACCESS_TOKEN`, respectively.

```bash
tofu -chdir=infra/services/openai init
tofu -chdir=infra/services/openai plan

tofu -chdir=infra/services/supabase init
tofu -chdir=infra/services/supabase plan
```

## OpenAI and Supabase migration on 2026-11-22

The MacBook copies were used as the source following the owner's confirmation
that there had been no subsequent operations. The original OpenAI state had
164 managed instances at serial 4, and Supabase had 4 at serial 7.

Original files are retained as `terraform.tfstate.pre-r2` beside each root,
with mode 600 and excluded from Git. Earlier `terraform.tfstate.backup` files
are also retained. New operations use R2. Restoring an old local copy requires
checking the current remote state first.

State transfer was checked by comparing all resources and outputs after
reading back from R2 and by inspecting the downloaded object's encryption
envelope. New remote state metadata can have a different lineage and serial.

Both roots passed configuration validation and formatting checks. Resource
plans remain unverified because this session had neither `OPENAI_ADMIN_KEY`
nor `SUPABASE_ACCESS_TOKEN`. Even `plan -refresh=false` requires provider
credentials. Supabase settings refresh may also fail while projects are paused.


## HCP state cutover

The `discord`, `homelab`, and `tfe` HCP state snapshots were copied to R2.
`homelab` reads the encrypted Discord state to obtain the notification webhook.
The `tfe` root still uses the HCP API to manage the organization and workspaces.

| HCP workspace | Source serial | Managed instances |
| --- | ---: | ---: |
| `discord` | 641 | 233 |
| `homelab` | 106 | 96 |
| `tfe` | 10 | 7 |

Freeze writes to the old workspaces before switching shared operations to R2.
Confirm that the HCP snapshots have not advanced since the copy, then lock the
old workspaces to prevent writes from checkouts that still use the old backend.
Retain the HCP workspaces and snapshot history for rollback.

With the R2 credentials loaded, switch each existing checkout to the new
backend using `init -reconfigure`.

```bash
tofu -chdir=infra/services/discord/yuta-studio init -reconfigure
tofu -chdir=infra/global init -reconfigure
tofu -chdir=infra/services/tfe init -reconfigure
```

Use the Discord provider credentials for the Discord root and HCP provider
credentials for the tfe root. Review each plan before applying any change.
