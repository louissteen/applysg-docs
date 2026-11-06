---
description: "How ApplySG dates API versions, what counts as a breaking change and how deprecations are announced."
icon: code-branch
---

# Versioning

📄 Guide · Updated: 1 Oct 2026 · Freshness: ✅ Current

The API uses **date-based versions**. The current version is <code class="expression">space.vars.api_version</code>. Your client is pinned to the version that was current when it was registered; send the `ApplySG-Version` header to opt into a newer one.

```bash
curl https://api.apply.gov.sg/v1/forms \
  -H "Authorization: Bearer $TOKEN" \
  -H "ApplySG-Version: 2026-10"
```

## What is and is not breaking

{% columns %}
{% column %}
### Non-breaking (no new version)

* Adding a new endpoint
* Adding an optional request field
* Adding a response field
* Adding a new enum value to **webhook event** types
{% endcolumn %}

{% column %}
### Breaking (new dated version)

* Removing or renaming a field
* Changing a field's type
* Adding a new enum value to a **response** field your client switches on
* Tightening validation
{% endcolumn %}
{% endcolumns %}

## Deprecation policy

| Step | Timing |
| --- | --- |
| Announcement in the [API changelog](changelog.md) and by email to integration owners | Day 0 |
| `Deprecation` and `Sunset` response headers on affected endpoints | Day 0 |
| Old version continues to work | 12 months |
| Old version removed | Day 365 |

<details>
<summary>Example deprecation headers</summary>

```http
HTTP/1.1 200 OK
Deprecation: true
Sunset: Wed, 01 Oct 2027 00:00:00 GMT
Link: <https://docs.developer.tech.gov.sg/applysg/api-specs/guides/versioning>; rel="deprecation"
```

</details>
