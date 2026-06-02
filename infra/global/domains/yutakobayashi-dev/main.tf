terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.10.1"
    }
  }
}

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
    value = "hi@yutakobayashi.dev"
  }]

  enabled  = true
  name     = "Rule created at 2024-02-21T04:47:10.321Z"
  priority = 0
}
