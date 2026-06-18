output "mastodon_r2_access_key_id" {
  value = module.mastodon_r2_token.access_key_id
}

output "mastodon_r2_secret_access_key" {
  value     = module.mastodon_r2_token.secret_access_key
  sensitive = true
}

output "mastodon_media_bucket_name" {
  value = module.mastodon_media.bucket_name
}

output "obsidian_r2_access_key_id" {
  value = module.obsidian_r2_token.access_key_id
}

output "obsidian_r2_secret_access_key" {
  value     = module.obsidian_r2_token.secret_access_key
  sensitive = true
}

output "nix_cache_access_key_id" {
  value = module.nix_cache_token.access_key_id
}

output "nix_cache_secret_access_key" {
  value     = module.nix_cache_token.secret_access_key
  sensitive = true
}

output "nix_cache_bucket_name" {
  value = module.nix_cache.bucket_name
}

output "homelab_infra_state_access_key_id" {
  value = module.homelab_infra_state_token.access_key_id
}

output "homelab_infra_state_secret_access_key" {
  value     = module.homelab_infra_state_token.secret_access_key
  sensitive = true
}

output "homelab_infra_state_bucket_name" {
  value = module.homelab_infra_state.bucket_name
}

output "gitea_email_sending_token" {
  description = "Cloudflare Email Sending API token for Gitea SMTP"
  value       = cloudflare_api_token.gitea_email_sending.value
  sensitive   = true
}
