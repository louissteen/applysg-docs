---
description: "Dated record of changes to the ApplySG API, webhooks and integrator tooling, including deprecations and breaking changes."
icon: clock-rotate-left
layout:
  width: wide
---

# Changelog

📄 Reference · Updated: 28 Oct 2026 · Freshness: ✅ Current

This page records every change to the <code class="expression">space.vars.product_name</code> API, webhooks and integrator tooling that an agency developer might need to act on. The current API version is <code class="expression">space.vars.api_version</code>. Dated versions are supported for **12 months** after the next version is released; pin the version you tested against with the `ApplySG-Version` header.

{% hint style="info" %}
Entries tagged **Breaking change** require action before the retirement date stated in the entry. Entries tagged **Validated** have been confirmed against the Production environment by the ApplySG platform team.
{% endhint %}

{% updates format="full" %}
{% update date="2026-10-21" tags="validated, webhooks" %}
## API version 2026-10 released
Version `2026-10` is now the default for requests that omit `ApplySG-Version`. Changes from `2026-07`:

* The error code `too_many_requests` is renamed `rate_limited`.
* `X-RateLimit-Reset` is now returned on every response, not only on `429`.
* Webhook payloads include `api_version` so receivers can branch on schema.
* The `form.published` event now includes `data.version` and `data.published_by`.

Version `2026-07` remains supported until **21 October 2027**.
{% endupdate %}

{% update date="2026-09-30" tags="security" %}
## Actor claims header on webhook deliveries
Webhook deliveries triggered by an officer action now carry an `X-ApplySG-Actor` header: a signed JWS stating the officer's TechPass `sub`, role and the action performed. The signing keys are published at `/.well-known/jwks.json`. No change is required to continue receiving webhooks; see [TechPass single sign-on](../patterns/techpass-sso.md) to start using the claims.
{% endupdate %}

{% update date="2026-08-26" tags="breaking, webhooks" %}
## Webhook signature scheme v1 replaces legacy HMAC header
The legacy `X-ApplySG-HMAC` header (HMAC over the body only) is deprecated in favour of `X-ApplySG-Signature` with a `v1=` prefix and a timestamp-bound payload (`{timestamp}.{body}`). Both headers are sent until **26 February 2027**, after which only `X-ApplySG-Signature` is sent. Update your verification code following [Webhooks](../patterns/webhooks.md). Endpoints created after this date receive only the new header.
{% endupdate %}

{% update date="2026-07-15" tags="validated" %}
## Scheduled exports to GCC buckets
Admins can now configure hourly, daily or weekly exports of submissions and attachments to an S3-compatible bucket in the Government Commercial Cloud, with incremental or full-snapshot modes and a signed manifest per run. Available in Staging and Production. See [Exporting submissions](../patterns/exporting-submissions.md).
{% endupdate %}

{% update date="2026-06-10" tags="security" %}
## Optional mutual TLS for Government Intranet integrations
Integrations running on GSIB or within the Government Intranet can authenticate with a GovTech Internal CA client certificate instead of a client secret. Tokens issued over mTLS are certificate-bound (`cnf` claim). Enable under **Settings → Integrations → Security**. A new error code, `mtls_required`, is returned when an mTLS-configured integration calls the standard endpoint.
{% endupdate %}

{% update date="2026-05-06" tags="breaking" %}
## Sandbox rate limit reduced to 60 requests per minute
To keep the shared Sandbox responsive during onboarding peaks, the per-client limit is reduced from 120 to **60 requests per minute**. Production (600) and Staging (300) are unchanged. Integrations that run load tests should do so in Staging. Sandbox data retention is also now fixed at 30 days; previously it varied between 30 and 60 days depending on workspace creation date.
{% endupdate %}
{% endupdates %}

## Planned changes

| Target | Change | Status |
| --- | --- | --- |
| Q1 2027 | Retirement of `X-ApplySG-HMAC` legacy header | Announced, see 26 Aug 2026 entry |
| Q1 2027 | GraphQL read endpoint for submissions (beta) | In design, feedback welcome at <code class="expression">space.vars.support_email</code> |
| Q2 2027 | Retirement of API version `2026-04` | Announced |

Agencies are notified of breaking changes by email to each integration's technical contact at least **90 days** before the change takes effect.
