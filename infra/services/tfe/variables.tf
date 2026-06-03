variable "discord_token" {
  description = "Discord bot token"
  type        = string
  sensitive   = true
}

resource "tfe_variable" "discord_token" {
  key          = "discord_token"
  value        = var.discord_token
  category     = "terraform"
  description  = "Discord bot token"
  sensitive    = true
  workspace_id = tfe_workspace.discord.id
}
