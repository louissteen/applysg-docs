---
description: "Where ApplySG data lives, how it is classified, encrypted, logged and retained, and what solution owners must do to meet IM8 and DPIA obligations."
icon: shield-halved
---

# Data residency and security

📄 Guide · Updated: 14 Oct 2026 · Freshness: ✅ Current

<code class="expression">space.vars.product_name</code> is a whole-of-government platform, so most security controls are inherited by every service hosted on it. This page sets out what the platform provides and what remains the responsibility of the agency solution owner.

{% hint style="info" %}
This page summarises the platform position for configurators. The authoritative statements are the ApplySG System Security Plan and the current IM8 assessment report, both available to agency CIO offices on request through <code class="expression">space.vars.support_email</code>.
{% endhint %}

## Platform controls at a glance

| Area | Platform position |
| --- | --- |
| **Hosting** | Government Commercial Cloud (GCC), Singapore region only. No data is stored or processed outside Singapore. |
| **Data classification** | Services may hold data classified up to **Restricted** and **Sensitive-Normal**. Confidential or Sensitive-High data must not be collected through ApplySG. |
| **Encryption in transit** | TLS 1.2 or higher on all applicant, officer and API connections. Internal service-to-service traffic is mutually authenticated. |
| **Encryption at rest** | AES-256 on all databases, object storage and backups, with keys managed in the GCC key management service and rotated annually. |
| **Authentication** | Officers and configurators sign in through TechPass SSO with multi-factor authentication. Applicants sign in through Singpass or Corppass, or use a verified email link for services that permit it. |
| **Audit logging** | Every read and write of a submission by an officer, every configuration change and every automation run is logged with actor, agency, timestamp and source. Logs are immutable and retained for **7 years**. |
| **Backups** | Daily encrypted backups retained for 35 days, within the same region. Restore drills are performed quarterly. |
| **Vulnerability management** | Monthly scans and an annual independent penetration test, with findings tracked to closure under IM8 timelines. |
| **Availability** | Target 99.9 per cent monthly for the applicant portal, with planned maintenance announced seven days ahead. |

{% hint style="warning" %}
Classification is set per service by the solution owner and is enforced at publication. A service marked **Restricted / Sensitive-Normal** that attempts to add a file upload field without malware scanning, or a free-text field labelled with a term associated with Sensitive-High data (for example, "diagnosis"), is blocked from publishing until the solution owner confirms the classification. Misclassifying a service is a reportable incident under IM8.
{% endhint %}

## Shared responsibility

{% columns %}
{% column %}
### Platform (GovTech ApplySG team)
- Infrastructure, patching and hardening on GCC
- Encryption, key management and backups
- Identity integration with TechPass, Singpass and Corppass
- Platform-wide audit logging and retention
- Annual IM8 assessment and penetration test
{% endcolumn %}
{% column %}
### Agency solution owner
- Correct data classification of the service
- Minimising fields collected to what the service needs
- Role assignments and periodic access review
- Data-sharing agreements for [multi-agency workflows](multi-agency-workflows.md)
- Retention settings and the DPIA for the service
- Registering and securing agency endpoints used by webhooks and async validation
{% endcolumn %}
{% endcolumns %}

## Retention

Submission data is retained according to a schedule set per service.

| Data | Default | Configurable range |
| --- | --- | --- |
| Expired drafts | 30 days after last edit | 7 to 90 days |
| Closed submissions | 5 years after closure | 1 to 10 years, or per agency records schedule |
| Uploaded files | Same as the submission | Can be shorter than the submission record |
| Audit log | 7 years | Not configurable |
| Analytics events | 3 years | Not configurable; contains no personal data |

When retention expires, records are deleted from live storage immediately and from backups within 35 days. A certificate of deletion can be generated from the **Compliance** tab for the agency's records.

## DPIA guidance

A Data Protection Impact Assessment is expected for every new service and for material changes to an existing one, such as adding a participating agency or a new category of personal data.

{% stepper %}
{% step %}
## Start from the platform template
Download the ApplySG DPIA template from the **Compliance** tab. The platform sections (hosting, encryption, logging, identity) are pre-filled and reference the current assessment report.
{% endstep %}
{% step %}
## Describe the service-specific processing
List each field that holds personal data, why it is needed, who sees it (by role and agency) and how long it is retained. The **Field inventory** export from the builder produces this list.
{% endstep %}
{% step %}
## Assess automation and sharing
Document any webhook, async validation or export destination, and any [multi-agency](multi-agency-workflows.md) visibility matrix. Include the data-sharing agreement reference.
{% endstep %}
{% step %}
## Obtain sign-off and attach
Your agency data protection officer signs off. Attach the completed DPIA under **Compliance** before publishing; the platform records the DPIA reference against the published version.
{% endstep %}
{% endstepper %}

## Incident reporting

Suspected incidents, including misclassification, unexpected access in the audit log or an applicant reporting another person's data, must be reported to the agency's IT security officer and to the ApplySG team within the IM8 timelines. The **Compliance** tab provides a one-click **Freeze service** control that blocks new submissions and officer edits while an incident is investigated; it does not affect data already stored.

<details><summary>Frequently asked questions</summary>

**Can we host a service on our own agency cloud instead?**
No. ApplySG is operated only on GCC in Singapore. Agencies needing a different hosting arrangement should discuss alternatives with GovTech.

**Can officers access ApplySG from outside Singapore?**
Officer access follows your agency's TechPass policy. The platform itself does not restrict by location, but all access is logged with source network.

**Is applicant data ever used to train AI models?**
No. Submission content is not used for model training or product analytics. See [Analytics and reporting](analytics-and-reporting.md) for what the event stream does contain.

</details>
