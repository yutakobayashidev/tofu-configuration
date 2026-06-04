resource "discord_server" "main" {
  name                      = "YUTA STUDIO"
  verification_level        = 1
  default_message_notifications = 1
  explicit_content_filter   = 2
  afk_timeout               = 300
  afk_channel_id            = discord_voice_channel.vc_AFK.id
  description               = "$argon2id$v=19$m=64,t=512,p=2$6DFi/R8hte2hwOoluD5Ipg$tFGm2m5P2sb5hQ57ORCbWQ"
}
resource "discord_category_channel" "cat_Welcome" {
  name      = "welcome"
  server_id = "895564066922328094"
  position  = 0
}
resource "discord_category_channel" "cat_ChatRoom" {
  name      = "chat-room"
  server_id = "895564066922328094"
  position  = 1
}
resource "discord_category_channel" "cat_feed" {
  name      = "feed"
  server_id = "895564066922328094"
  position  = 2
}
resource "discord_category_channel" "cat_Projects" {
  name      = "projects"
  server_id = "895564066922328094"
  position  = 3
}
resource "discord_category_channel" "cat_ch971904" {
  name      = "topics"
  server_id = "895564066922328094"
  position  = 4
}
resource "discord_category_channel" "cat_ARCHIVE" {
  name      = "archive"
  server_id = "895564066922328094"
  position  = 5
}
resource "discord_text_channel" "txt_ch424587" {
  name      = "introduction"
  server_id = "895564066922328094"
  position  = 0
  topic     = "\u3067\u3093\u305b\u3064\u306e\u306f\u3058\u307e\u308a"
  nsfw      = false
  category = discord_category_channel.cat_Welcome.id
}
resource "discord_voice_channel" "vc_YUTASTUDIO" {
  name      = "YUTA STUDIO"
  server_id = "895564066922328094"
  position  = 0
  bitrate    = 64000
  user_limit = 0
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_ch801860" {
  name      = "welcome"
  server_id = "895564066922328094"
  position  = 1
  topic     = "#\u306f\u3058\u3081\u306b\u3067\u30ed\u30fc\u30eb\u3092\u53d7\u3051\u53d6\u3063\u3066\u304f\u3060\u3055\u3044\uff01"
  nsfw      = false
  category = discord_category_channel.cat_Welcome.id
  sync_perms_with_category = false
}
resource "discord_voice_channel" "vc_MemberCount111" {
  name      = "Member Count: 111"
  server_id = "895564066922328094"
  position  = 1
  bitrate    = 64000
  user_limit = 0
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_ch776213" {
  name      = "server-perks"
  server_id = "895564066922328094"
  position  = 2
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_Welcome.id
}
resource "discord_voice_channel" "vc_ch894141" {
  name      = "general"
  server_id = "895564066922328094"
  position  = 2
  bitrate    = 64000
  user_limit = 0
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_voice_channel" "vc_AFK" {
  name      = "AFK"
  server_id = "895564066922328094"
  position  = 3
  bitrate    = 64000
  user_limit = 0
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_ch121728" {
  name      = "roles"
  server_id = "895564066922328094"
  position  = 3
  topic     = "\u8208\u5473\u306e\u3042\u308b\u3082\u306e\u304c\u3042\u308c\u3070\u9078\u629e\u3057\u3066\u304f\u3060\u3055\u3044\uff01"
  nsfw      = false
  category = discord_category_channel.cat_Welcome.id
}
resource "discord_text_channel" "txt_ch696981" {
  name      = "moderator"
  server_id = "895564066922328094"
  position  = 4
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_Welcome.id
  sync_perms_with_category = false
}
resource "discord_news_channel" "ann_ch112660" {
  name      = "announcements"
  server_id = "895564066922328094"
  position  = 5
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_Welcome.id
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_sns" {
  name      = "sns"
  server_id = "895564066922328094"
  position  = 6
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_Welcome.id
}
resource "discord_text_channel" "txt_ch497822" {
  name      = "chat"
  server_id = "895564066922328094"
  position  = 7
  topic     = "\u30e2\u30ce\u30ed\u30fc\u30b0\u3092\u5782\u308c\u6d41\u3059\u30c1\u30e3\u30f3\u30cd\u30eb\u3067\u3059 Slack: https://dub.sh/slack-times"
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_tw" {
  name      = "tw"
  server_id = "895564066922328094"
  position  = 8
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_dtv" {
  name      = "dtv"
  server_id = "895564066922328094"
  position  = 9
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_splatoon" {
  name      = "splatoon"
  server_id = "895564066922328094"
  position  = 10
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_ch881792" {
  name      = "work-stats"
  server_id = "895564066922328094"
  position  = 13
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
  sync_perms_with_category = false
}

