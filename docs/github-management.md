# GitHub management

Each repository has its own OpenTofu root in
`infra/services/github/repositories/<name>/`. The root calls
[`zunoser/tfmodule-gh-repo-kit`](https://github.com/zunoser/tfmodule-gh-repo-kit)
and keeps its state in its own object in the `yuta-gh-signer-github-tfstate`
Google Cloud Storage bucket. A plan or apply therefore touches only one
repository.

| File | Contents |
| --- | --- |
| `backend.tf` | GCS backend with the prefix `repositories/<name>`, state and plan encryption with Cloud KMS |
| `provider.tf` | GitHub provider for `yutakobayashidev` |
| `versions.tf` | OpenTofu and provider constraints |
| `module_gh_repo_kit.tf` | Repository settings |
| `labels.tf` | Issue labels (`dotnix` only) |

The module is pinned to the head commit of zunoser/tfmodule-gh-repo-kit#4. When
that pull request is merged and tagged `v0.2.0`, switch every root to the tag:
the pinned commit lives on the pull request branch, which can be deleted after
the merge.

## Credentials

The GitHub roots use neither the R2 credentials nor the state passphrase.
State access and encryption use Google Cloud credentials from
`gcloud auth application-default login`, so CI reaches them through Workload
Identity Federation without a static secret. See
[GitHub App signing](gcp-github-app-signing.md#github-repository-state).
Provide the GitHub provider token through the environment.

```bash
export GITHUB_TOKEN="$(gh auth token)"

tofu -chdir=infra/services/github/repositories/<name> init
tofu -chdir=infra/services/github/repositories/<name> plan
```

## CI

Pull requests that change a root are planned by GitHub Actions, and merges to
`main` are applied, without a static credential in GitHub. See
[GitHub App signing](gcp-github-app-signing.md#ci-workflows). During the
rollout, only the roots listed in `ENABLED_ROOTS` run in CI.

## Current settings

The 11 active repositories were imported on 2026-11-22. Each root sets
`auto_init = false` and writes every setting that differs from the module
defaults as an override. The import therefore changed nothing on GitHub: after
the apply, every repository still matched the settings recorded before the
migration.

`default_branch_ruleset = null` leaves the default branches unprotected, as they
were. Move each repository toward the module defaults, including a ruleset, in
separate reviewed changes.

`tofu-configuration` itself requires pull requests for `main`, with no required
approval because the sole owner cannot approve their own pull requests. The
ruleset has no bypass actors, so direct pushes to `main` are rejected for
everyone. It prepares for CI that applies only commits merged to `main`.

Archived repositories (`grafanaconf`, `daily-report`) are not managed: the
GitHub provider cannot read vulnerability alerts on an archived repository.

The previous root `infra/services/github/` and its HCP Terraform workspace
`github` were retired after the import. `removed` blocks forgot their resources
without changing GitHub, and the workspace was deleted.

## Adding a repository

```bash
nix develop -c scripts/new-github-repository <name> "<description>" public
```

The script copies the module source and the provider lock from the
`tofu-configuration` root and writes a root that uses the module defaults, so
GitHub creates the repository with an initial commit (`auto_init`). The root
also sets `default_branch_ruleset = null`: the standard ruleset requires an
approving review, which a sole maintainer cannot give. Run `init` and `plan`,
apply after review, and commit the root.

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
