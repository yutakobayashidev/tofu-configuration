resource "google_iam_workload_identity_pool" "github_actions" {
  project                   = google_project.github_app_signing.project_id
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"

  depends_on = [google_project_service.enabled]
}

# Accept only tokens from the plan workflow in the github-plan Environment, or
# from the apply workflow on main in the github-apply Environment. A token
# without an environment claim fails the condition and is rejected.
resource "google_iam_workload_identity_pool_provider" "tofu_configuration" {
  project                            = google_project.github_app_signing.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "tofu-configuration"
  display_name                       = "tofu-configuration"

  attribute_mapping = {
    "google.subject"         = "assertion.sub"
    "attribute.environment"  = "assertion.environment"
    "attribute.workflow_ref" = "assertion.workflow_ref"
  }

  attribute_condition = <<-EOT
    assertion.repository_owner_id == "${local.github_owner_id}" &&
    assertion.repository_id == "${local.github_repository_id}" &&
    (
      (
        assertion.environment == "${local.stages.plan.environment}" &&
        assertion.workflow_ref.startsWith("${local.github_repository}/${local.stages.plan.workflow}@")
      ) ||
      (
        assertion.environment == "${local.stages.apply.environment}" &&
        assertion.ref == "refs/heads/main" &&
        assertion.workflow_ref == "${local.github_repository}/${local.stages.apply.workflow}@refs/heads/main"
      )
    )
  EOT

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github_app_signer" {
  for_each = local.stages

  project      = google_project.github_app_signing.project_id
  account_id   = "github-app-${each.key}"
  display_name = "GitHub App ${each.key} token signer"

  depends_on = [google_project_service.enabled]
}

# The provider condition has already tied each Environment to its workflow, so
# binding by Environment lets only that workflow impersonate the account.
resource "google_service_account_iam_member" "workload_identity_user" {
  for_each = local.stages

  service_account_id = google_service_account.github_app_signer[each.key].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.environment/${each.value.environment}"
}
