locals {
  notification_email = "hi@yutakobayashi.com"

  notification_policies = {
    expiring_access_service_token = {
      alert_type  = "expiring_service_token_alert"
      name        = "Expiring Access Service Token Alert"
      description = "Cloudflare Access service token expiration notice, sent 7 days before token expires"
    }
    passive_origin_monitoring = {
      alert_type  = "real_origin_monitoring"
      name        = "Passive Origin Monitoring"
      description = "Cloudflare is unable to reach your origin"
    }
    web_analytics = {
      alert_type  = "web_analytics_metrics_update"
      name        = "Web Analytics Metrics Update"
      description = "Receive regular Web Analytics metrics updates by email"
    }
    # Avoid unnoticed Images Transformations spikes from crawlers hitting Next.js image optimization URLs.
    # Context: https://twitter.com/unvalley_/status/2050212616119939084
    image_resizing = {
      alert_type  = "image_resizing_notification"
      name        = "Image Transformation Quota Alert"
      description = "Receive an alert about Cloudflare Images transformation quota exhaustion"
    }
  }

  k = 1000
  m = 1000 * local.k

  # Cloudflare R2 storage limits use base-2 units: 1 GiB = 2^30 bytes = 1024^3 bytes.
  # https://developers.cloudflare.com/r2/platform/limits/
  gib = 1024 * 1024 * 1024

  r2_storage_free_tier            = 10 * local.gib
  r2_class_a_operations_free_tier = 1 * local.m
  r2_class_b_operations_free_tier = 10 * local.m
  d1_rows_read_included_tier      = 25 * 1000 * local.m

  discord_status_webhook_url_parts = split("/", data.terraform_remote_state.discord.outputs.status_webhook_url)

  r2_usage_alert_thresholds = [
    10, 20, 30, 40, 50, 60, 70, 80, 90, 95,
    100, 125, 150, 200, 300, 500, 1000, 2000, 3000,
  ]
  d1_rows_read_alert_thresholds = [50, 80, 100, 150, 200]

  billing_usage_notification_policies = merge(
    {
      for threshold in local.r2_usage_alert_thresholds :
      "r2_storage_${threshold}" => {
        name        = "R2 Storage - ${threshold}% of Free Tier"
        description = "Alert when R2 storage usage reaches ${threshold}% of the 10 GiB free tier"
        limit       = tostring(floor(local.r2_storage_free_tier * threshold / 100))
        product     = "r2_storage"
      }
    },
    {
      for threshold in local.r2_usage_alert_thresholds :
      "r2_class_a_${threshold}" => {
        name        = "R2 Class A Operations - ${threshold}% of Free Tier"
        description = "Alert when R2 Class A operations reach ${threshold}% of the 1M requests free tier"
        limit       = tostring(floor(local.r2_class_a_operations_free_tier * threshold / 100))
        product     = "r2_class_a_operations"
      }
    },
    {
      for threshold in local.r2_usage_alert_thresholds :
      "r2_class_b_${threshold}" => {
        name        = "R2 Class B Operations - ${threshold}% of Free Tier"
        description = "Alert when R2 Class B operations reach ${threshold}% of the 10M requests free tier"
        limit       = tostring(floor(local.r2_class_b_operations_free_tier * threshold / 100))
        product     = "r2_class_b_operations"
      }
    },
    {
      for threshold in local.d1_rows_read_alert_thresholds :
      "d1_rows_read_${threshold}" => {
        name        = "D1 Rows Read - ${threshold}% of Included Tier"
        description = "Alert when D1 rows read reach ${threshold}% of the 25B rows monthly included tier"
        limit       = tostring(floor(local.d1_rows_read_included_tier * threshold / 100))
        product     = "d1_rows_read"
      }
    }
  )
}

resource "cloudflare_notification_policy_webhooks" "discord_status" {
  account_id = var.cloudflare_account_id
  name       = "Discord Status"
  url        = nonsensitive(join("/", slice(local.discord_status_webhook_url_parts, 0, 6)))
  secret     = local.discord_status_webhook_url_parts[6]
}

resource "cloudflare_notification_policy" "this" {
  for_each = local.notification_policies

  account_id  = var.cloudflare_account_id
  alert_type  = each.value.alert_type
  name        = each.value.name
  description = each.value.description
  mechanisms = {
    email = [{
      id = local.notification_email
    }]
    webhooks = [{
      id = cloudflare_notification_policy_webhooks.discord_status.id
    }]
  }
}

resource "cloudflare_notification_policy" "tunnel_health" {
  account_id  = var.cloudflare_account_id
  alert_type  = "tunnel_health_event"
  name        = "Tunnel Health Alert"
  description = "Receive an alert when tunnel becomes degraded or down"
  mechanisms = {
    email = [{
      id = local.notification_email
    }]
    webhooks = [{
      id = cloudflare_notification_policy_webhooks.discord_status.id
    }]
  }
  filters = {
    tunnel_id = [
      module.yutakobayashi_com.b450m_pro4_tunnel_id,
    ]
    new_status = [
      "TUNNEL_STATUS_TYPE_DEGRADED",
      "TUNNEL_STATUS_TYPE_DOWN",
    ]
  }
}

resource "cloudflare_notification_policy" "billing_usage" {
  for_each = local.billing_usage_notification_policies

  account_id  = var.cloudflare_account_id
  alert_type  = "billing_usage_alert"
  name        = each.value.name
  description = each.value.description
  mechanisms = {
    email = [{
      id = local.notification_email
    }]
    webhooks = [{
      id = cloudflare_notification_policy_webhooks.discord_status.id
    }]
  }
  filters = {
    limit = [
      each.value.limit,
    ]
    product = [
      each.value.product,
    ]
  }
}
