resource "google_project" "github_app_signing" {
  name            = "GitHub App signing"
  project_id      = local.project_id
  billing_account = var.billing_account

  # The account has no organization, so the project has no parent.
  # Keep auto_create_network at its default: setting it to false makes the
  # provider enable the Compute Engine API to delete the default network and
  # leave it enabled. This project uses no Compute Engine resources.
  auto_create_network = true
  deletion_policy     = "PREVENT"
}

resource "google_project_service" "bootstrap" {
  provider = google.bootstrap

  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
  ])

  project            = google_project.github_app_signing.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "cloudkms.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage.googleapis.com",
    "sts.googleapis.com",
  ])

  project            = google_project.github_app_signing.project_id
  service            = each.value
  disable_on_destroy = false

  depends_on = [google_project_service.bootstrap]
}
