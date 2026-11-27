module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=64642f92df10dd1dbebeb55e8ab51072f4be3efc"

  name        = "yutakobayashidev"
  description = ":octocat: GitHub Profile README"
  visibility  = "public"

  general = {
    auto_init              = false
    has_projects           = true
    has_wiki               = true
    allow_merge_commit     = true
    allow_rebase_merge     = true
    delete_branch_on_merge = false
    homepage_url           = "https://yutakobayashidev.github.io/yutakobayashidev/"
    topics                 = ["profile", "profile-readme"]
  }

  actions_permissions    = null
  default_branch_ruleset = null
}
