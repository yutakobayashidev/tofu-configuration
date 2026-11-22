# Environments for the GitHub repository CI. The Workload Identity Federation
# provider in infra/services/gcp accepts tokens only from these environments,
# and each one maps to its own GitHub App signing key.

# Plan runs on pull requests from any branch, so it has no branch policy.
resource "github_repository_environment" "github_plan" {
  repository  = module.repository.name
  environment = "github-plan"
}

# Apply runs only from main.
resource "github_repository_environment" "github_apply" {
  repository        = module.repository.name
  environment       = "github-apply"
  can_admins_bypass = false

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "github_apply_main" {
  repository     = module.repository.name
  environment    = github_repository_environment.github_apply.environment
  branch_pattern = "main"
}
