output "project_id" {
  description = "Google Cloud project that signs GitHub App JWTs"
  value       = google_project.github_app_signing.project_id
}

output "workload_identity_provider" {
  description = "Provider resource name for google-github-actions/auth"
  value       = google_iam_workload_identity_pool_provider.tofu_configuration.name
}

output "service_accounts" {
  description = "Signer service account email per stage"
  value       = { for stage, account in google_service_account.github_app_signer : stage => account.email }
}

output "kms_keys" {
  description = "KMS key ring location and key name per stage, as ghat expects"
  value = {
    location = google_kms_key_ring.github_apps.location
    keyring  = google_kms_key_ring.github_apps.name
    keys     = { for stage, key in google_kms_crypto_key.github_app : stage => key.name }
  }
}
