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
    blockly = {
      content = "blockly-bot.pages.dev"
      name    = "blockly"
      proxied = true
      type    = "CNAME"
    }
    studio = {
      content = "studio-crh.pages.dev"
      name    = "studio"
      proxied = true
      type    = "CNAME"
    }
    email_routing_mx1 = {
      content  = "route1.mx.cloudflare.net"
      name     = "yutakobayashi.dev"
      priority = 45
      proxied  = false
      type     = "MX"
    }
    email_routing_mx2 = {
      content  = "route2.mx.cloudflare.net"
      name     = "yutakobayashi.dev"
      priority = 63
      proxied  = false
      type     = "MX"
    }
    email_routing_mx3 = {
      content  = "route3.mx.cloudflare.net"
      name     = "yutakobayashi.dev"
      priority = 56
      proxied  = false
      type     = "MX"
    }
    cloudflare_dkim = {
      content = "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k\" \"m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB\""
      name    = "cf2024-1._domainkey"
      proxied = false
      type    = "TXT"
    }
    cloudflare_spf = {
      content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
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
  priority = try(each.value.priority, null)
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
