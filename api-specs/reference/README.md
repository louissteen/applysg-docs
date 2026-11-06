---
description: "Overview of the generated ApplySG API reference and how to use the Test it runner."
icon: book
---

# ApplySG API

📄 Reference · Updated: 28 Oct 2026 · Freshness: ✅ Current

The pages below this one are generated from `openapi/applysg-api.yaml`. Each operation page shows parameters, request and response schemas, and example payloads, and includes an interactive **Test it** runner.

## Using Test it

{% stepper %}
{% step %}
## Pick a server

Choose **Sandbox** from the server dropdown. Production requests from the docs are blocked by CORS policy.
{% endstep %}

{% step %}
## Paste a sandbox token

Obtain a token as described in [Authentication](../guides/authentication.md) and paste it into the **Bearer token** field. Tokens expire after one hour.
{% endstep %}

{% step %}
## Send the request

Fill in parameters and select **Send**. The response panel shows status, headers and body.
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
Sandbox data is reset every **Sunday at 02:00 SGT**. Do not rely on sandbox IDs across weeks.
{% endhint %}

## Conventions

* IDs are prefixed by type: `frm_`, `sub_`, `doc_`, `whk_`.
* Timestamps are ISO 8601 in UTC; display them in SGT (UTC+8) for officers.
* Money is expressed in cents of Singapore dollars as integers.
* Errors always return `{ "code", "message", "details"? }` — see [Error codes](https://app.gitbook.com/s/XSPACE_INTEGRATOR/reference/error-codes).
