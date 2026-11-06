---
description: "Cursor-based pagination and the query parameters shared by list endpoints."
icon: list
---

# Pagination and filtering

📄 Guide · Updated: 14 Oct 2026 · Freshness: ✅ Current

All list endpoints (`/forms`, `/submissions`, `/workspace/audit-events`, `/webhooks/{id}/deliveries`) return **cursor-paginated** results.

## Parameters

| Parameter | Type | Default | Notes |
| --- | --- | --- | --- |
| `limit` | integer | 50 | 1–200 |
| `cursor` | string | — | Opaque; pass the previous page's `next_cursor` |
| `updated_since` | date-time | — | Submissions only; ideal for incremental sync |
| `stage` | string | — | Submissions only; lifecycle stage key such as `under_review` |
| `form_id` | string | — | Submissions only |

## Walking pages

{% tabs %}
{% tab title="curl" %}
```bash
curl "https://api.sandbox.apply.gov.sg/v1/submissions?limit=100&updated_since=2026-10-01T00:00:00Z" \
  -H "Authorization: Bearer $TOKEN"
# … then
curl "https://api.sandbox.apply.gov.sg/v1/submissions?limit=100&cursor=eyJpZCI6InN1Yl8wMUhYIn0" \
  -H "Authorization: Bearer $TOKEN"
```
{% endtab %}

{% tab title="Node.js" %}
```javascript
let cursor;
do {
  const url = new URL("https://api.sandbox.apply.gov.sg/v1/submissions");
  url.searchParams.set("limit", "100");
  if (cursor) url.searchParams.set("cursor", cursor);
  const page = await (await fetch(url, { headers })).json();
  page.data.forEach(process);
  cursor = page.next_cursor;
} while (cursor);
```
{% endtab %}
{% endtabs %}

`next_cursor` is `null` on the last page. Cursors are valid for 15 minutes.

## Incremental sync pattern

{% hint style="success" %}
For a nightly sync, store the `updated_at` of the newest submission you processed and pass it as `updated_since` next time. Combine with [webhooks](https://app.gitbook.com/s/XSPACE_INTEGRATOR/patterns/webhooks) for near-real-time updates and use the sync as a reconciliation safety net.
{% endhint %}