resource "discord_text_channel" "txt_ch465618" {
  name      = "tech-news-papers"
  server_id = "895564066922328094"
  position  = 15
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_ch923220" {
  name      = "links-promo"
  server_id = "895564066922328094"
  position  = 16
  topic     = "\u5ba3\u4f1d\u3084\u30b5\u30fc\u30d3\u30b9\u7d39\u4ecb\u306a\u3069\uff01"
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_gif" {
  name      = "gif"
  server_id = "895564066922328094"
  position  = 17
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_status" {
  name      = "status"
  server_id = "895564066922328094"
  position  = 18
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_commands" {
  name      = "commands"
  server_id = "895564066922328094"
  position  = 19
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_ch309525" {
  name      = "notes"
  server_id = "895564066922328094"
  position  = 20
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_ch039184" {
  name      = "domain-monitoring"
  server_id = "895564066922328094"
  position  = 22
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_toolchain" {
  name      = "toolchain"
  server_id = "895564066922328094"
  position  = 23
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_feeds" {
  name      = "feeds"
  server_id = "895564066922328094"
  position  = 24
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ChatRoom.id
}
resource "discord_text_channel" "txt_serveranalytics" {
  name      = "server-analytics"
  server_id = "895564066922328094"
  position  = 25
  topic     = "YUTA STUDIO Server Analytics"
  nsfw      = false
  category = discord_category_channel.cat_feed.id
}
resource "discord_news_channel" "ann_safety" {
  name      = "safety"
  server_id = "895564066922328094"
  position  = 26
  topic     = "\u65e5\u672c\u306e\u9632\u707d\u60c5\u5831"
  nsfw      = false
  category = discord_category_channel.cat_feed.id
  sync_perms_with_category = false
}
resource "discord_news_channel" "ann_podcast" {
  name      = "podcast"
  server_id = "895564066922328094"
  position  = 27
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_feed.id
}
resource "discord_news_channel" "ann_hackernews" {
  name      = "hacker-news"
  server_id = "895564066922328094"
  position  = 28
  topic     = "news.ycombinator.com"
  nsfw      = false
  category = discord_category_channel.cat_feed.id
  sync_perms_with_category = false
}
resource "discord_news_channel" "ann_todaydoodle" {
  name      = "today-doodle"
  server_id = "895564066922328094"
  position  = 29
  topic     = "Doodle\u306f\u3001\u795d\u65e5\u3084\u8a18\u5ff5\u65e5\u3001\u6709\u540d\u306a\u753b\u5bb6\u3084\u5148\u99c6\u8005\u3001\u79d1\u5b66\u8005\u306e\u751f\u8a95\u306a\u3069\u3092\u795d\u3046\u305f\u3081\u3001\u65ac\u65b0\u3067\u697d\u3057\u304f\u3001\u307e\u305f\u6642\u306b\u306f\u81ea\u7531\u306a\u624b\u6cd5\u3067 Google \u306e\u30ed\u30b4 \u30de\u30fc\u30af\u3092\u30a2\u30ec\u30f3\u30b8\u3057\u305f\u3082\u306e\u3067\u3059\u3002"
  nsfw      = false
  category = discord_category_channel.cat_feed.id
  sync_perms_with_category = false
}
resource "discord_news_channel" "ann_covid19" {
  name      = "covid19"
  server_id = "895564066922328094"
  position  = 30
  topic     = "\u4e3b\u8981\u306a\u90fd\u9053\u5e9c\u770c\u3084\u4e16\u754c\u306e\u30b0\u30e9\u30d5\u3084\u30b3\u30ed\u30d7\u30ec\u30b9\u56f3\u3092\u9001\u4fe1\u3057\u307e\u3059\u3002"
  nsfw      = false
  category = discord_category_channel.cat_feed.id
}
resource "discord_text_channel" "txt_whether" {
  name      = "whether"
  server_id = "895564066922328094"
  position  = 31
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_feed.id
}
resource "discord_text_channel" "txt_covernews" {
  name      = "cover-news"
  server_id = "895564066922328094"
  position  = 32
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_feed.id
}
resource "discord_text_channel" "txt_likefeed" {
  name      = "like-feed"
  server_id = "895564066922328094"
  position  = 33
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_feed.id
}
resource "discord_text_channel" "txt_spotifylog" {
  name      = "spotify-log"
  server_id = "895564066922328094"
  position  = 34
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_feed.id
}

