module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=2871fec43812d4da413808013232c7234bd2f718"

  name        = "ci-create-probe"
  description = "Probe for CI repository creation; safe to delete"
  visibility  = "private"

  # main accepts changes only through pull requests that pass ci-gate, the
  # aggregate job of the repository's CI workflow. The sole owner cannot
  # approve their own pull requests, so no approval is required.
  default_branch_ruleset = {
    required_approvals        = 0
    require_code_owner_review = false
    required_status_checks    = ["ci-gate"]
  }
}
