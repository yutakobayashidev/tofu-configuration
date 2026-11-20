# GitHub management

Each repository has its own OpenTofu root in
`infra/services/github/repositories/<name>/`. The root calls
[`zunoser/tfmodule-gh-repo-kit`](https://github.com/zunoser/tfmodule-gh-repo-kit),
pinned to a release tag, and keeps its state in its own object in the
`homelab-infra-state` R2 bucket. A plan or apply therefore touches only one
repository.

| File | Contents |
| --- | --- |
| `backend.tf` | R2 backend with the key `github/repositories/<name>/terraform.tfstate`, state and plan encryption |
| `provider.tf` | GitHub provider for `yutakobayashidev` |
| `versions.tf` | OpenTofu and provider constraints |
| `module_gh_repo_kit.tf` | Repository settings |
| `imports.tf` | Import blocks for an existing repository; delete them after the first apply |
| `labels.tf` | Issue labels (`dotnix` only) |

The legacy root `infra/services/github/` and its HCP Terraform workspace
`github` still hold the previous state. That configuration no longer matches
GitHub; do not apply it. [Migration](#migration) retires it.

## Credentials

Provide every credential through the environment. Never commit one or pass it
with `-backend-config`.

```bash
export GITHUB_TOKEN="$(gh auth token)"
export AWS_ACCESS_KEY_ID="$(tofu -chdir=infra/global output -raw homelab_infra_state_access_key_id)"
export AWS_SECRET_ACCESS_KEY="$(tofu -chdir=infra/global output -raw homelab_infra_state_secret_access_key)"
export AWS_ENDPOINT_URL_S3="https://<cloudflare_account_id>.r2.cloudflarestorage.com"
export TF_VAR_state_encryption_passphrase="..." # from your secret manager

tofu -chdir=infra/services/github/repositories/<name> init
tofu -chdir=infra/services/github/repositories/<name> plan
```

The passphrase encrypts state and saved plans. Without it the state cannot be
read, so store it outside this repository before the first apply.

## Imported repositories

The roots import the 11 active repositories with declarative `import` blocks.
Each root sets `auto_init = false` and writes every setting that differs from
the module defaults as an override, so the first plan matches GitHub. A
read-only plan (`init -backend=false`) of every root on 2026-11-21 showed the
imports and one in-place update of `github_repository`. The update sets only
the state-only attributes `archive_on_destroy` and
`ignore_vulnerability_alerts_during_read`.

`default_branch_ruleset = null` leaves the default branches unprotected, as they
are today. Move each repository toward the module defaults, including a
ruleset, in separate reviewed changes.

Archived repositories (`grafanaconf`, `daily-report`) are not managed: the
GitHub provider cannot read vulnerability alerts on an archived repository.

## Migration

1. Export the credentials. Run `init` and `plan` for the `tofu-configuration`
   root, confirm that the plan matches the read-only result above, and apply it.
2. Repeat for the other roots. Stop if a plan changes a GitHub setting.
3. Delete every `imports.tf`.
4. In the legacy root, replace each resource with a `removed` block for the same
   address. The plan must only forget resources, including the archived
   repositories; GitHub does not change.

   ```hcl
   removed {
     from = github_repository.dotnix

     lifecycle {
       destroy = false
     }
   }
   ```

5. Delete the legacy root and `tfe_workspace.github` in `infra/services/tfe`.

## Adding a repository

```bash
nix develop -c scripts/new-github-repository <name> "<description>" public
```

The script copies the module source and the provider lock from the
`tofu-configuration` root and writes a root that uses the module defaults, so
GitHub creates the repository with an initial commit (`auto_init`). The root
also sets
`default_branch_ruleset = null`: the standard ruleset requires an approving
review, which a sole maintainer cannot give. Run `init` and `plan`, apply after
review, and commit the root.

## Archiving a repository

The module sets `archive_on_destroy`, so `tofu destroy` archives the repository
instead of deleting it. The provider reads this flag from state, not from the
configuration. Before destroying, confirm that
`tofu state show module.repository.github_repository.this` shows
`archive_on_destroy = true`; otherwise the destroy deletes the repository.

After the destroy, delete the root and its state object.

## Updating the module

Change `?ref=` in every `module_gh_repo_kit.tf`, then plan every root. New roots
follow the `tofu-configuration` root.
