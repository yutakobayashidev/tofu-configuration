# GitHub App signing

CI for the GitHub repository roots will authenticate as GitHub Apps without a
private key in GitHub Secrets, following
[10X's approach](https://product.10x.co.jp/entry/2026/04/01/163814). Cloud KMS
holds the App private keys and signs App JWTs. GitHub Actions reaches KMS only
through Workload Identity Federation (WIF), and the job exchanges the signed JWT
for an installation token limited to the repository it manages.

`infra/services/gcp` manages the Google Cloud side. Its state is encrypted in R2
at `gcp/terraform.tfstate`.

## Resources

| Resource | Name | Purpose |
| --- | --- | --- |
| Project | `yuta-gh-signer` | No organization parent. Billing account from `TF_VAR_billing_account` |
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

The other roots stay in R2: their providers have no OIDC federation, so moving
their state would not remove the static credentials CI would need.

## CI workflows

`.github/workflows/github-plan.yml` plans the changed roots on pull requests,
and `.github/workflows/github-apply.yml` applies them after a merge to `main`.
Each matrix job reads the repository name from the root, then:

1. authenticates to Google Cloud with `google-github-actions/auth` through WIF,
2. signs an App JWT with KMS and exchanges it for an installation token
   limited to that one repository with `yagihash/ghat`, which revokes the token
   when the job ends,
3. runs OpenTofu from the `github-ci` Nix shell. The lock files record the
   nixpkgs provider build, so CI uses the same build.

| Stage | GitHub App | App ID | Token permissions |
| --- | --- | --- | --- |
| plan | `yuta-tofu-plan` | 5875937 | Metadata, Administration, Issues, Actions: read |
| apply | `yuta-tofu-apply` | 5875943 | Administration and Issues: write; Metadata and Actions: read |

Actions read is needed to read the GitHub Environments managed by the
`tofu-configuration` root.

The plan App stays read-only. Unlike 10X, this public personal repository
cannot use push rulesets to stop a pull request from editing the workflows, so
code from a pull request branch, including one opened by an AI agent, could
use any token the plan job receives. GitHub returns merge settings such as
`delete_branch_on_merge` only to tokens that can write, so the plan job runs
with `-refresh=false`: it shows what the pull request changes against the state
from the last apply. Changes made on GitHub outside OpenTofu appear only when
apply refreshes with the apply App and reverts them. Only roots listed in `ENABLED_ROOTS` in both
workflows run in CI; add a root there after installing both Apps on its
repository. An apply job skips its root when a later commit on `main` has
changed it, so an older run never overwrites newer configuration.

## Running OpenTofu

Credentials come from `gcloud auth application-default login`. Load the
[R2 backend credentials](service-state.md) and the billing account ID.

```bash
export TF_VAR_billing_account="$(gcloud billing accounts list --filter=open=true --format='value(name)' | sed 's|^billingAccounts/||')"
tofu -chdir=infra/services/gcp init
tofu -chdir=infra/services/gcp plan
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
