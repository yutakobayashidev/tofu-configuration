# Mastodon R2
output "mastodon_r2_access_key_id" {
  description = "Mastodon 用 R2 アクセスキー ID"
  value       = module.services.mastodon_r2_access_key_id
}

output "mastodon_r2_secret_access_key" {
  description = "Mastodon 用 R2 シークレットアクセスキー"
  value       = module.services.mastodon_r2_secret_access_key
  sensitive   = true
}

output "mastodon_r2_endpoint" {
  description = "Mastodon 用 R2 エンドポイント URL"
  value       = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
}

output "mastodon_r2_bucket_name" {
  description = "Mastodon メディア R2 バケット名"
  value       = module.services.mastodon_media_bucket_name
}

# Obsidian R2
output "obsidian_r2_access_key_id" {
  description = "Obsidian 用 R2 アクセスキー ID"
  value       = module.services.obsidian_r2_access_key_id
}

output "obsidian_r2_secret_access_key" {
  description = "Obsidian 用 R2 シークレットアクセスキー"
  value       = module.services.obsidian_r2_secret_access_key
  sensitive   = true
}

# Images R2
output "images_r2_access_key_id" {
  description = "r2-image-worker 用 R2 アクセスキー ID"
  value       = module.services.images_r2_access_key_id
}

output "images_r2_secret_access_key" {
  description = "r2-image-worker 用 R2 シークレットアクセスキー"
  value       = module.services.images_r2_secret_access_key
  sensitive   = true
}

output "images_bucket_name" {
  description = "r2-image-worker 画像 R2 バケット名"
  value       = module.services.images_bucket_name
}

# Nix cache R2
output "nix_cache_access_key_id" {
  description = "Nix cache 用 R2 アクセスキー ID"
  value       = module.services.nix_cache_access_key_id
}

output "nix_cache_secret_access_key" {
  description = "Nix cache 用 R2 シークレットアクセスキー"
  value       = module.services.nix_cache_secret_access_key
  sensitive   = true
}

output "nix_cache_bucket_name" {
  description = "Nix cache R2 バケット名"
  value       = module.services.nix_cache_bucket_name
}

# Homelab infra state R2
output "homelab_infra_state_access_key_id" {
  description = "Homelab infra state 用 R2 アクセスキー ID"
  value       = module.services.homelab_infra_state_access_key_id
}

output "homelab_infra_state_secret_access_key" {
  description = "Homelab infra state 用 R2 シークレットアクセスキー"
  value       = module.services.homelab_infra_state_secret_access_key
  sensitive   = true
}

output "homelab_infra_state_bucket_name" {
  description = "Homelab infra state R2 バケット名"
  value       = module.services.homelab_infra_state_bucket_name
}

output "gitea_email_sending_token" {
  description = "Cloudflare Email Sending API token for Gitea SMTP"
  value       = module.services.gitea_email_sending_token
  sensitive   = true
}

output "yutakobayashi_dev_zone_id" {
  description = "yutakobayashi.dev Cloudflare Zone ID"
  value       = one(data.cloudflare_zones.yutakobayashi_dev.result).id
}