resource "discord_text_channel" "txt_times" {
  name      = "about-times"
  server_id = "895564066922328094"
  position  = 39
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_news_channel" "ann_news" {
  name      = "news"
  server_id = "895564066922328094"
  position  = 41
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
  sync_perms_with_category = false
}
resource "discord_news_channel" "ann_ch788992" {
  name      = "all-announcements"
  server_id = "895564066922328094"
  position  = 43
  topic     = "\u5168\u4f53\u30a2\u30ca\u30a6\u30f3\u30b9"
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
  sync_perms_with_category = false
}

resource "discord_text_channel" "txt_zatsudan" {
  name      = "zatsudan"
  server_id = "895564066922328094"
  position  = 46
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_bot" {
  name      = "bot"
  server_id = "895564066922328094"
  position  = 48
  topic     = "\u3044\u308d\u3044\u308d\u3058\u3063\u3051\u3093\u3057\u3066\u307e\u3059"
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_address" {
  name      = "address"
  server_id = "895564066922328094"
  position  = 49
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_ch272522" {
  name      = "about-public-server"
  server_id = "895564066922328094"
  position  = 50
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_ch094218" {
  name      = "programming"
  server_id = "895564066922328094"
  position  = 51
  topic     = "\u5236\u4f5c\u7269\u3068\u304b\u30d8\u30eb\u30d7\u3068\u304b"
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_ch210378" {
  name      = "science"
  server_id = "895564066922328094"
  position  = 52
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}

