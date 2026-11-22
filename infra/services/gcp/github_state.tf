# State for the GitHub repository roots lives here rather than in R2, so CI
# reaches it through Workload Identity Federation without a static credential.
# Object Versioning keeps earlier states recoverable after a bad write.
resource "google_storage_bucket" "github_state" {
  project  = google_project.github_app_signing.project_id
  name     = "${local.project_id}-github-tfstate"
  location = upper(local.region)

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 20
      with_state         = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.enabled]
}

resource "google_kms_key_ring" "tofu_state" {
  project  = google_project.github_app_signing.project_id
  name     = "tofu-state"
  location = local.region

  depends_on = [google_project_service.enabled]
}

# Encrypts the GitHub repository states and saved plans through the OpenTofu
# gcp_kms key provider, replacing the shared passphrase.
resource "google_kms_crypto_key" "github_state" {
  name            = "github-repositories"
  key_ring        = google_kms_key_ring.tofu_state.id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket_iam_member" "github_state" {
  for_each = local.stages

  bucket = google_storage_bucket.github_state.name
  role   = each.value.state_bucket_role
  member = google_service_account.github_app_signer[each.key].member
}

resource "google_kms_crypto_key_iam_member" "github_state" {
  for_each = local.stages

  crypto_key_id = google_kms_crypto_key.github_state.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = google_service_account.github_app_signer[each.key].member
}
