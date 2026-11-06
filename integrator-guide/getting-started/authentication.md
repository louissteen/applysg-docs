---
description: "Authenticate to the ApplySG API with OAuth 2.0 client credentials and present the resulting bearer token on every request."
icon: key
---

# Authentication

📄 Guide · Updated: 21 Oct 2026 · Freshness: ✅ Current

The <code class="expression">space.vars.product_name</code> API uses the **OAuth 2.0 client credentials** grant. Your integration exchanges its client ID and client secret for a short-lived access token, then presents that token as a bearer token on every API call.

## Token endpoint

| | |
| --- | --- |
| Endpoint | `POST {base_url}/oauth/token` |
| Grant type | `client_credentials` |
| Authentication | HTTP Basic (`client_id:client_secret`) or form body |
| Token lifetime | `expires_in: 3600` (one hour) |
| Token type | `Bearer` |

Tokens are **not** refreshable. Request a new one before the current token expires; the response includes `expires_in` so you can schedule renewal at, say, 55 minutes.

## Requesting a token

{% tabs %}
{% tab title="curl" %}
```bash
curl -X POST "https://api.sandbox.apply.gov.sg/v1/oauth/token" \
  -u "asg_client_7f3a9c:${APPLYSG_CLIENT_SECRET}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "scope=forms:read submissions:read"
```
{% endtab %}

{% tab title="Node.js" %}
```javascript
const clientId = 'asg_client_7f3a9c';
const clientSecret = process.env.APPLYSG_CLIENT_SECRET;

const res = await fetch('https://api.sandbox.apply.gov.sg/v1/oauth/token', {
  method: 'POST',
  headers: {
    Authorization: 'Basic ' + Buffer.from(`${clientId}:${clientSecret}`).toString('base64'),
    'Content-Type': 'application/x-www-form-urlencoded',
  },
  body: new URLSearchParams({
    grant_type: 'client_credentials',
    scope: 'forms:read submissions:read',
  }),
});

const { access_token, expires_in } = await res.json();
```
{% endtab %}

{% tab title="Python" %}
```python
import os
import requests

resp = requests.post(
    "https://api.sandbox.apply.gov.sg/v1/oauth/token",
    auth=("asg_client_7f3a9c", os.environ["APPLYSG_CLIENT_SECRET"]),
    data={
        "grant_type": "client_credentials",
        "scope": "forms:read submissions:read",
    },
    timeout=10,
)
resp.raise_for_status()
token = resp.json()["access_token"]
```
{% endtab %}
{% endtabs %}

A successful response looks like this:

```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImFzZy0yMDI2LTEwIn0...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "forms:read submissions:read"
}
```

## Calling the API

Send the token in the `Authorization` header. Also send the API version you built against; omitting it defaults to the latest version, which may introduce changes you have not tested.

```bash
curl "https://api.sandbox.apply.gov.sg/v1/forms" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "ApplySG-Version: 2026-10"
```

{% hint style="danger" %}
**Never embed a client secret in front-end code**, mobile apps or anything shipped to a browser. The client credentials grant is for server-to-server use only. If you need a form inside a web page, use [Embedding forms](../patterns/embedding-forms.md), which needs no secret at all.
{% endhint %}

## Token handling guidance

* Cache the token in memory and reuse it until roughly five minutes before expiry. Requesting a fresh token on every call counts against your [rate limit](../reference/rate-limits.md) and is rejected after ten token requests per minute.
* Treat `401 invalid_token` as a signal to fetch a new token once, then retry. Do not loop.
* Tokens are JWTs signed with keys published at `{base_url}/.well-known/jwks.json`. You may validate them locally, but you should not depend on claim names beyond `sub`, `scope` and `exp`.

## Mutual TLS for Government Intranet workloads

Integrations running on the Government Standard Image Build (GSIB) or inside the Government Intranet may optionally use **mTLS** in place of the client secret. When mTLS is enabled on the integration:

* Your system presents a client certificate issued by the GovTech Internal CA on the TLS handshake to `api-mtls.apply.gov.sg`.
* The token request omits the secret; ApplySG binds the certificate's Subject to the client ID.
* Issued tokens carry a `cnf` claim bound to the certificate thumbprint, so a stolen token cannot be replayed from another host.

Enable mTLS from **Settings → Integrations → Security**. Certificate requests follow your agency's usual GovTech Internal CA process.

<details>
<summary>Common authentication errors</summary>

| Code | Likely cause |
| --- | --- |
| `invalid_client` | Wrong client ID, wrong environment, or integration suspended |
| `invalid_scope` | Requested a scope the integration was not granted |
| `invalid_token` | Token expired, revoked, or issued for another environment |
| `scope_insufficient` | Token is valid but lacks the scope the endpoint requires |

See the full list in [Error codes](../reference/error-codes.md).

</details>
