---
description: "Build a Hawker Stall Licence Renewal form step by step, from fields to publication."
icon: wand-magic-sparkles
---

# Create your first form

📄 Tutorial · Updated: 21 Oct 2026 · Freshness: ✅ Current

In this walkthrough you build a **Hawker Stall Licence Renewal** form for a fictional agency. It takes about 30 minutes.

{% stepper %}
{% step %}
## Start from the Licence renewal template

In **Forms → Create new form**, choose **Licence renewal**. Name it `Hawker Stall Licence Renewal` and keep the default lifecycle.
{% endstep %}

{% step %}
## Review the pre-built pages

The template creates three pages:

1. **Applicant details** — pre-filled from Myinfo (name, NRIC, contact)
2. **Licence details** — licence number, stall location, expiry date
3. **Declaration and submit**
{% endstep %}

{% step %}
## Add a file upload

On *Licence details*, drag a **File upload** field named `Food hygiene certificate`. Set **Accepted types** to PDF and JPG, **Max size** to 5 MB and mark it **Required**.
{% endstep %}

{% step %}
## Add a conditional section

Add a **Yes/No** field `Has the stall changed hands?`. Then add a section `New licensee details` and set its visibility rule:

```text
WHEN licence.changed_hands == "Yes" THEN show section "New licensee details"
```

Rules are covered in depth in [Conditional logic](https://app.gitbook.com/s/XSPACE_ADVANCED/logic/conditional-logic).
{% endstep %}

{% step %}
## Configure the review stage

Open the **Lifecycle** tab. On the *Under review* stage, assign the **Licensing officers** team as approvers and set an SLA of **7 working days**.
{% endstep %}

{% step %}
## Preview as a test applicant

Select **Preview** and sign in as `S9000001A`. Submit a test application and confirm it appears in the **Case console** under *Submitted*.
{% endstep %}

{% step %}
## Publish

Select **Publish**. If you are a Requestor, this raises a publish request to your Admin. Once approved, the form is live at `https://apply.gov.sg/nea/hawker-stall-licence-renewal`.
{% endstep %}
{% endstepper %}

## What you built

{% columns %}
{% column %}
### Applicant experience

* Signs in with Singpass
* Sees pre-filled personal details
* Uploads one certificate
* Receives an SMS and email with reference `ASG-2026-004512`
{% endcolumn %}

{% column %}
### Officer experience

* New case appears in the console
* SLA timer starts at 7 working days
* Can approve, reject or request clarification
* Approval generates a PDF licence letter automatically
{% endcolumn %}
{% endcolumns %}

{% hint style="info" %}
Everything you configured here is also available through the REST API, so a developer can version-control the form definition. See [API Specs](https://app.gitbook.com/s/XSPACE_API/).
{% endhint %}