resource "discord_text_channel" "txt_ch350366" {
  name      = "study"
  server_id = "895564066922328094"
  position  = 54
  topic     = "\u4e0d\u767b\u6821\u6b743\u5e74\u306b\u3088\u308b\u52c9\u5f37\u4f1a"
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_notion" {
  name      = "notion"
  server_id = "895564066922328094"
  position  = 55
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_ch444885" {
  name      = "astronomy"
  server_id = "895564066922328094"
  position  = 56
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_ch603581" {
  name      = "music"
  server_id = "895564066922328094"
  position  = 57
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_ch630996" {
  name      = "games"
  server_id = "895564066922328094"
  position  = 58
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_db" {
  name      = "proseka-db"
  server_id = "895564066922328094"
  position  = 59
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ch971904.id
}
resource "discord_text_channel" "txt_gitupdates" {
  name      = "git-updates"
  server_id = "895564066922328094"
  position  = 60
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
}
resource "discord_text_channel" "txt_mcchangelog" {
  name      = "mc-changelog"
  server_id = "895564066922328094"
  position  = 61
  topic     = "@mcchangelog"
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_pricetracker" {
  name      = "price-tracker"
  server_id = "895564066922328094"
  position  = 62
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
}
resource "discord_text_channel" "txt_webclips" {
  name      = "web-clips"
  server_id = "895564066922328094"
  position  = 63
  topic     = "\u30df\u30e5\u30fc\u30c8\u63a8\u5968\u3067\u3059"
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
}
resource "discord_text_channel" "txt_music" {
  name      = "music"
  server_id = "895564066922328094"
  position  = 65
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
}
resource "discord_text_channel" "txt_ch248970" {
  name      = "leave"
  server_id = "895564066922328094"
  position  = 67
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_ch686130" {
  name      = "join"
  server_id = "895564066922328094"
  position  = 68
  topic     = "Welcome!"
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_ch705907" {
  name      = "general"
  server_id = "895564066922328094"
  position  = 69
  topic     = "\u7dcf\u5408"
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
}
resource "discord_text_channel" "txt_webupdates" {
  name      = "web-updates"
  server_id = "895564066922328094"
  position  = 71
  topic     = "yutakobayashi.dev/feed"
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
  sync_perms_with_category = false
}
resource "discord_text_channel" "txt_partymode" {
  name      = "party-mode"
  server_id = "895564066922328094"
  position  = 74
  topic     = ""
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
}
resource "discord_text_channel" "txt_ch502387" {
  name      = "self-introduction"
  server_id = "895564066922328094"
  position  = 76
  topic     = "\u4efb\u610f"
  nsfw      = false
  category = discord_category_channel.cat_ARCHIVE.id
  sync_perms_with_category = false
}
resource "discord_channel_permission" "txt_ch424587_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch424587.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "vc_YUTASTUDIO_perm_22328094" {
  channel_id   = discord_voice_channel.vc_YUTASTUDIO.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1024
  deny         = 1048576
}
resource "discord_channel_permission" "txt_ch801860_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch801860.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 2048
  deny         = 0
}
resource "discord_channel_permission" "vc_MemberCount111_perm_22328094" {
  channel_id   = discord_voice_channel.vc_MemberCount111.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1024
  deny         = 1048576
}
resource "discord_channel_permission" "vc_MemberCount111_perm_07919639" {
  channel_id   = discord_voice_channel.vc_MemberCount111.id
  overwrite_id = "432533456807919639"
  type         = "user"
  allow        = 1048576
  deny         = 0
}
resource "discord_channel_permission" "txt_ch776213_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch776213.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "vc_ch894141_perm_22328094" {
  channel_id   = discord_voice_channel.vc_ch894141.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "vc_ch894141_perm_98715412" {
  channel_id   = discord_voice_channel.vc_ch894141.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "vc_AFK_perm_22328094" {
  channel_id   = discord_voice_channel.vc_AFK.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "vc_AFK_perm_98715412" {
  channel_id   = discord_voice_channel.vc_AFK.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_ch121728_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch121728.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch696981_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch696981.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "ann_ch112660_perm_22328094" {
  channel_id   = discord_news_channel.ann_ch112660.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 2048
  deny         = 0
}
resource "discord_channel_permission" "txt_sns_perm_22328094" {
  channel_id   = discord_text_channel.txt_sns.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch497822_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch497822.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch497822_perm_98715412" {
  channel_id   = discord_text_channel.txt_ch497822.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_tw_perm_22328094" {
  channel_id   = discord_text_channel.txt_tw.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_tw_perm_98715412" {
  channel_id   = discord_text_channel.txt_tw.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_dtv_perm_22328094" {
  channel_id   = discord_text_channel.txt_dtv.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_dtv_perm_98715412" {
  channel_id   = discord_text_channel.txt_dtv.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_splatoon_perm_22328094" {
  channel_id   = discord_text_channel.txt_splatoon.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 0
}
resource "discord_channel_permission" "txt_splatoon_perm_98715412" {
  channel_id   = discord_text_channel.txt_splatoon.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1049600
  deny         = 0
}
resource "discord_channel_permission" "txt_ch881792_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch881792.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 3072
}

resource "discord_channel_permission" "txt_ch465618_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch465618.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch465618_perm_98715412" {
  channel_id   = discord_text_channel.txt_ch465618.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_ch923220_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch923220.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch923220_perm_98715412" {
  channel_id   = discord_text_channel.txt_ch923220.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_gif_perm_22328094" {
  channel_id   = discord_text_channel.txt_gif.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_gif_perm_98715412" {
  channel_id   = discord_text_channel.txt_gif.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_status_perm_22328094" {
  channel_id   = discord_text_channel.txt_status.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_status_perm_98715412" {
  channel_id   = discord_text_channel.txt_status.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_commands_perm_22328094" {
  channel_id   = discord_text_channel.txt_commands.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_commands_perm_98715412" {
  channel_id   = discord_text_channel.txt_commands.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_ch309525_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch309525.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch039184_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch039184.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch039184_perm_98715412" {
  channel_id   = discord_text_channel.txt_ch039184.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_toolchain_perm_22328094" {
  channel_id   = discord_text_channel.txt_toolchain.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_toolchain_perm_98715412" {
  channel_id   = discord_text_channel.txt_toolchain.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "txt_feeds_perm_22328094" {
  channel_id   = discord_text_channel.txt_feeds.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "txt_feeds_perm_98715412" {
  channel_id   = discord_text_channel.txt_feeds.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1051648
  deny         = 0
}
resource "discord_channel_permission" "ann_safety_perm_22328094" {
  channel_id   = discord_news_channel.ann_safety.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 0
}
resource "discord_channel_permission" "ann_safety_perm_98715412" {
  channel_id   = discord_news_channel.ann_safety.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1049600
  deny         = 0
}
resource "discord_channel_permission" "ann_hackernews_perm_22328094" {
  channel_id   = discord_news_channel.ann_hackernews.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "ann_todaydoodle_perm_22328094" {
  channel_id   = discord_news_channel.ann_todaydoodle.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 1048576
  deny         = 2048
}
resource "discord_channel_permission" "ann_todaydoodle_perm_13807872" {
  channel_id   = discord_news_channel.ann_todaydoodle.id
  overwrite_id = "1043855499113807872"
  type         = "role"
  allow        = 76800
  deny         = 0
}

resource "discord_channel_permission" "txt_times_perm_22328094" {
  channel_id   = discord_text_channel.txt_times.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "ann_news_perm_98233693" {
  channel_id   = discord_news_channel.ann_news.id
  overwrite_id = "1016594320398233693"
  type         = "role"
  allow        = 52288
  deny         = 0
}
resource "discord_channel_permission" "ann_ch788992_perm_22328094" {
  channel_id   = discord_news_channel.ann_ch788992.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "ann_ch788992_perm_98715412" {
  channel_id   = discord_news_channel.ann_ch788992.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 2048
  deny         = 0
}

resource "discord_channel_permission" "txt_zatsudan_perm_22328094" {
  channel_id   = discord_text_channel.txt_zatsudan.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_bot_perm_22328094" {
  channel_id   = discord_text_channel.txt_bot.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_address_perm_22328094" {
  channel_id   = discord_text_channel.txt_address.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch272522_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch272522.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 16
}
resource "discord_channel_permission" "txt_ch094218_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch094218.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch210378_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch210378.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}

resource "discord_channel_permission" "txt_ch350366_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch350366.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_notion_perm_22328094" {
  channel_id   = discord_text_channel.txt_notion.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch444885_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch444885.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch603581_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch603581.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch630996_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch630996.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_db_perm_22328094" {
  channel_id   = discord_text_channel.txt_db.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 16
  deny         = 1024
}
resource "discord_channel_permission" "txt_gitupdates_perm_22328094" {
  channel_id   = discord_text_channel.txt_gitupdates.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_mcchangelog_perm_22328094" {
  channel_id   = discord_text_channel.txt_mcchangelog.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_mcchangelog_perm_70375178" {
  channel_id   = discord_text_channel.txt_mcchangelog.id
  overwrite_id = "910521632970375178"
  type         = "user"
  allow        = 1024
  deny         = 0
}
resource "discord_channel_permission" "txt_mcchangelog_perm_98715412" {
  channel_id   = discord_text_channel.txt_mcchangelog.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1024
  deny         = 2048
}
resource "discord_channel_permission" "txt_pricetracker_perm_22328094" {
  channel_id   = discord_text_channel.txt_pricetracker.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_webclips_perm_22328094" {
  channel_id   = discord_text_channel.txt_webclips.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_music_perm_22328094" {
  channel_id   = discord_text_channel.txt_music.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch248970_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch248970.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch686130_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch686130.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 2048
}
resource "discord_channel_permission" "txt_ch686130_perm_98715412" {
  channel_id   = discord_text_channel.txt_ch686130.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1024
  deny         = 0
}
resource "discord_channel_permission" "txt_ch705907_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch705907.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_webupdates_perm_22328094" {
  channel_id   = discord_text_channel.txt_webupdates.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 3072
}
resource "discord_channel_permission" "txt_webupdates_perm_98715412" {
  channel_id   = discord_text_channel.txt_webupdates.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_partymode_perm_22328094" {
  channel_id   = discord_text_channel.txt_partymode.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch502387_perm_22328094" {
  channel_id   = discord_text_channel.txt_ch502387.id
  overwrite_id = "895564066922328094"
  type         = "role"
  allow        = 0
  deny         = 1024
}
resource "discord_channel_permission" "txt_ch502387_perm_98715412" {
  channel_id   = discord_text_channel.txt_ch502387.id
  overwrite_id = "914810396198715412"
  type         = "role"
  allow        = 1048576
  deny         = 1024
}
