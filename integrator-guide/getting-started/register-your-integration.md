---
description: "Register an integration in your ApplySG workspace to obtain a client ID, a client secret and the scopes your system needs."
icon: id-badge
---

# Register your integration

📄 Guide · Updated: 14 Oct 2026 · Freshness: ✅ Current

Every system that calls the <code class="expression">space.vars.product_name</code> API does so as a registered **integration**. An integration belongs to one agency workspace, has a client ID and client secret, and is limited to the scopes granted at registration. Registration is performed in the ApplySG workspace UI by a user with the **Admin** role; developers cannot self-register.

{% hint style="warning" %}
Each integration should represent one system (for example, "Licensing CRM sync" or "Intranet form embed"). Do not share one client ID across several systems: it makes audit trails meaningless and forces a wider blast radius when a secret has to be rotated.
{% endhint %}

## Scopes

| Scope | Grants |
| --- | --- |
| `forms:read` | List forms, read form definitions and published versions |
| `submissions:read` | Read submissions, their current stage and attachments |
| `submissions:write` | Create submissions, add comments, move stages where the workflow permits |
| `webhooks:manage` | Create, update, test and delete webhook endpoints |

Request only the scopes you need. A token requested with a scope the integration was not granted is rejected with `scope_insufficient` (see [Error codes](../reference/error-codes.md)).

## Registration steps

{% stepper %}
{% step %}
## Open Integrations settings
In the ApplySG workspace at <code class="expression">space.vars.portal_url</code>, an Admin opens **Settings → Integrations** and selects **New integration**.
{% endstep %}

{% step %}
## Describe the integration
Give the integration a name, an owning team and a technical contact email. The contact receives secret-expiry reminders and webhook failure digests, so use a team mailbox rather than an individual.
{% endstep %}

{% step %}
## Choose scopes and environment
Tick the scopes the integration needs. Choose whether the integration applies to **Sandbox**, **Staging** or **Production**. Credentials are environment-specific; a Sandbox client ID will not authenticate against Production. See [Environments](environments.md).
{% endstep %}

{% step %}
## Record the credentials
ApplySG displays a client ID such as `asg_client_7f3a9c` and a client secret. **The secret is shown once.** Store it in your agency's approved secret store (for example, the GCC secrets manager or an approved vault) before closing the dialog. If it is lost, an Admin must rotate it.
{% endstep %}

{% step %}
## Hand over to the developer
Share the client ID freely; share the secret only through the secret store. The developer can now [request a token](authentication.md).
{% endstep %}
{% endstepper %}

## Secret rotation

Secrets expire **12 months** after issue. The technical contact is emailed at 30, 14 and 3 days before expiry. To rotate without downtime:

1. The Admin selects **Rotate secret** on the integration. ApplySG issues a new secret and keeps the old one valid for a **72-hour grace period**.
2. Deploy the new secret to your system.
3. Optionally select **Revoke previous secret** to end the grace period early.

<details>
<summary>What happens if a secret is leaked?</summary>

Revoke it immediately from **Settings → Integrations → Revoke**. All tokens issued with that secret stop working within 60 seconds. Then notify <code class="expression">space.vars.support_email</code> and your agency's IT security officer in line with the Government IM8 incident reporting requirements. ApplySG retains the integration's audit log so you can review which calls were made while the secret was exposed.

</details>

## After registration

* The integration appears in the Admin's **Integrations** list with its scopes, environment, last-used timestamp and an **Audit log** tab.
* Admins can suspend an integration at any time. Suspended integrations receive `invalid_client` on token requests.
* Each integration has its own [rate limit](../reference/rate-limits.md) bucket.
