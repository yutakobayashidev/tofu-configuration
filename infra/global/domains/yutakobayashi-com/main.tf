terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.10.1"
    }
  }
}

locals {
  zone_id = var.cloudflare_zone_id
  records = {
    mastodon_a = {
      content = var.mastodon_ip
      name    = "fedi"
      proxied = true
      type    = "A"
    }
    mastodon_dkim_1 = {
      content = "4epkx5liidlbwr24hvivm5hqdxkfvtfw.dkim.amazonses.com"
      name    = "4epkx5liidlbwr24hvivm5hqdxkfvtfw._domainkey.fedi"
      proxied = false
      type    = "CNAME"
    }
    mastodon_dkim_2 = {
      content = "5gualsmqbqr2iyy4jcswf45fnntumcec.dkim.amazonses.com"
      name    = "5gualsmqbqr2iyy4jcswf45fnntumcec._domainkey.fedi"
      proxied = false
      type    = "CNAME"
    }
    mastodon_dkim_3 = {
      content = "tvkogr4mjxbbpsortlpketewdt7rrlqb.dkim.amazonses.com"
      name    = "tvkogr4mjxbbpsortlpketewdt7rrlqb._domainkey.fedi"
      proxied = false
      type    = "CNAME"
    }
  }
}

# fedi-files CNAME is auto-managed by R2 custom domain (module.mastodon_media)

resource "cloudflare_dns_record" "record" {
  for_each = local.records
  zone_id  = local.zone_id
  content  = each.value.content
  name     = each.value.name
  proxied  = each.value.proxied
  ttl      = 1
  type     = each.value.type
}
