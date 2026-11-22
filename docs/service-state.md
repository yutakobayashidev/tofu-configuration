# OpenAI and Supabase state

OpenAI and Supabase use the existing `homelab-infra-state` R2 bucket.
Their keys are `openai/terraform.tfstate` and `supabase/terraform.tfstate`.
Both roots require OpenTofu 1.10 or later, use S3 lock files, and enforce
AES-GCM encryption for state and saved plans.

## Credentials

Export backend credentials before running init, plan, apply, or state commands.

```bash
export AWS_ACCESS_KEY_ID="$(tofu -chdir=infra/global output -raw homelab_infra_state_access_key_id)"
export AWS_SECRET_ACCESS_KEY="$(tofu -chdir=infra/global output -raw homelab_infra_state_secret_access_key)"
export AWS_ENDPOINT_URL_S3="https://<cloudflare_account_id>.r2.cloudflarestorage.com"
export TF_VAR_state_encryption_passphrase="$(cat ~/.config/tofu-configuration/state-passphrase)"
```

These roots use the existing tofu-configuration passphrase also used by the
GitHub repository roots. Keep its password-manager backup. Credentials belong
in the environment. The R2 credentials above are available through the HCP
`homelab` workspace.

For resource refresh and changes, also provide `OPENAI_ADMIN_KEY` or
`SUPABASE_ACCESS_TOKEN`, respectively.

```bash
tofu -chdir=infra/services/openai init
tofu -chdir=infra/services/openai plan

tofu -chdir=infra/services/supabase init
tofu -chdir=infra/services/supabase plan
```

## Migration on 2026-11-22

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
