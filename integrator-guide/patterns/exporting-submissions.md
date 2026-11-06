---
description: "Pull submissions from ApplySG on demand through the paginated export API, or schedule recurring exports to an agency GCC bucket."
icon: file-export
---

# Exporting submissions

📄 Guide · Updated: 16 Oct 2026 · Freshness: ✅ Current

Agencies export submissions to feed data warehouses, case-management systems and statutory reporting. <code class="expression">space.vars.product_name</code> supports two approaches: **on-demand export** through the REST API and **scheduled export** to an S3-compatible bucket in the Government Commercial Cloud (GCC). Both require the `submissions:read` scope.

{% hint style="warning" %}
**Data classification.** ApplySG is accredited for data up to **Restricted / Sensitive-Normal**. Exports inherit the classification of the form. Your destination system and bucket must be accredited to at least the same level, and you remain responsible for retention and disposal under your agency's records schedule.
{% endhint %}

## On-demand export

The export endpoint returns submissions page by page, filtered by form, stage and date range. Results are ordered by `updated_at` ascending so you can resume from where you left off.

```
GET /forms/{form_id}/submissions/export
```

| Parameter | Description |
| --- | --- |
| `format` | `json` (default) or `csv` |
| `updated_after` | ISO 8601 timestamp; return submissions updated after this time |
| `stage` | Filter by current lifecycle stage key, for example `approved` |
| `include_attachments` | `true` returns pre-signed attachment URLs valid for 15 minutes |
| `page_size` | 1–500, default 100 |
| `cursor` | Opaque cursor from the previous page's `next_cursor` |

{% tabs %}
{% tab title="curl" %}
```bash
curl "https://api.apply.gov.sg/v1/forms/frm_01HXK2D8P6M4R1S7Q9W3E5T2AB/submissions/export?format=json&updated_after=2026-10-01T00:00:00Z&page_size=200" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "ApplySG-Version: 2026-10"
```
{% endtab %}

{% tab title="Node.js" %}
```javascript
async function* exportSubmissions(formId, updatedAfter) {
  let cursor;
  do {
    const url = new URL(`https://api.apply.gov.sg/v1/forms/${formId}/submissions/export`);
    url.searchParams.set('updated_after', updatedAfter);
    url.searchParams.set('page_size', '200');
    if (cursor) url.searchParams.set('cursor', cursor);

    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${token}`, 'ApplySG-Version': '2026-10' },
    });
    const page = await res.json();
    yield* page.items;
    cursor = page.next_cursor;
  } while (cursor);
}
```
{% endtab %}

{% tab title="Python" %}
```python
def export_submissions(session, form_id, updated_after):
    cursor = None
    while True:
        params = {"updated_after": updated_after, "page_size": 200}
        if cursor:
            params["cursor"] = cursor
        page = session.get(
            f"https://api.apply.gov.sg/v1/forms/{form_id}/submissions/export",
            params=params,
            headers={"ApplySG-Version": "2026-10"},
            timeout=30,
        ).json()
        yield from page["items"]
        cursor = page.get("next_cursor")
        if not cursor:
            break
```
{% endtab %}
{% endtabs %}

A JSON page looks like this:

```json
{
  "items": [
    {
      "id": "sub_01HXQ6Z1R2P7K4W9E3M8N5T0CV",
      "form_id": "frm_01HXK2D8P6M4R1S7Q9W3E5T2AB",
      "reference": "GA-2026-004417",
      "stage": "approved",
      "submitted_at": "2026-10-03T06:41:09Z",
      "updated_at": "2026-10-07T02:15:33Z",
      "fields": { "applicant_uen": "201912345K", "requested_amount": 25000 },
      "attachments": []
    }
  ],
  "next_cursor": "eyJ1cGRhdGVkX2F0IjoiMjAyNi0xMC0wN1QwMjoxNTozM1oifQ",
  "total_estimate": 1842
}
```

CSV export flattens `fields` into one column per field key and writes repeating groups as numbered columns (`members_1_name`, `members_2_name`). Columns follow the order defined in the form builder.

## Scheduled export to GCC

For regular bulk transfers, configure a scheduled export in the workspace under **Settings → Integrations → Scheduled exports**. ApplySG writes files to an S3-compatible bucket you own in GCC.

{% stepper %}
{% step %}
## Prepare the bucket
Create a bucket in your agency's GCC account with server-side encryption enabled. Create an access key with `PutObject` and `ListBucket` permissions on a dedicated prefix, for example `applysg/`.
{% endstep %}

{% step %}
## Configure the export
An Admin enters the bucket endpoint, region, prefix and access key, selects the forms and stages to include, and chooses a cadence: hourly, daily at a set time (SGT), or weekly.
{% endstep %}

{% step %}
## Validate
ApplySG writes a `_connection_test.json` object immediately. If this fails, the credentials or network path (GCC private endpoint) need attention before the schedule starts.
{% endstep %}

{% step %}
## Monitor
Each run writes a manifest (`applysg/grant-application/2026-10-16T18-00Z/manifest.json`) listing files, row counts and the SHA-256 of each file. Failed runs are retried once after 15 minutes and then reported in the technical contact's digest.
{% endstep %}
{% endstepper %}

Scheduled exports are incremental by default: each run contains submissions updated since the previous successful run. Select **Full snapshot** for a complete copy, typically weekly.

<details>
<summary>How are attachments exported?</summary>

On-demand exports return pre-signed URLs; scheduled exports copy the files themselves into `attachments/{submission_id}/{file_id}-{original_name}` alongside the data file. Attachments are virus-scanned on upload and carry an `x-amz-meta-applysg-scan: clean` tag.

</details>

{% hint style="info" %}
Exports are read-only. To write data back, for example to move a submission after an external check completes, use the submission endpoints with `submissions:write` as documented in the [API Specs](https://app.gitbook.com/s/XSPACE_API/).
{% endhint %}
