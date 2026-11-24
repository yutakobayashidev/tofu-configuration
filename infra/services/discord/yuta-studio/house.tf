# The house category and its channels were created on Discord on 2026-10-28.
resource "discord_category_channel" "cat_house" {
  name      = "house"
  server_id = "895564066922328094"
  position  = 1
}

resource "discord_text_channel" "txt_guest" {
  name      = "guest"
  server_id = "895564066922328094"
  position  = 7
  topic     = ""
  nsfw      = false
  category  = discord_category_channel.cat_house.id
}

resource "discord_text_channel" "txt_infra_critical" {
  name      = "infra-critical"
  server_id = "895564066922328094"
  position  = 8
  topic     = ""
  nsfw      = false
  category  = discord_category_channel.cat_house.id
}

resource "discord_text_channel" "txt_infra_warning" {
  name      = "infra-warning"
  server_id = "895564066922328094"
  position  = 9
  topic     = ""
  nsfw      = false
  category  = discord_category_channel.cat_house.id
}

resource "discord_text_channel" "txt_infra_info" {
  name      = "infra-info"
  server_id = "895564066922328094"
  position  = 10
  topic     = ""
  nsfw      = false
  category  = discord_category_channel.cat_house.id
}

resource "discord_text_channel" "txt_home" {
  name      = "home"
  server_id = "895564066922328094"
  position  = 11
  topic     = ""
  nsfw      = false
  category  = discord_category_channel.cat_house.id
}

resource "discord_text_channel" "txt_github" {
  name      = "github"
  server_id = "895564066922328094"
  position  = 16
  topic     = ""
  nsfw      = false
  category  = discord_category_channel.cat_house.id
}
