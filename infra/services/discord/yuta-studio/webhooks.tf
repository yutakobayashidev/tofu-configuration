resource "discord_webhook" "uptime" {
  channel_id = discord_text_channel.txt_status.id
  name       = "Uptime"
}

resource "discord_webhook" "zapier" {
  channel_id = discord_text_channel.txt_webupdates.id
  name       = "Zapier"
}

resource "discord_webhook" "github" {
  channel_id = discord_text_channel.txt_gitupdates.id
  name       = "Github"
}

resource "discord_webhook" "twitter_1" {
  channel_id = discord_text_channel.txt_webclips.id
  name       = "Twitter"
}

resource "discord_webhook" "integromat" {
  channel_id = discord_text_channel.txt_db.id
  name       = "Integromat"
}

resource "discord_webhook" "test" {
  channel_id = discord_text_channel.txt_bot.id
  name       = "test"
}

resource "discord_webhook" "splatoon" {
  channel_id = discord_text_channel.txt_ch630996.id
  name       = "Splatoon"
}

resource "discord_webhook" "nhk" {
  channel_id = discord_news_channel.ann_ch788992.id
  name       = "NHKから国民を守るプログラミング技術"
}

resource "discord_webhook" "birthday" {
  channel_id = discord_news_channel.ann_ch788992.id
  name       = "Birthday"
}

resource "discord_webhook" "sekai_viewer" {
  channel_id = discord_text_channel.txt_db.id
  name       = "Sekai Viewer"
}

resource "discord_webhook" "splatoon3" {
  channel_id = discord_text_channel.txt_splatoon.id
  name       = "Splatoon3"
}

resource "discord_webhook" "yuta_studio_1" {
  channel_id = discord_text_channel.txt_ch424587.id
  name       = "YUTA STUDIO"
}

resource "discord_webhook" "today_doodle" {
  channel_id = discord_news_channel.ann_todaydoodle.id
  name       = "Today Doodle"
}

resource "discord_webhook" "hacker_news" {
  channel_id = discord_news_channel.ann_hackernews.id
  name       = "Hacker News"
}

resource "discord_webhook" "tweetshift_twitter_feeds" {
  channel_id = discord_news_channel.ann_news.id
  name       = "TweetShift - Twitter Feeds"
}

resource "discord_webhook" "twitter_2" {
  channel_id = discord_text_channel.txt_likefeed.id
  name       = "Twitter"
}

resource "discord_webhook" "wordcloud" {
  channel_id = discord_text_channel.txt_serveranalytics.id
  name       = "WordCloud"
}

resource "discord_webhook" "cover_corp" {
  channel_id = discord_text_channel.txt_covernews.id
  name       = "Cover Corp"
}

resource "discord_webhook" "yutakobayashi_dev" {
  channel_id = discord_news_channel.ann_news.id
  name       = "yutakobayashi.dev"
}

resource "discord_webhook" "wh_1205402821521055804" {
  channel_id = discord_text_channel.txt_ch776213.id
  name       = "お知らせ"
}

resource "discord_webhook" "yuta_studio_2" {
  channel_id = discord_text_channel.txt_ch497822.id
  name       = "YUTA STUDIO"
}

resource "discord_webhook" "captain_hook_1" {
  channel_id = discord_text_channel.txt_ch881792.id
  name       = "Captain Hook"
}

resource "discord_webhook" "wh_1249318893558829136" {
  channel_id = discord_text_channel.txt_ch497822.id
  name       = "月曜が近いよ"
}

resource "discord_webhook" "spidey_bot_1" {
  channel_id = discord_text_channel.txt_ch039184.id
  name       = "Spidey Bot"
}

resource "discord_webhook" "captain_hook_2" {
  channel_id = discord_text_channel.txt_feeds.id
  name       = "Captain Hook"
}

resource "discord_webhook" "spidey_bot_2" {
  channel_id = discord_text_channel.txt_feeds.id
  name       = "Spidey Bot"
}

resource "discord_webhook" "spidey_bot_3" {
  channel_id = discord_text_channel.txt_tw.id
  name       = "Spidey Bot"
}

resource "discord_webhook" "spidey_bot_4" {
  channel_id = discord_text_channel.txt_ch497822.id
  name       = "Spidey Bot"
}

resource "discord_webhook" "captain_hook_3" {
  channel_id = discord_text_channel.txt_dtv.id
  name       = "Captain Hook"
}

resource "discord_webhook" "spidey_bot_infra_critical_1" {
  channel_id = discord_text_channel.txt_infra_critical.id
  name       = "Spidey Bot"
}

resource "discord_webhook" "spidey_bot_infra_critical_2" {
  channel_id = discord_text_channel.txt_infra_critical.id
  name       = "Spidey Bot"
}

resource "discord_webhook" "spidey_bot_infra_warning" {
  channel_id = discord_text_channel.txt_infra_warning.id
  name       = "Spidey Bot"
}

resource "discord_webhook" "captain_hook_infra_info" {
  channel_id = discord_text_channel.txt_infra_info.id
  name       = "Captain Hook"
}

resource "discord_webhook" "captain_hook_home_1" {
  channel_id = discord_text_channel.txt_home.id
  name       = "Captain Hook"
}

resource "discord_webhook" "captain_hook_home_2" {
  channel_id = discord_text_channel.txt_home.id
  name       = "Captain Hook"
}

# github-apply in tofu-configuration posts here when an apply fails. The gcp
# root copies the URL into Secret Manager, which only the apply service account
# can read.
resource "discord_webhook" "tofu_configuration_ci" {
  channel_id = discord_text_channel.txt_infra_warning.id
  name       = "tofu-configuration CI"
}

# Repository webhooks of dotnix and tofu-configuration post GitHub events to
# house/#github. The gcp root copies the URL into Secret Manager for the GitHub
# repository roots, which add `/github` for GitHub's payload format.
resource "discord_webhook" "house_github" {
  channel_id = discord_text_channel.txt_github.id
  name       = "GitHub"
}
