# Cloudflare Budget Alerts

Cloudflare budget alerts are managed through the Cloudflare Alerting API, not
OpenTofu.

The Cloudflare provider used by this repository supports
`cloudflare_notification_policy` for `billing_usage_alert`, but it does not
currently expose `billing_budget_alert` or the required
`total_spend_dollars` filter. Keep these alerts API-managed until the provider
schema supports both fields.

## Managed Alerts

| Name                       | Threshold | Policy ID                          | Recipient               |
| -------------------------- | --------- | ---------------------------------- | ----------------------- |
| Billing Budget Alert $1    | $1        | `21cc4c13a97e4fb5b0a400fa69fc7f16` | `hi@yutakobayashi.com` |
| Billing Budget Alert $5    | $5        | `cbdeeef616d44ef197baa5c3b892d8ee` | `hi@yutakobayashi.com` |
| Billing Budget Alert $20   | $20       | `353f9d6e1727438cb70f431480e9d2ac` | `hi@yutakobayashi.com` |

## Related Usage Alerts

Per-product usage alerts are managed with OpenTofu in
`infra/global/notification_policies.tf`.

| Name                                      | Product                 | Limit                 |
| ----------------------------------------- | ----------------------- | --------------------- |
| R2 Storage free tier percentage alerts    | `r2_storage`            | 80-3000% of 10 GiB    |
| R2 Class A free tier percentage alerts    | `r2_class_a_operations` | 80-3000% of 1M requests |
| R2 Class B free tier percentage alerts    | `r2_class_b_operations` | 80-3000% of 10M requests |
| D1 rows read included tier percentage alerts | `d1_rows_read`       | 50-200% of 25B rows   |

The managed thresholds are `80`, `100`, `150`, `200`, `300`, `500`, `1000`,
and `3000` percent of each R2 free tier. Low thresholds below 80% are omitted to
avoid noisy early-cycle alerts.

R2 storage thresholds use base-2 units. `1 GiB` is `2^30` bytes, or `1024^3`
bytes, so `10 GiB` is `10 * 1024 * 1024 * 1024` bytes. This matches
Cloudflare's R2 limits documentation:
<https://developers.cloudflare.com/r2/platform/limits/>.

This unit convention is product-specific. Some other Cloudflare products, such
as Durable Objects, may calculate storage or usage limits with decimal `GB`
units instead of binary `GiB` units.

D1 rows read alerts use the Workers Paid monthly included tier of 25 billion
rows as the baseline. The managed thresholds are `50`, `80`, `100`, `150`, and
`200` percent to catch costly query patterns without creating too many alerts.

These OpenTofu-managed notification policies deliver to
`hi@yutakobayashi.com` and the Discord `status` channel webhook managed by the
`discord` workspace.

Cloudflare Images Transformations are not accepted as a `billing_usage_alert`
product filter. The Images-specific `image_resizing_notification` policy is
managed instead to catch transformation quota exhaustion, which is the failure
mode caused by crawlers repeatedly hitting Next.js `/_next/image` URLs.

## How They Work

Budget alerts notify when account-wide usage-based spend crosses the configured
dollar threshold during the current billing period. They are informational only;
they do not pause traffic, cap usage, or prevent charges.

## Verify

```bash
account_id=$(sed -n 's/^cloudflare_account_id[[:space:]]*=[[:space:]]*"\(.*\)"/\1/p' infra/global/terraform.tfvars)
api_token=$(sed -n 's/^cloudflare_api_token[[:space:]]*=[[:space:]]*"\(.*\)"/\1/p' infra/global/terraform.tfvars)

curl -fsS \
  -H "Authorization: Bearer $api_token" \
  "https://api.cloudflare.com/client/v4/accounts/$account_id/alerting/v3/policies" \
  | jq '[.result[] | select(.alert_type == "billing_budget_alert") | {id, name, enabled, filters, mechanisms}]'
```

## Update

Use the Cloudflare dashboard at **Manage Account > Billing > Billable Usage >
Budget alerts**, or update the policy through the Alerting API.

When updating through the API, keep the same `billing_budget_alert` alert type
and set `filters.total_spend_dollars` to the desired threshold.

## Migration To OpenTofu

When the Cloudflare provider supports `billing_budget_alert` and
`total_spend_dollars`, move these policies into
`infra/global/notification_policies.tf` and import the existing policy IDs into
state.

Relevant Cloudflare docs:

- https://developers.cloudflare.com/billing/manage/budget-alerts/
- https://developers.cloudflare.com/billing/manage/billable-usage/
- https://developers.cloudflare.com/api/resources/alerting/index.md
