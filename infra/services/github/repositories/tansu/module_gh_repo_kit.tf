module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=f438c079c02f87cce96f10a5edf7907e596f3f44"

  name        = "tansu"
  description = "A minimal Android app that turns business-card photos in a folder into vCard/CSV, using ChatGPT plan sign-in or an OpenAI-compatible API."
  visibility  = "public"

  # main accepts changes only through pull requests that pass ci-gate, the
  # aggregate job of the repository's CI workflow. The sole owner cannot
  # approve their own pull requests, so no approval is required.
  default_branch_ruleset = {
    required_approvals        = 0
    require_code_owner_review = false
    required_status_checks    = ["ci-gate"]
  }
}
