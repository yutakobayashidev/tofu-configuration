# GitHub App signing

CI for the GitHub repository roots will authenticate as GitHub Apps without a
private key in GitHub Secrets, following
[10X's approach](https://product.10x.co.jp/entry/2026/04/01/163814). Cloud KMS
holds the App private keys and signs App JWTs. GitHub Actions reaches KMS only
through Workload Identity Federation (WIF), and the job exchanges the signed JWT
for an installation token limited to the repository it manages.

`infra/services/gcp` manages the Google Cloud side, including the state buckets
and keys for every root; see [OpenTofu state](service-state.md).

## Resources

| Resource | Name | Purpose |
| --- | --- | --- |
| Project | `yuta-gh-signer` | No organization parent. Billing account from `TF_VAR_billing_account` (`op.env`) |
| KMS key ring | `github-apps` (`asia-northeast1`) | Holds the App keys |
| KMS keys | `tofu-plan`, `tofu-apply` | Import-only RSA 2048 signing keys, one per GitHub App |
| WIF pool and provider | `github-actions` / `tofu-configuration` | Accepts GitHub Actions OIDC tokens |
| Service accounts | `github-app-plan`, `github-app-apply` | Each may sign with its own key only |

The WIF provider accepts a token only when all of the following hold. Owner and
repository are matched by numeric ID, which a rename cannot reassign.

| Stage | GitHub Environment | Workflow | Ref |
| --- | --- | --- | --- |
| plan | `github-plan` | `.github/workflows/github-plan.yml` | any |
| apply | `github-apply` | `.github/workflows/github-apply.yml` | `refs/heads/main` |

Each service account trusts only its Environment, so a plan job cannot sign
with the apply key. The `workflow_ref` claim contains the repository name:
after renaming the repository, update `github_repository` in `main.tf`, or
every token is rejected.

## GitHub repository state

The GitHub repository roots keep their state in the
`yuta-gh-signer-github-tfstate` bucket under `repositories/<name>`. The bucket
has Object Versioning, keeps the 20 most recent noncurrent versions, enforces
public access prevention, and uses uniform bucket-level access. The OpenTofu
`gcp_kms` key provider encrypts state and saved plans with the
`tofu-state/github-repositories` key, which rotates every 90 days.

| Service account | Bucket | KMS key |
| --- | --- | --- |
| `github-app-plan` | Read only. The plan workflow runs with `-lock=false` | Encrypt and decrypt, for saved plan files |
| `github-app-apply` | Read and write | Encrypt and decrypt |

The other roots run only locally, so their state is in a separate bucket that
the CI service accounts cannot reach.

## CI workflows

`.github/workflows/github-plan.yml` plans the changed roots on pull requests,
and `.github/workflows/github-apply.yml` applies them after a merge to `main`.
github-plan also runs on `workflow_dispatch`, against the changes of the
dispatched branch, so that `.github/workflows/github-new-repository.yml` can
plan the pull request it opens.
Each matrix job reads the repository name from the root, then:

1. authenticates to Google Cloud with `google-github-actions/auth` through WIF,
2. signs an App JWT with KMS and exchanges it for an installation token
   limited to that one repository with `yagihash/ghat`, which revokes the token
   when the job ends,
3. runs OpenTofu from the `github-ci` Nix shell. The lock files record the
   nixpkgs provider build, so CI uses the same build.

| Stage | GitHub App | App ID | Token permissions |
| --- | --- | --- | --- |
| plan | `yuta-tofu-plan` | 5875937 | Metadata, Administration, Issues, Actions, Webhooks: read |
| apply | `yuta-tofu-apply` | 5875943 | Administration, Issues and Webhooks: write; Metadata and Actions: read (the drift check requests Webhooks: read). A new root's token keeps all App permissions, including Repository creation: write |

Actions read is needed to read the GitHub Environments managed by the
`tofu-configuration` root.

The plan App stays read-only. Unlike 10X, this public personal repository
cannot use push rulesets to stop a pull request from editing the workflows, so
code from a pull request branch, including one opened by an AI agent, could
use any token the plan job receives.

A read-only token cannot refresh the repository merge settings through REST.
The GitHub REST documentation says that viewing them requires `contents:read`
and `contents:write`, and the provider documentation repeats the
`contents:write` requirement. Checked on 2026-11-23:

| Token | REST `GET /repos/{owner}/{repo}` | GraphQL `repository` |
| --- | --- | --- |
| plan App (Administration: read) | Merge settings, `delete_branch_on_merge`, and `allow_auto_merge` are omitted | Actual values |
| apply App (Administration: write, no Contents) | Actual values | Actual values |

Provider v6.13.0 reads only REST and records the omitted fields as `false` or
empty, which produces a false diff on every plan
([integrations/terraform-provider-github#3382](https://github.com/integrations/terraform-provider-github/issues/3382)).
The plan job therefore runs with `-refresh=false`. It shows what the pull
request changes against the state from the last apply. Changes made on GitHub
outside OpenTofu appear only when apply refreshes with the apply App and
reverts them. Until then, the `drift` job of `github-apply` refreshes every CI
root with the apply App each day (`tofu plan -refresh-only`). It reports drift
or a failed check to the same Discord channel as failed applies. A change to a
ruleset `etag` alone is not drift: GitHub returns a new etag on every read. It never applies or writes state. It runs on main in the
`github-apply` Environment, so the existing Workload Identity condition covers
it. Once a provider release reads these fields over GraphQL
([integrations/terraform-provider-github#3741](https://github.com/integrations/terraform-provider-github/pull/3741)),
remove `-refresh=false` so plans show drift again, and decide whether to keep
the daily check (#41).

Only roots listed in `infra/services/github/ci-roots` run in CI. Both Apps
must be installed on each listed repository. An apply job skips its root when
a later commit on `main` has changed it, so an older run never overwrites newer
configuration.

### Failure notifications

When an apply job fails, it posts the root, commit, and run URL to the
`infra-warning` Discord channel and comments on the merged pull request, as
10X reports to Slack and the pull request. The Discord root owns the dedicated
webhook (`tofu-configuration CI`). The gcp root copies its URL from the Discord
state into the Secret Manager secret `github-apply-discord-webhook`, which only
`github-app-apply` can read; the job reads it through WIF. The pull request
comment uses `GITHUB_TOKEN` with `pull-requests: write`. Neither step needs a
static credential in GitHub.

The dotnix and tofu-configuration roots declare a repository webhook that posts
GitHub events to the house `#github` Discord channel. Its URL follows the same
path: the Discord root owns the webhook (`GitHub`), and the gcp root copies the
URL into `github-repository-discord-webhook`. Both `github-app-plan` and
`github-app-apply` can read that secret, because plan compares the webhook's
configuration. Every plan, apply, and drift job exports it as
`TF_VAR_discord_github_webhook_url`; roots that do not declare the variable
ignore it.

### New repositories

A root without state manages a repository that does not exist yet. A token
cannot be scoped to a missing repository, so for such a root the job gets a
token for the whole installation, as 10X does. The apply App has Repository
creation: write, which lets an installation token create a repository in a
personal account through `POST /user/repos`; Administration: write alone is
rejected. ghat v2.5.1 cannot request that permission, so the new-root apply
token keeps all of the App's permissions. Only the apply workflow on `main`
can sign it.

Verified on 2026-11-23 with a probe App installed on selected repositories:
the created repository joined the installation at once, a token minted before
the creation could read it, and a token scoped to it was issued. Reports from
November 9 and 17 in
[community discussion #210226](https://github.com/orgs/community/discussions/210226)
describe the opposite on personal accounts; recheck if a new-root apply fails
after creating the repository.

GitHub adds the new repository to the creating App's installation. After
OpenTofu applies the new root, `github-apply` adds the repository to the
`yuta-tofu-plan` installation using the apply App's
`installation_repositories: write` permission on a token scoped to the new
repository. The account owner must approve this permission on the apply
installation before CI can use it. Both Apps use selected repositories.

If the API call fails after OpenTofu writes state, rerun the failed job from
the push that introduced the root. You can also add the repository
manually under Settings → Installations → `yuta-tofu-plan` → Repository access.
Until it is added, `github-plan` cannot get a token for that root. If the plan
App is ever reinstalled, update `PLAN_INSTALLATION_ID` in `github-apply.yml`.

## Running OpenTofu

Credentials come from `gcloud auth application-default login`. `op.env`
supplies the billing account ID.

```bash
op run --env-file=op.env -- tofu -chdir=infra/services/gcp init
op run --env-file=op.env -- tofu -chdir=infra/services/gcp plan
```

The default provider sets `user_project_override`, as the provider documentation
recommends for gcloud credentials. A new project cannot be its own quota project
until the Service Usage API is enabled, so the `google.bootstrap` alias enables
that API without a quota project. Right after enabling, the API can take a few
minutes to propagate. If apply then fails with "Service Usage API has not been
used in project", rerun it.

## Resources that outlive OpenTofu

- Key rings and crypto keys cannot be deleted from Google Cloud. Destroying
  them removes them from state, and destroying a key also destroys its versions.
  The keys use `prevent_destroy`.
- A deleted WIF pool stays recoverable for 30 days before permanent deletion.
- The project uses `deletion_policy = "PREVENT"`.
- `auto_create_network` stays `true`: setting it to `false` makes the provider
  enable the Compute Engine API to delete the default network. This project
  uses no Compute Engine, so the API stays disabled.

## Importing an App private key

GitHub generates App private keys, so each key is imported once into its KMS
key. The key material never enters OpenTofu state. An import job expires after
three days, so create it just before importing.

```bash
gcloud kms import-jobs create github-app-import-1 \
  --project yuta-gh-signer --location asia-northeast1 --keyring github-apps \
  --import-method rsa-oaep-3072-sha1-aes-256 --protection-level software
openssl pkcs8 -topk8 -nocrypt -inform PEM -outform DER \
  -in <app>.private-key.pem -out <app>.der
gcloud kms keys versions import \
  --project yuta-gh-signer --location asia-northeast1 --keyring github-apps \
  --key tofu-plan --import-job github-app-import-1 \
  --algorithm rsa-sign-pkcs1-2048-sha256 --target-key-file <app>.der
shred -u <app>.private-key.pem <app>.der
```

Repeat with `--key tofu-apply` for the apply App.
