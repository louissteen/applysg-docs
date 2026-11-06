---
description: "Workspaces, roles, teams and how TechPass identities map to ApplySG permissions."
icon: folder-open
---

# Access and Permissions

📄 Guide · Updated: 7 Oct 2026 · Freshness: ✅ Current

Every agency gets one **workspace**. Inside it, people hold a **role** and may belong to **teams** that are assigned work at particular lifecycle stages.

## Identity

Officers sign in with **TechPass**. ApplySG reads the agency, email and display name from the TechPass token; it never stores passwords. When an officer leaves the service, TechPass de-provisioning removes their access within 15 minutes.

```mermaid
sequenceDiagram
    participant O as Officer
    participant T as TechPass
    participant A as ApplySG
    O->>A: Open apply.gov.sg
    A->>T: Redirect for sign-in
    T-->>A: ID token (agency, email, name)
    A->>A: Match to workspace member
    A-->>O: Console with role-based menu
```

## Roles

| Role | Typical holder | Permissions |
| --- | --- | --- |
| **Viewer** | Auditors, management | Read submissions and dashboards |
| **Requestor** | Service designers, ops officers | Build and preview forms, raise publish requests, process submissions |
| **Approver** | Licensing or grants officers | Process submissions at stages assigned to their team |
| **Admin** | Digital service owner | Everything, plus publishing, members, integrations and billing |

{% hint style="warning" %}
Keep the number of Admins small (two or three per workspace). Admins can publish forms that collect personal data and can create integration credentials.
{% endhint %}

## Teams

Teams group officers so that lifecycle stages can be assigned to a team rather than an individual.

{% stepper %}
{% step %}
## Create a team

Go to **Settings → Teams → New team**, name it (for example `Licensing officers`) and add members.
{% endstep %}

{% step %}
## Assign the team to a stage

Open a form, select **Lifecycle**, pick a stage and set **Assignee** to the team. New submissions entering that stage appear in every team member's queue.
{% endstep %}

{% step %}
## Optional: round-robin

Enable **Auto-assign** on the stage to distribute cases evenly across the team.
{% endstep %}
{% endstepper %}

## Field-level visibility

Sensitive fields (for example a medical declaration) can be restricted so only specific teams see their values. Other officers see a `•••• restricted` placeholder and the audit log records every reveal.

{% tabs %}
{% tab title="Builder" %}
Select the field → **Advanced** → **Visible to** → choose teams.
{% endtab %}

{% tab title="Form definition (JSON)" %}
```json
{
  "id": "medical_declaration",
  "type": "textarea",
  "visibility": {
    "teams": ["team_medical_review"]
  }
}
```
{% endtab %}
{% endtabs %}

## Audit log

All permission changes, reveals of restricted fields and publish actions are written to the workspace audit log, retained for **7 years** and exportable as CSV. See [Documents and Data](documents-and-data.md).
