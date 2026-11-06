---
description: "Attachments, generated letters, exports, retention and data classification in ApplySG."
icon: chart-column
---

# Documents and Data

📄 Guide · Updated: 30 Sep 2026 · Freshness: ✅ Current

## Attachments

Applicants can upload files to **File upload** fields. Every file is virus-scanned before an officer can open it.

| Limit | Value |
| --- | --- |
| Max file size | 25 MB per file (configurable down per field) |
| Max files per submission | 20 |
| Accepted types | PDF, JPG, PNG, DOCX, XLSX (allowlist per field) |
| Scan outcome | `clean`, `infected` (file quarantined, applicant asked to re-upload) |

## Generated documents

Lifecycle actions can generate a PDF from a **document template**, for example an approval letter or a licence certificate.

{% tabs %}
{% tab title="Template" %}
```text
Dear {{ applicant.name }},

Your application {{ submission.reference }} for {{ form.name }}
was approved on {{ submission.approved_at | date("D MMM YYYY") }}.

Licence number: {{ fields.licence_number }}
Valid until:    {{ fields.expiry_date | date("D MMM YYYY") }}
```
{% endtab %}

{% tab title="Where it goes" %}
* Attached to the submission and visible to the applicant on the portal
* Emailed as a PDF if **Send on generate** is on
* Available to integrations at `GET /submissions/{id}/documents`
{% endtab %}
{% endtabs %}

Templates support a digital signature image and the agency letterhead uploaded under **Settings → Branding**.

## Exports

{% stepper %}
{% step %}
## One-off export

In the **Case console**, filter the list, then choose **Export → CSV** or **JSON**. Exports include all fields, stage history and attachment links (valid for 24 hours).
{% endstep %}

{% step %}
## Scheduled export

Admins can schedule daily or weekly exports to an agency bucket. See [Exporting submissions](https://app.gitbook.com/s/XSPACE_INTEGRATOR/patterns/exporting-submissions) in the Integrator Guide.
{% endstep %}
{% endstepper %}

## Retention

| Data | Default retention | Configurable? |
| --- | --- | --- |
| Draft submissions (not submitted) | 90 days, then deleted | Yes, 30–180 days |
| Submitted cases | 7 years after closure | Yes, 1–10 years |
| Attachments | Same as parent submission | No |
| Audit log | 7 years | No |

{% hint style="danger" %}
Deleting a submission after retention is **permanent**. ApplySG keeps only the reference number and the deletion timestamp in the audit log.
{% endhint %}

## Data classification

ApplySG is approved for data classified up to **Restricted / Sensitive-Normal**. Forms that need to collect Confidential or Sensitive-High data must go through your agency's security review before publishing. The builder asks for the classification when you publish, and the choice is recorded on the form.

Full detail on hosting, encryption and compliance is in [Data residency and security](https://app.gitbook.com/s/XSPACE_ADVANCED/scale/data-residency-and-security).
