# Posts repository events to house/#github on Discord. CI reads the URL from
# Secret Manager (github-repository-discord-webhook) into this variable; run
# locally with
#   export TF_VAR_discord_github_webhook_url="$(gcloud secrets versions access latest \
#     --secret=github-repository-discord-webhook --project=yuta-gh-signer)"
variable "discord_github_webhook_url" {
  description = "Discord webhook URL for house/#github, without the /github suffix."
  type        = string
  sensitive   = true
}

resource "github_repository_webhook" "discord" {
  repository = module.repository.name
  active     = true
  # Discord accepts GitHub's payload format at the /github endpoint.
  events = [
    "push",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment",
    "issues",
    "issue_comment",
    "release",
  ]

  configuration {
    url          = "${var.discord_github_webhook_url}/github"
    content_type = "json"
    insecure_ssl = false
  }
}
