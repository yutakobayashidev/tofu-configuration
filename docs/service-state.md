# R2 state

The OpenTofu roots use encrypted state in the `homelab-infra-state` R2
bucket. They require OpenTofu 1.10 or later, use S3 lock files, and enforce
AES-GCM encryption for state and saved plans.

| Root | State key |
| --- | --- |
| `infra/global` | `homelab/terraform.tfstate` |
| `infra/services/discord/yuta-studio` | `discord/terraform.tfstate` |
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


## HCP Terraform retirement

The `discord`, `homelab`, and `tfe` HCP workspaces were copied to R2 on
2026-11-22 (serials 641, 106, and 10; 233, 96, and 7 managed instances) and
locked. On 2026-11-24 the `tfe` root destroyed the `discord` and `homelab`
workspaces and the Discord token variable, then was removed from this
repository. The HCP organization is deleted by hand.

The Discord root reads its bot token from `DISCORD_TOKEN`. The token is stored
in 1Password as "Discord bot token (yuta-studio)" in the Personal vault:

```bash
export DISCORD_TOKEN="$(op item get "Discord bot token (yuta-studio)" --vault Personal --fields credential --reveal)"
```
