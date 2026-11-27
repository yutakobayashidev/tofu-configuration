terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "visibility" {
  type = string
}

variable "settings" {
  type = object({
    default_branch         = string
    is_template            = bool
    has_issues             = bool
    has_discussions        = bool
    has_projects           = bool
    has_wiki               = bool
    allow_merge_commit     = bool
    allow_rebase_merge     = bool
    allow_squash_merge     = bool
    allow_update_branch    = bool
    delete_branch_on_merge = bool
    vulnerability_alerts   = bool
  })
}

resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = var.visibility
  auto_init   = false
  is_template = var.settings.is_template

  has_issues      = var.settings.has_issues
  has_discussions = var.settings.has_discussions
  has_projects    = var.settings.has_projects
  has_wiki        = var.settings.has_wiki

  allow_merge_commit     = var.settings.allow_merge_commit
  allow_rebase_merge     = var.settings.allow_rebase_merge
  allow_squash_merge     = var.settings.allow_squash_merge
  allow_update_branch    = var.settings.allow_update_branch
  delete_branch_on_merge = var.settings.delete_branch_on_merge

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      # The importer leaves these provider-local fields unset. Setting them
      # after import would cause the provider to PATCH the live repository.
      archive_on_destroy,
      ignore_vulnerability_alerts_during_read,
      # Preserve the live homepage and template provenance.
      homepage_url,
      template,
    ]
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.settings.default_branch
}

resource "github_repository_vulnerability_alerts" "this" {
  repository = github_repository.this.name
  enabled    = var.settings.vulnerability_alerts
}
