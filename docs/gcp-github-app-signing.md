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
