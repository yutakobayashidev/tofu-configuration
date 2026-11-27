module "repository" {
  source = "../../modules/existing-repository"

  name        = "noren"
  description = "Noren is an independent web client for Mastodon, Bluesky, X, Misskey and Nostr."
  visibility  = "public"

  settings = {
    default_branch         = "main"
    is_template            = false
    has_issues             = true
    has_discussions        = false
    has_projects           = true
    has_wiki               = true
    allow_merge_commit     = true
    allow_rebase_merge     = true
    allow_squash_merge     = true
    allow_update_branch    = false
    delete_branch_on_merge = false
    vulnerability_alerts   = false
  }
}
