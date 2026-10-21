# Supabase import

The independent root module `infra/services/supabase` uses the official
`supabase/supabase` provider pinned to 1.11.0. Its state is local and Git-ignored:
`infra/services/supabase/terraform.tfstate`. Preserve and back up this state;
HCP Terraform is not a prerequisite. Authenticate using `SUPABASE_ACCESS_TOKEN`,
never a committed token or a project API key.

```bash
nix develop
# Inject SUPABASE_ACCESS_TOKEN from your secret manager.
tofu -chdir=infra/services/supabase init
tofu -chdir=infra/services/supabase plan
```

## Imported resources

Inventory on 2026-10-22 covered all four organizations visible to the supplied
account, with one project in each. Six resources were imported without applying
remote changes:

| Organization / project | Project reference | Project | Settings |
| --- | --- | --- | --- |
| freeschool-search | xtzdsetdxjfwdavnqkrn | Imported | Imported |
| stable-share / Stable share | zlibyqetcfwykzlwazfy | Imported, paused | Blocked |
| capitalens / CapitaLens | vqgsgsbkyptkcifzdjpy | Imported, paused | Blocked |
| work / ticket-dev | qssjixzajmkpxsouqtaz | Imported | Imported |

The settings resources capture API, readable Auth, database, network, Storage
configuration and SSL enforcement. JSON files under `settings/` contain the
imported settings, normalized with `jsonencode` in HCL. Storage snapshots also
retain API-returned metadata (`capabilities`, `databasePoolMode`,
`migrationVersion`) to preserve an unchanged initial plan; these fields are
read-only and are not configuration knobs.

The database passwords are unknown. Each project has `ignore_changes` for
`database_password` and `prevent_destroy`. The placeholder is only for importing
existing projects: it must never be used to create a new project. Always restore
the existing state or import the existing project before applying this module.
The placeholders do not recover or rotate passwords.

## Remaining coverage and limitations

- Both paused projects fail settings import because the SSL enforcement API
  returns HTTP 500 (`fetch failed`). Their project resources are tracked, but
  their settings are not. Neither project was resumed. After an authorized
  resume, import their settings and capture the actual configuration before
  applying anything; do not add empty settings resources and apply them.
- All four projects returned zero branches, Edge Functions, and third-party
  authentication integrations.
- The two active projects each expose only legacy `anon` and `service_role`
  keys. The v1.11.0 API key resource expects UUID-backed keys; its read path
  cannot import these legacy IDs. They remain outside resource management;
  the project resource tracks whether legacy keys are enabled. Paused projects
  returned no API keys, which is not proof that no keys exist while active.
- Three secrets returned for freeschool-search all have the reserved
  `SUPABASE_` prefix. The provider excludes these. All other projects returned
  no secrets. No user-managed Edge Function secrets were found.
- Auth secret fields (for example the enabled Google provider's client secret)
  cannot be retrieved as plaintext and are not included. Existing values remain
  unchanged; subsequent secret management requires the original values.
- Organization membership/billing, SQL schemas, RLS, DB functions, Auth users,
  Storage buckets and stored data are not imported by this official provider.
  Manage database schemas with SQL migrations. This state is not a data backup.
- API responses from paused projects may be incomplete. Repeat the inventory
  after resuming them before declaring coverage complete.

## References

- [Official tutorial](https://supabase.com/docs/guides/deployment/terraform/tutorial)
- [Provider resources](https://supabase.com/docs/guides/deployment/terraform/reference)
- [v1.11.0 source](https://github.com/supabase/terraform-provider-supabase/tree/v1.11.0)

## Verification

- OpenTofu 1.12.1: `fmt -check`, `validate`, and refreshed `plan` (exit 0,
  six resources with `no-op`; no additions, changes or deletions).
- Nix build of the provider and wrapped OpenTofu succeeded. A fresh directory
  initializes with the committed lock file in read-only mode. The lock records
  both upstream release checksums and the local Nix-built Linux package hash.
- State and its backup are Git-ignored and have owner-only permissions.
- No remote apply, password rotation, key creation or project resume was run.
