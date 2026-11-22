# The github-new-repository workflow opens its pull request with GITHUB_TOKEN,
# which requires letting GitHub Actions create pull requests. The same switch
# lets Actions approve them; main requires no approval, so that grants nothing.
resource "github_workflow_repository_permissions" "this" {
  repository                       = module.repository.name
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = true
}
