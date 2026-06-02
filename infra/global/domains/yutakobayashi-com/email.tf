resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = var.cloudflare_zone_id

  actions = [{
    type = "drop"
  }]

  matchers = [{
    type = "all"
  }]

  enabled = false
}

resource "cloudflare_email_routing_rule" "hi" {
  zone_id = var.cloudflare_zone_id

  actions = [{
    type  = "worker"
    value = ["core"]
  }]

  matchers = [{
    type  = "literal"
    field = "to"
    value = "hi@yutakobayashi.com"
  }]

  enabled  = true
  name     = "Rule created at 2025-05-25T16:13:58.464Z"
  priority = 0
}
