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
| R2 Storage free tier percentage alerts    | `r2_storage`            | 80-3000% of 10 GB     |
| R2 Class A free tier percentage alerts    | `r2_class_a_operations` | 80-3000% of 1M requests |
| R2 Class B free tier percentage alerts    | `r2_class_b_operations` | 80-3000% of 10M requests |
| D1 rows read included tier percentage alerts | `d1_rows_read`       | 50-200% of 25B rows   |

The managed thresholds are `80`, `100`, `150`, `200`, `300`, `500`, `1000`,
and `3000` percent of each R2 free tier. Low thresholds below 80% are omitted to
avoid noisy early-cycle alerts.

R2 storage thresholds are bytes in decimal units: the free tier is
`10 GB-month`, and `1 GB` is `10^9` bytes, so `10 GB` is `10 * 1000^3` bytes.

- The `limit` filter is in bytes. Fired alerts report
  `"unit_of_measure": "Bytes of Storage"`.
- The free tier is stated in `GB` on the R2 pricing page. The R2 limits page
  defines `GB` as `10^9` bytes and uses binary units only for limits written in
  `MiB`, `GiB`, or `TiB`:
  <https://developers.cloudflare.com/r2/platform/limits/>.
- Billing and the byte-based alerts agree only in decimal units. From
  2026-11-01 to 2026-11-09, Billable Usage shows R2 storage accruing about
  `13.03 GB-months` per day. At `13.03 * 10^9` bytes per day, the 500%
  (`53687091200` bytes) and 1000% (`107374182400` bytes) thresholds of the
  former binary configuration are crossed on 2026-11-05 and 2026-11-09, the
  dates those alerts fired. At `13.03 * 2^30` bytes per day, they would have
  been crossed one day earlier.

R2 storage alerts accumulate the daily peak storage divided by 30 from the
first day of the calendar month, not from the start of the billing period.
In November 2026, the 80% to 1000% alerts fired between 2026-11-01 and
2026-11-09, while the billing period started on 2026-11-10.

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
account_id=$(op read op://Personal/tofu-configuration-global/cloudflare_account_id)
api_token=$(op read op://Personal/tofu-configuration-global/cloudflare_api_token)

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

`cloudflare_notification_policy.billing_budget` in
`infra/global/notification_policies.tf` declares these three policies. It is
blocked until the provider supports `billing_budget_alert` and the
`total_spend_dollars` filter
(cloudflare/terraform-provider-cloudflare#7438, expected in v5.30.0). The
resource fails `tofu validate` on v5.28.1/v5.29.0, so this is held in a draft
PR until the release lands.

Once the provider release is available:

1. `tofu -chdir=infra/global init -upgrade`
2. Import each existing policy (import ID is `<account_id>/<policy_id>`):

   ```sh
   tofu -chdir=infra/global import 'cloudflare_notification_policy.billing_budget["1"]' '<account_id>/21cc4c13a97e4fb5b0a400fa69fc7f16'
   tofu -chdir=infra/global import 'cloudflare_notification_policy.billing_budget["5"]' '<account_id>/cbdeeef616d44ef197baa5c3b892d8ee'
   tofu -chdir=infra/global import 'cloudflare_notification_policy.billing_budget["20"]' '<account_id>/353f9d6e1727438cb70f431480e9d2ac'
   ```

3. `tofu -chdir=infra/global plan` should show no diff, then `apply`.

Relevant Cloudflare docs:

- https://developers.cloudflare.com/billing/manage/budget-alerts/
- https://developers.cloudflare.com/billing/manage/billable-usage/
- https://developers.cloudflare.com/api/resources/alerting/index.md
