output "status_webhook_url" {
  description = "Discord webhook URL for the status channel"
  value       = discord_webhook.uptime.url
  sensitive   = true
}
