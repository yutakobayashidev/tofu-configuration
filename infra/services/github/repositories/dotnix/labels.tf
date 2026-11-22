resource "github_issue_label" "safe_to_plan" {
  repository  = module.repository.name
  name        = "safe-to-plan"
  color       = "0e8a16"
  description = "Allow an OpenTofu plan to run for a reviewed pull request"
}

resource "github_issue_label" "safe_to_apply" {
  repository  = module.repository.name
  name        = "safe-to-apply"
  color       = "b60205"
  description = "Allow OpenTofu to apply a reviewed pull request"
}
