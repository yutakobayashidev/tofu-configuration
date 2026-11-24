# Discord webhook that github-apply uses to report a failed apply. The URL comes
# from the Discord root's state, which CI cannot read, and only the apply
# service account may read this copy.
data "terraform_remote_state" "discord" {
  backend = "gcs"

  config = {
    bucket = "yuta-gh-signer-tfstate"
    prefix = "discord"
  }
}

resource "google_secret_manager_secret" "github_apply_discord_webhook" {
  project   = google_project.github_app_signing.project_id
  secret_id = "github-apply-discord-webhook"

  replication {
    auto {}
  }

  depends_on = [google_project_service.enabled]
}

resource "google_secret_manager_secret_version" "github_apply_discord_webhook" {
  secret      = google_secret_manager_secret.github_apply_discord_webhook.id
  secret_data = data.terraform_remote_state.discord.outputs.tofu_configuration_ci_webhook_url
}

resource "google_secret_manager_secret_iam_member" "github_apply_discord_webhook" {
  project   = google_project.github_app_signing.project_id
  secret_id = google_secret_manager_secret.github_apply_discord_webhook.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.github_app_signer["apply"].member
}
