data "github_repository" "existing" {
  full_name = "yutakobayashidev/surveyor"
}

module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=64642f92df10dd1dbebeb55e8ab51072f4be3efc"

  name        = "surveyor"
  description = try(coalesce(data.github_repository.existing.description), "")
  visibility  = "private"

  general = {
    auto_init              = false
    has_projects           = true
    allow_merge_commit     = true
    allow_rebase_merge     = true
    delete_branch_on_merge = false
  }

  default_branch_ruleset = null
}
