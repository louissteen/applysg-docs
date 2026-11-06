---
description: "Accounts, roles and browser requirements you need before building in ApplySG."
icon: list-check
---

# Prerequisites

📄 Reference · Updated: 14 Oct 2026 · Freshness: ✅ Current

## Checklist

- [ ] A **TechPass** account issued by your agency
- [ ] The **Requestor** or **Admin** role on your agency's ApplySG workspace
- [ ] A supported browser (current Chrome, Edge, Firefox or Safari)
- [ ] For publishing to the public portal: your agency's **Digital Service Owner** has signed off the form's data classification

## Accounts and roles

| Role | Can build forms | Can publish | Can review submissions | Can manage members |
| --- | :---: | :---: | :---: | :---: |
| Viewer | | | ✅ (read-only) | |
| Requestor | ✅ | | ✅ | |
| Approver | | | ✅ | |
| Admin | ✅ | ✅ | ✅ | ✅ |

{% hint style="warning" %}
Only **Admins** can publish a form to the public portal. Requestors can build and preview, then raise a publish request that an Admin approves.
{% endhint %}

## Network access

ApplySG is reachable from the internet and from the Government Intranet. Officers on GSIB devices use the same URL, <code class="expression">space.vars.portal_url</code>, and no additional whitelisting is required.

## Test applicants

Every workspace ships with three test Singpass identities for previewing forms:

| Test identity | Profile |
| --- | --- |
| `S9000001A` | Singapore citizen, 34, resident in Tampines |
| `G7000002K` | Employment Pass holder, 41 |
| `T2000003F` | Corppass user for *Acme Logistics Pte Ltd* (UEN `202012345A`) |

These identities exist only in **Preview** mode and never reach production data.

<details>
<summary>Why can't I see my workspace?</summary>

Workspaces are provisioned per agency by the ApplySG team. If you signed in with TechPass and the list is empty, your agency admin has not yet added you. Ask them to open **Settings → Members → Invite** and search for your TechPass email. If your agency has no workspace yet, request one at <code class="expression">space.vars.support_email</code>.

</details>
