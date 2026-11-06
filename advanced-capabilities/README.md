---
description: "Advanced configuration patterns for experienced ApplySG configurators and solution owners: logic, automation and operating at scale."
icon: bolt
---

# Advanced Capabilities

📄 Guide · Updated: 02 Oct 2026 · Freshness: ✅ Current

This space is for agency officers who already run at least one live service on <code class="expression">space.vars.product_name</code> and want to go further. It assumes you are comfortable with the form builder, lifecycle stages and the submissions inbox described in the [User Guide](https://app.gitbook.com/s/XSPACE_USER_GUIDE/).

Everything here is configured without code. Where an expression or a template string is shown, it is entered into a field in the builder at <code class="expression">space.vars.portal_url</code>, never deployed as software.

{% hint style="info" %}
Advanced features are enabled per service. If a tab described here is missing from your builder, ask your agency's ApplySG administrator to switch on the **Advanced configuration** capability for the service, or write to <code class="expression">space.vars.support_email</code>.
{% endhint %}

## What is covered

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
      <td><strong>Conditional logic</strong></td>
      <td>Show, hide and skip fields, sections and pages based on earlier answers.</td>
      <td><a href="logic/conditional-logic.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Custom validation rules</strong></td>
      <td>NRIC/FIN checksums, regular expressions, cross-field checks and live validation against agency systems.</td>
      <td><a href="logic/custom-validation-rules.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Calculated fields</strong></td>
      <td>Fees, dates and derived values computed from applicant input.</td>
      <td><a href="logic/calculated-fields.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Workflow automation</strong></td>
      <td>Lifecycle stages, automated actions and SLA timers.</td>
      <td><a href="automation/workflow-automation.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Scheduled actions</strong></td>
      <td>Nightly reminders, auto-close rules and recurring exports.</td>
      <td><a href="automation/scheduled-actions.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Notifications</strong></td>
      <td>Email, SMS via Postman.gov.sg and in-portal messages with templates.</td>
      <td><a href="automation/notifications.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Multi-agency workflows</strong></td>
      <td>Route one submission across agencies with shared stages and field-level visibility.</td>
      <td><a href="scale/multi-agency-workflows.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Analytics and reporting</strong></td>
      <td>Built-in dashboards, event exports and privacy-safe reporting.</td>
      <td><a href="scale/analytics-and-reporting.md">link</a></td>
    </tr>
    <tr>
      <td><strong>Data residency and security</strong></td>
      <td>GCC hosting, classification limits, encryption, audit logs and IM8 alignment.</td>
      <td><a href="scale/data-residency-and-security.md">link</a></td>
    </tr>
  </tbody>
</table>

## Who should read this

| Role | Typical use of this space |
| --- | --- |
| Service configurator | Builds and maintains forms, logic and automations for one or more services. |
| Solution owner | Accountable for the service end to end, including SLA, data classification and inter-agency agreements. |
| Agency ApplySG administrator | Manages capabilities, roles and integrations for the whole agency. |
| Integration developer | Will mostly use the [Integrator Guide](https://app.gitbook.com/s/XSPACE_INTEGRATOR/) and [API Specs](https://app.gitbook.com/s/XSPACE_API/), but should understand the automation model described here. |

## Before you start

{% stepper %}
{% step %}
## Confirm your role
You need the **Configurator** or **Solution owner** role on the service. Roles are granted by your agency administrator and are enforced through TechPass SSO group membership.
{% endstep %}
{% step %}
## Work in a draft version
All advanced configuration is made in a draft version of the service. Nothing described here affects applicants until the version is published.
{% endstep %}
{% step %}
## Use the sandbox service
Each agency has a sandbox service for experimentation. Use it to test expressions, automations and notification templates before applying them to a live service.
{% endstep %}
{% endstepper %}

<details><summary>Conventions used in this space</summary>

- `applicant.residency` style references are **field keys**, visible in the field settings panel of the builder.
- Text in `{{ double braces }}` is a **template variable** used in notifications.
- Rules are written as `WHEN condition THEN action` to match the wording of the builder's rule editor.
- All dates and times are Singapore time (UTC+8) unless stated otherwise.

</details>
