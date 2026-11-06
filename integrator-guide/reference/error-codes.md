---
description: "Every error code the ApplySG API returns, with its HTTP status and how to resolve it."
icon: triangle-exclamation
---

# Error codes

📄 Reference · Updated: 21 Oct 2026 · Freshness: ✅ Current

The <code class="expression">space.vars.product_name</code> API reports failures with a conventional HTTP status and a JSON body containing a stable `code` string. Branch on `code`, not on `message`; messages are written for humans and may change between API versions without notice.

## Error body

```json
{
  "error": {
    "code": "submission_locked",
    "message": "Submission GA-2026-004417 is locked at stage 'director_approval' and cannot be edited.",
    "request_id": "req_01HXR7V2K9MP4T8C3N6W1E5ZQB",
    "details": {
      "submission_id": "sub_01HXQ6Z1R2P7K4W9E3M8N5T0CV",
      "stage": "director_approval"
    }
  }
}
```

Always log `request_id`. Quoting it when you write to <code class="expression">space.vars.support_email</code> lets the team find the server-side trace in seconds.

## Authentication and authorisation

| HTTP | `code` | Meaning | Remediation |
| --- | --- | --- | --- |
| 401 | `invalid_client` | Client ID or secret is wrong, belongs to another environment, or the integration is suspended | Check the environment base URL; ask an Admin whether the integration is active |
| 401 | `invalid_token` | Access token is missing, malformed, expired or revoked | Request a new token once and retry; do not loop |
| 400 | `invalid_scope` | Token request asked for a scope the integration was not granted | Request only granted scopes, or ask an Admin to add the scope |
| 403 | `scope_insufficient` | Token is valid but lacks the scope this endpoint needs | Re-request the token with the required scope |
| 403 | `actor_not_permitted` | The delegated officer does not hold a role allowing this action | Check the officer's role in the workspace; see [TechPass SSO](../patterns/techpass-sso.md) |
| 403 | `mtls_required` | Integration is configured for mTLS but no client certificate was presented | Call `api-mtls.apply.gov.sg` with the GovTech Internal CA certificate |

## Forms and submissions

| HTTP | `code` | Meaning | Remediation |
| --- | --- | --- | --- |
| 404 | `form_not_found` | No form with that ID in this workspace and environment | Form IDs differ per environment; resolve by slug |
| 409 | `form_not_published` | The form exists but has no published version | Publish the form in the workspace before creating submissions |
| 422 | `validation_failed` | One or more fields failed the form's validation rules | `details.fields` lists each failing field key and rule |
| 404 | `submission_not_found` | Submission does not exist or the integration cannot see it | Check the ID and the integration's form access |
| 409 | `submission_locked` | Submission is at a stage that does not permit edits | Wait for the workflow to return it, or use a stage action |
| 409 | `stage_transition_invalid` | The requested stage is not reachable from the current stage | Read the workflow definition; only configured transitions are allowed |
| 413 | `attachment_too_large` | Attachment exceeds the form's size limit (default 25 MB) | Compress or split the file |
| 415 | `attachment_type_not_allowed` | File type is not in the form's allowed list | Check **Form settings → Attachments** |

## Webhooks and embeds

| HTTP | `code` | Meaning | Remediation |
| --- | --- | --- | --- |
| 422 | `webhook_url_invalid` | URL is not HTTPS, or resolves to a private range not reachable from ApplySG | Use a public HTTPS URL or a GCC-reachable endpoint approved by GovTech |
| 409 | `webhook_limit_reached` | Integration already has 20 endpoints | Consolidate endpoints; one endpoint can subscribe to many events |
| 403 | `embed_origin_not_allowed` | Page origin is not in the form's allowed origins | Add the origin under **Form settings → Embedding** |

## Rate limiting and availability

| HTTP | `code` | Meaning | Remediation |
| --- | --- | --- | --- |
| 429 | `rate_limited` | Client exceeded its per-minute quota | Honour `Retry-After`; see [Rate limits](rate-limits.md) |
| 429 | `token_requests_exceeded` | More than 10 token requests in a minute | Cache tokens until near expiry |
| 503 | `maintenance` | Planned maintenance window | Retry after the window announced in the [Changelog](changelog.md) |
| 500 | `internal_error` | Unexpected server fault | Retry with backoff; report `request_id` if it persists |

## Handling guidance

{% hint style="info" %}
Treat `4xx` codes other than `429` as **non-retryable**: repeating the same request will produce the same answer. Treat `429`, `500` and `503` as retryable with exponential backoff and jitter, capped at five attempts.
{% endhint %}

<details>
<summary>Deprecated codes</summary>

| Removed in | Old code | Replacement |
| --- | --- | --- |
| 2026-07 | `unauthorized` | `invalid_token` |
| 2026-07 | `forbidden_scope` | `scope_insufficient` |
| 2026-10 | `too_many_requests` | `rate_limited` |

Clients pinned to an earlier `ApplySG-Version` continue to receive the old codes until that version is retired.

</details>
