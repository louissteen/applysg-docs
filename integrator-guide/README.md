---
description: "Connect your agency systems to ApplySG using OAuth 2.0 client credentials, webhooks, embedded forms and scheduled exports."
icon: plug
layout:
  title: true
  description: true
  tableOfContents: true
  outline: true
  pagination: true
---

# Integrator Guide

📄 Guide · Updated: 28 Oct 2026 · Freshness: ✅ Current

This guide is for agency developers and system integrators who need to connect an existing agency system to <code class="expression">space.vars.product_name</code>. It covers how to register an integration, obtain credentials, move between environments and build on the supported integration patterns. It assumes you are comfortable with REST APIs, OAuth 2.0 and JSON.

{% hint style="info" %}
If you are an agency officer configuring forms and workflows in the ApplySG workspace rather than writing code, start with the [User Guide](https://app.gitbook.com/s/XSPACE_USER_GUIDE/) instead. For endpoint-level detail, use the [API Specs](https://app.gitbook.com/s/XSPACE_API/).
{% endhint %}

## What you can build

ApplySG exposes a versioned REST API at <code class="expression">space.vars.api_base_url</code> (current API version <code class="expression">space.vars.api_version</code>). Typical integrations fall into one of four patterns:

| Pattern | Use it when | Direction |
| --- | --- | --- |
| **Webhooks** | Your system must react when a submission is created, moves stage or is approved | ApplySG → agency |
| **Embedding forms** | You want an ApplySG form to appear inside an agency portal or intranet page | Citizen or officer → ApplySG |
| **Exporting submissions** | You need submissions in a data warehouse, case-management system or GCC bucket | ApplySG → agency |
| **TechPass single sign-on** | Your integration must act on behalf of a named officer, not a service account | Officer identity → ApplySG → agency |

## Before you start

1. Confirm your agency has an ApplySG workspace. Workspaces are provisioned by GovTech on request from the agency's Chief Information Officer office.
2. Ask a workspace **Admin** to register an integration for you. This creates a client ID and the scopes your integration is permitted to use.
3. Build and test against **Sandbox** first. Sandbox is isolated from production data and uses test TechPass accounts.

## Where to go next

<table data-view="cards">
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th data-hidden data-card-target data-type="content-ref"></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Register your integration</strong></td>
      <td>Create a client ID, choose scopes and store the client secret safely.</td>
      <td><a href="getting-started/register-your-integration.md">register-your-integration.md</a></td>
    </tr>
    <tr>
      <td><strong>Environments</strong></td>
      <td>Understand Sandbox, Staging and Production and how to promote between them.</td>
      <td><a href="getting-started/environments.md">environments.md</a></td>
    </tr>
    <tr>
      <td><strong>Authentication</strong></td>
      <td>Exchange your credentials for a bearer token with OAuth 2.0 client credentials.</td>
      <td><a href="getting-started/authentication.md">authentication.md</a></td>
    </tr>
    <tr>
      <td><strong>Webhooks</strong></td>
      <td>Receive signed, retried event notifications for submissions and forms.</td>
      <td><a href="patterns/webhooks.md">webhooks.md</a></td>
    </tr>
    <tr>
      <td><strong>Embedding forms</strong></td>
      <td>Drop an ApplySG form into any agency web page with the embed script.</td>
      <td><a href="patterns/embedding-forms.md">embedding-forms.md</a></td>
    </tr>
    <tr>
      <td><strong>Exporting submissions</strong></td>
      <td>Pull submissions on demand or schedule exports to a GCC bucket.</td>
      <td><a href="patterns/exporting-submissions.md">exporting-submissions.md</a></td>
    </tr>
    <tr>
      <td><strong>TechPass single sign-on</strong></td>
      <td>Carry officer identity and role from TechPass through to your integration.</td>
      <td><a href="patterns/techpass-sso.md">techpass-sso.md</a></td>
    </tr>
    <tr>
      <td><strong>Error codes</strong></td>
      <td>Every error code the API returns, with the fix for each.</td>
      <td><a href="reference/error-codes.md">error-codes.md</a></td>
    </tr>
    <tr>
      <td><strong>Rate limits</strong></td>
      <td>Per-client quotas, response headers and burst guidance.</td>
      <td><a href="reference/rate-limits.md">rate-limits.md</a></td>
    </tr>
  </tbody>
</table>

## Support

Integration questions go to <code class="expression">space.vars.support_email</code>. Please include your client ID (never your secret), the environment and a request ID from the `X-ApplySG-Request-Id` response header. Production incidents affecting citizen-facing services should be raised through your agency's usual IT incident channel, which is routed to the ApplySG on-call team.

{% hint style="success" %}
Every page in this guide carries a freshness line under its title. Pages marked **Current** have been validated against the live API version within the last 90 days.
{% endhint %}
