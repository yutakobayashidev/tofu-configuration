module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=f438c079c02f87cce96f10a5edf7907e596f3f44"

  name        = "tofu-configuration"
  description = "OpenTofu configuration for cloud infrastructure"
  visibility  = "public"

  general = {
    auto_init = false

    # Current GitHub settings that differ from the module defaults.
    # Align them with the defaults in later reviewed changes.
    has_projects       = true
    has_wiki           = true
    allow_merge_commit = true
    allow_rebase_merge = true
  }

  # Changes to main go through pull requests that pass plan-gate, the aggregate
  # job of the github-plan workflow, so CI apply runs only on planned commits.
  # The sole owner cannot approve their own pull requests, so no approval is
  # required.
  default_branch_ruleset = {
    required_approvals        = 0
    require_code_owner_review = false
    required_status_checks    = ["plan-gate"]
  }
}
