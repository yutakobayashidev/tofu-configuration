# State for every other root in this repository (infra/global, Discord,
# OpenAI, Supabase, and this gcp root). R2 has no object versioning, so these
# states moved here on 2026-11-24. Only the project owner can read them: the CI
# service accounts have no access to this bucket or key.
resource "google_storage_bucket" "service_state" {
  project  = google_project.github_app_signing.project_id
  name     = "${local.project_id}-tfstate"
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

# Encrypts those states and saved plans through the OpenTofu gcp_kms key
# provider, replacing the shared passphrase.
resource "google_kms_crypto_key" "service_state" {
  name            = "services"
  key_ring        = google_kms_key_ring.tofu_state.id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = true
  }
}
