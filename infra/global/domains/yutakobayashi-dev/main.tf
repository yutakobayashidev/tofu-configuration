terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.18"
    }
  }
}

locals {
  records = {
    notes = {
      content = "192.0.2.1"
      name    = "notes"
      proxied = true
      type    = "A"
    }
    www = {
      content = "192.0.2.1"
      name    = "www"
      proxied = true
      type    = "A"
    }
    apex = {
      content = "192.0.2.1"
      name    = "yutakobayashi.dev"
      proxied = true
      type    = "A"
    }
    letsencrypt = {
      data = {
        flags = 0
        tag   = "issue"
        value = "letsencrypt.org"
      }
      name    = "yutakobayashi.dev"
      proxied = false
      type    = "CAA"
    }
    chatbot = {
      content = "cname.vercel-dns.com"
      name    = "chatbot"
      proxied = false
      type    = "CNAME"
    }
    bluesky = {
      content = "did=did:plc:vbnh7xdksftiiad7b2la4jqe"
      name    = "_atproto"
      proxied = false
      type    = "TXT"
    }
    discord = {
      content = "dh=93c3c3ec6efe8ca5c32cbfa2e0ebcc8d51eb8227"
      name    = "_discord"
      proxied = false
      type    = "TXT"
    }
    openpgp = {
      content = "openpgp4fpr:F41F0998762C827414995BC9FF8A570917DEC092"
      name    = "yutakobayashi.dev"
      proxied = false
      type    = "TXT"
    }
    keybase = {
      content = "keybase-site-verification=tB_T0n5sEVCXw9EAH-WMc0CLGgtQBGk1LIep3rDgL2c"
      name    = "yutakobayashi.dev"
      proxied = false
      type    = "TXT"
    }
    google_site_verification = {
      content = "google-site-verification=f3egwRynUC4yocqsblXX4-YhEKJOE558NioEenBzFSQ"
      name    = "yutakobayashi.dev"
      proxied = false
      type    = "TXT"
    }
    openai_domain_verification = {
      content = "openai-domain-verification=dv-nMYCt8osXwUqdmX752nOnwBx"
      name    = "yutakobayashi.dev"
      proxied = false
      type    = "TXT"
    }
  }
}

resource "cloudflare_dns_record" "record" {
  for_each = local.records
  zone_id  = var.cloudflare_zone_id
  comment  = try(each.value.comment, null)
  content  = try(each.value.content, null)
  data     = try(each.value.data, null)
  name     = each.value.name
  proxied  = each.value.proxied
  ttl      = 1
  type     = each.value.type
}

resource "cloudflare_page_rule" "redirect_dev_to_com" {
  zone_id  = var.cloudflare_zone_id
  target   = "yutakobayashi.dev/*"
  priority = 1
  status   = "active"
  actions = {
    forwarding_url = {
      url         = "https://yutakobayashi.com/$1"
      status_code = 301
    }
  }
}

resource "cloudflare_page_rule" "redirect_notes" {
  zone_id  = var.cloudflare_zone_id
  target   = "notes.yutakobayashi.dev/*"
  priority = 2
  status   = "active"
  actions = {
    forwarding_url = {
      url         = "https://notes.yutakobayashi.com/$1"
      status_code = 301
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
