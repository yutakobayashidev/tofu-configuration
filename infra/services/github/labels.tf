resource "github_issue_label" "dotnix_safe_to_plan" {
  repository  = github_repository.dotnix.name
  name        = "safe-to-plan"
  color       = "0e8a16"
  description = "Allow an OpenTofu plan to run for a reviewed pull request"
}
