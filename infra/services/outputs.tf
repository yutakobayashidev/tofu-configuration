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
