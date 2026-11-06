---
description: "This is a tutorial. By the end, you will have created your first form-based workflow and published it to the ApplySG portal."
icon: rocket
tags:
  - tag: validated
    primary: true
  - tutorial
---

# Get Started with ApplySG

📄 Tutorial · Updated: 28 Oct 2026 · Freshness: ✅ Current

{% hint style="info" %}
This is a tutorial. By the end, you will have created your first form-based workflow and published it to the ApplySG portal.
{% endhint %}

ApplySG is a no-code platform that lets agencies configure and operate form-based workflows. This guide walks you through setup from scratch.

## Before you begin

You will need a TechPass account and the **Requestor** or **Admin** role on your agency's ApplySG workspace. See [Prerequisites](get-started/prerequisites.md) for the full checklist.

## Steps

{% stepper %}
{% step %}
## Sign in to the portal

Sign in to [apply.gov.sg](https://apply.gov.sg) with your TechPass credentials. You will land on the **Workspaces** screen.
{% endstep %}

{% step %}
## Select your agency workspace

Select your agency workspace. If it is not listed, contact your agency admin to be added — see [Access and Permissions](../core-features/access-and-permissions.md).
{% endstep %}

{% step %}
## Create a new form

Go to **Forms** and select **Create new form**.
{% endstep %}

{% step %}
## Choose a template or start from blank

Choose a template (for example *Licence application* or *Grant request*) or start from blank. Name your form and set the lifecycle stage. The default lifecycle is `Draft → Submitted → Under review → Approved / Rejected → Closed`.
{% endstep %}

{% step %}
## Add fields

Drag fields from the palette onto the canvas. Every template already includes the **Applicant details** block, which is pre-filled from Singpass Myinfo when the applicant signs in.
{% endstep %}

{% step %}
## Preview and publish

Select **Preview** to test the form as an applicant would see it, then **Publish**. Your form is live at `https://apply.gov.sg/<agency>/<form-slug>` within a minute.
{% endstep %}
{% endstepper %}

{% hint style="success" %}
**Validated** — this tutorial was last run end-to-end against the production builder on 28 Oct 2026 by the ApplySG team.
{% endhint %}

## What's next

* Walk through a concrete example in [Create your first form](get-started/create-your-first-form.md).
* Shape the stages a submission moves through in [Building your Lifecycle](../core-features/building-your-lifecycle.md).
* Add rules that show or hide fields with [Conditional logic](https://app.gitbook.com/s/XSPACE_ADVANCED/logic/conditional-logic).
