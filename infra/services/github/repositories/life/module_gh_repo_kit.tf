data "github_repository" "existing" {
  full_name = "yutakobayashidev/life"
}

module "repository" {
  source = "../../modules/existing-repository"

  name        = "life"
  description = try(coalesce(data.github_repository.existing.description), "")
  visibility  = "private"

  settings = {
    default_branch         = "main"
    is_template            = false
    has_issues             = true
    has_discussions        = false
    has_projects           = true
    has_wiki               = false
    allow_merge_commit     = true
    allow_rebase_merge     = true
    allow_squash_merge     = true
    allow_update_branch    = false
    delete_branch_on_merge = false
    vulnerability_alerts   = false
  }
}
