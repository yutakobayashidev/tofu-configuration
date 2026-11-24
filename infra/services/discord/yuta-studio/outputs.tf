output "status_webhook_url" {
  description = "Discord webhook URL for the status channel"
  value       = discord_webhook.uptime.url
  sensitive   = true
}

output "tofu_configuration_ci_webhook_url" {
  description = "Discord webhook URL for tofu-configuration CI failure notifications"
  value       = discord_webhook.tofu_configuration_ci.url
  sensitive   = true
}
