# Manage HCP Terraform workspaces as code

resource "tfe_workspace" "homelab" {
  name         = "homelab"
  organization = tfe_organization.this.name
  project_id   = tfe_project.default.id
  description  = "Homelab infrastructure (DO, Cloudflare, AWS)"

  working_directory     = "infra/global"
  file_triggers_enabled = true
  queue_all_runs        = true

  vcs_repo {
    identifier                 = "yutakobayashidev/tofu-configuration"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.github.id
  }
}

resource "tfe_workspace_settings" "homelab" {
  workspace_id   = tfe_workspace.homelab.id
  execution_mode = "remote"
}

resource "tfe_workspace" "github" {
  name         = "github"
  organization = tfe_organization.this.name
  project_id   = tfe_project.default.id
  description  = "GitHub repositories and settings"

  working_directory     = "infra/services/github"
  file_triggers_enabled = true
  queue_all_runs        = true

  vcs_repo {
    identifier                 = "yutakobayashidev/tofu-configuration"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.github.id
  }
}

resource "tfe_workspace_settings" "github" {
  workspace_id   = tfe_workspace.github.id
  execution_mode = "remote"
}

resource "tfe_workspace" "discord" {
  name         = "discord"
  organization = tfe_organization.this.name
  project_id   = tfe_project.default.id
  description  = "Discord server settings, channels, roles, and permissions"

  working_directory     = "infra/services/discord"
  file_triggers_enabled = true
  queue_all_runs        = true

  vcs_repo {
    identifier                 = "yutakobayashidev/tofu-configuration"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.github.id
  }
}

resource "tfe_workspace_settings" "discord" {
  workspace_id   = tfe_workspace.discord.id
  execution_mode = "remote"
}
