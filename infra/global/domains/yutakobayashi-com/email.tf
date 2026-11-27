resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = var.cloudflare_zone_id

  actions = [{
    type  = "worker"
    value = ["core"]
  }]

  matchers = [{
    type = "all"
  }]

  enabled = true

  # The API returns an empty name; leaving it unset shows an in-place update on every plan.
  name = ""
}

# Each service sends mail from its own subdomain so that inbox providers track its
# deliverability reputation separately. Cloudflare creates the cf-bounce MX, SPF, and
# DKIM records and a _dmarc record for each subdomain; they are not managed here.
resource "cloudflare_email_sending_subdomain" "service" {
  for_each = toset([
    "fedi", # Mastodon
    "git",  # Gitea
  ])

  zone_id = var.cloudflare_zone_id
  name    = "${each.key}.yutakobayashi.com"
}
