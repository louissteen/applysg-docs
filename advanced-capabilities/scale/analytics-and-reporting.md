---
description: "Use the built-in dashboards, export events to agency BI tools and report on service performance without exposing applicant data."
icon: chart-line
---

# Analytics and reporting

📄 Guide · Updated: 07 Oct 2026 · Freshness: ✅ Current

Every service on <code class="expression">space.vars.product_name</code> records a stream of events: a page viewed, a field changed, a submission made, a stage entered, a notification delivered. The analytics area turns those events into dashboards for solution owners and into exports for agency business intelligence teams.

## Built-in dashboards

Dashboards are available from the **Analytics** tab of a service to anyone with the **Solution owner** or **Analyst** role. Date ranges default to the last 30 days and can be set to any range since the service was first published.

| Dashboard | What it shows | Typical question it answers |
| --- | --- | --- |
| **Volume** | Submissions per day, week or month, split by stage reached and by channel (web, mobile, assisted). | Are we ready for the peak before the licence renewal deadline? |
| **Processing time** | Median and 90th percentile time from **Submitted** to each decision stage, in working days, against the SLA target. | Are we meeting our published service standard? |
| **Drop-off per page** | Applicants who start each page and the share who do not reach the next one. | Which page is losing applicants? |
| **Validation failures** | Most frequent validation messages and the field they fire on. | Is a rule or an instruction confusing applicants? |
| **Officer workload** | Open cases per queue and per officer, with SLA risk. | Do we need to rebalance queues? |
| **Notifications** | Sent, delivered, bounced and failed by channel. | Are our SMS reaching applicants? |

{% hint style="info" %}
Processing time uses the SLA clock defined in [Workflow automation](../automation/workflow-automation.md), so time paused while waiting on the applicant is excluded if the timer is configured that way. The dashboard states which clock it is using.
{% endhint %}

## Reading the drop-off dashboard

{% columns %}
{% column %}
### What the numbers mean
Drop-off is measured per **page**, not per session. An applicant who leaves on page 3 and returns the next day to finish is not counted as a drop-off. Only drafts untouched for 14 days count.
{% endcolumn %}
{% column %}
### Acting on it
A page with drop-off above 15 per cent usually has one of three problems: a document the applicant does not have to hand, a validation rule that is too strict, or instructions that are unclear. Check the validation failures dashboard for that page first.
{% endcolumn %}
{% endcolumns %}

## Exporting to agency BI

Agencies that run their own reporting (for example, in Tableau or Power BI on GCC) can receive the event stream rather than rebuilding dashboards by hand.

{% tabs %}
{% tab title="Scheduled export" %}
Create a [scheduled action](../automation/scheduled-actions.md) with the action **Export events**. Choose the event types, the date window (normally "since last run") and a registered destination. Files are CSV or newline-delimited JSON, one row per event, with a stable schema versioned in the [API Specs](https://app.gitbook.com/s/XSPACE_API/).
{% endtab %}
{% tab title="API" %}
Poll the `/services/{serviceId}/events` endpoint with a cursor. The endpoint returns the same event schema as the export and is rate-limited to 10 requests per minute per service. Use it for near-real-time dashboards; use scheduled export for bulk history.
{% endtab %}
{% endtabs %}

## Event list

| Event | Emitted when | Key attributes |
| --- | --- | --- |
| `form.page_viewed` | Applicant opens a page | `page_key`, `channel`, `session_hash` |
| `form.field_changed` | Applicant changes a value | `field_key` (no value) |
| `form.validation_failed` | A `block` or `warn` rule fires | `rule_name`, `field_key`, `severity` |
| `submission.created` | Draft saved for the first time | `submission_id` |
| `submission.submitted` | Applicant submits | `submission_id`, `version` |
| `stage.entered` / `stage.exited` | Lifecycle transition | `stage`, `actor_type`, `actor_agency` |
| `automation.ran` | Automation or scheduled action completes | `automation_id`, `outcome` |
| `notification.sent` / `notification.delivered` / `notification.failed` | Channel delivery status | `channel`, `template_id` |
| `sla.warned` / `sla.breached` | Timer thresholds reached | `timer_id`, `stage` |
| `export.completed` | A scheduled export finishes | `rows`, `destination` |

## Privacy

{% hint style="warning" %}
Analytics events are designed to carry **no applicant personal data**. Field change events record which field changed, never the value. Session identifiers are salted hashes that rotate daily and cannot be joined back to a person. Do not attempt to re-identify applicants from analytics exports; doing so is outside the purpose for which the data was collected.
{% endhint %}

Dashboards aggregate across at least **five** submissions before showing a figure. A filter that narrows to fewer than five shows "Insufficient data" rather than a number. If you need case-level reporting (for example, a list of overdue cases with reference numbers), use the submissions inbox export, which is governed by the stricter access controls described in [Data residency and security](data-residency-and-security.md).

<details><summary>Sharing dashboards outside the service team</summary>

Dashboards can be shared as a read-only snapshot link that expires after 30 days. Snapshots carry the same aggregation threshold and are suitable for monthly reporting to agency management. For whole-of-government reporting, GovTech publishes an aggregated cross-service view; contact <code class="expression">space.vars.support_email</code> to have a service included.

</details>
