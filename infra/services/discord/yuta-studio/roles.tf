resource "discord_role_everyone" "main" {
  server_id   = "895564066922328094"
  permissions = 2221013488174080
}

resource "discord_role" "admin" {
  server_id   = "895564066922328094"
  name        = "Admin"
  permissions = 1071698660936
  color       = 14527180
  hoist       = true
  position    = 51
}

resource "discord_role" "moderator" {
  server_id   = "895564066922328094"
  name        = "Moderator"
  permissions = 66560
  position    = 17
}

resource "discord_role" "blueflow" {
  server_id   = "895564066922328094"
  name        = "Blueflow"
  permissions = 1071698660928
  color       = 5336536
  position    = 48
}

resource "discord_role" "bot" {
  server_id   = "895564066922328094"
  name        = "BOT"
  permissions = 1071698660929
  color       = 15844367
  hoist       = true
  position    = 40
}

resource "discord_role" "develop" {
  server_id   = "895564066922328094"
  name        = "Develop"
  permissions = 1071698660929
  hoist       = true
  position    = 44
}

resource "discord_role" "project_x" {
  server_id   = "895564066922328094"
  name        = "某プロジェクト"
  permissions = 1071698660929
  hoist       = true
  position    = 46
}

resource "discord_role" "verified" {
  server_id   = "895564066922328094"
  name        = "認証済み"
  permissions = 1071698660928
  color       = 1752220
  hoist       = true
  position    = 41
}

resource "discord_role" "hypixel" {
  server_id   = "895564066922328094"
  name        = "hypixel"
  permissions = 66560
  hoist       = true
  position    = 45
}

resource "discord_role" "api_dev" {
  server_id   = "895564066922328094"
  name        = "API Dev"
  permissions = 66560
  position    = 47
}

resource "discord_role" "crypto" {
  server_id   = "895564066922328094"
  name        = "Crypto"
  permissions = 66560
  color       = 3447003
  hoist       = true
  position    = 43
}

resource "discord_role" "price" {
  server_id   = "895564066922328094"
  name        = "Price"
  permissions = 66560
  hoist       = true
  position    = 42
}

resource "discord_role" "blender" {
  server_id   = "895564066922328094"
  name        = "Blender"
  permissions = 66560
  position    = 38
}

resource "discord_role" "server_god" {
  server_id   = "895564066922328094"
  name        = "サーバーの神"
  permissions = 66560
  position    = 39
}
