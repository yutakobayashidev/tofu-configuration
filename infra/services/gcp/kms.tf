# Key rings and crypto keys cannot be deleted from Google Cloud. Destroying
# them only removes them from state, so their names are permanent.
resource "google_kms_key_ring" "github_apps" {
  project  = google_project.github_app_signing.project_id
  name     = "github-apps"
  location = local.region

  depends_on = [google_project_service.enabled]
}

# GitHub generates GitHub App private keys, so each key starts without a
# version and receives the App key through an import job.
resource "google_kms_crypto_key" "github_app" {
  for_each = local.stages

  name                          = "tofu-${each.key}"
  key_ring                      = google_kms_key_ring.github_apps.id
  purpose                       = "ASYMMETRIC_SIGN"
  import_only                   = true
  skip_initial_version_creation = true

  version_template {
    algorithm        = "RSA_SIGN_PKCS1_2048_SHA256"
    protection_level = "SOFTWARE"
  }

  # Destroying a crypto key destroys all of its versions.
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_member" "signer" {
  for_each = local.stages

  crypto_key_id = google_kms_crypto_key.github_app[each.key].id
  role          = "roles/cloudkms.signer"
  member        = google_service_account.github_app_signer[each.key].member
}
