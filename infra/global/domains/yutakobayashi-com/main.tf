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
    git = {
      content = "${cloudflare_zero_trust_tunnel_cloudflared.b450m_pro4.id}.cfargotunnel.com"
      name    = "git"
      proxied = true
      type    = "CNAME"
    }
    niks3 = {
      content = "${cloudflare_zero_trust_tunnel_cloudflared.b450m_pro4.id}.cfargotunnel.com"
      name    = "niks3"
      proxied = true
      type    = "CNAME"
    }
    bluesky = {
      comment = "Bluesky"
      content = "\"did=did:plc:vbnh7xdksftiiad7b2la4jqe\""
      name    = "_atproto"
      proxied = false
      type    = "TXT"
    }
    ses_mail_from_mx = {
      content  = "feedback-smtp.ap-northeast-1.amazonses.com"
      name     = "send"
      priority = 10
      proxied  = false
      ttl      = 3600
      type     = "MX"
    }
    ses_mail_from_spf = {
      content = "\"v=spf1 include:amazonses.com ~all\""
      name    = "send"
      proxied = false
      ttl     = 3600
      type    = "TXT"
    }
    letsencrypt = {
      data = {
        flags = 0
        tag   = "issue"
        value = "letsencrypt.org"
      }
      name    = "yutakobayashi.com"
      proxied = false
      type    = "CAA"
    }
    resend_dkim = {
      content = "\"p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFRap4FHOA66lWS2sOqb4umU/3d20PZVnOTMdFFQ4D6myval+cBLORQODY+2MAy+JLmS4ahxIT7Qf3K8yDYWFm+OSVLTSnVsUOflbubzGmNjPW3vpA/os9ywpLOFK+7DGzei0R5tXVwaTzKEc30T4Y3CMCtdBt+MJC/9ztOrTS9wIDAQAB\""
      name    = "resend._domainkey"
      proxied = false
      ttl     = 3600
      type    = "TXT"
    }
    dmarc = {
      content = "\"v=DMARC1; p=none;\""
      name    = "_dmarc"
      proxied = false
      type    = "TXT"
    }
  }
}

# fedi-files CNAME is auto-managed by R2 custom domain (module.mastodon_media)
# nix-cache CNAME is auto-managed by R2 custom domain (module.nix_cache)

# Cloudflare Tunnel for B450M-Pro4
resource "cloudflare_zero_trust_tunnel_cloudflared" "b450m_pro4" {
  account_id    = var.cloudflare_account_id
  name          = "B450M-Pro4"
  tunnel_secret = var.tunnel_secret
}

resource "cloudflare_dns_record" "record" {
  for_each = local.records
  zone_id  = local.zone_id
  comment  = try(each.value.comment, null)
  content  = try(each.value.content, null)
  data     = try(each.value.data, null)
  name     = each.value.name
  priority = try(each.value.priority, null)
  proxied  = each.value.proxied
  ttl      = try(each.value.ttl, 1)
  type     = each.value.type
}
