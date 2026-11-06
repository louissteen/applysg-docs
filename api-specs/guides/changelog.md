---
description: "Dated changes to the ApplySG API, with breaking changes and deprecations flagged."
icon: clock-rotate-left
layout:
  width: wide
---

# API changelog

📄 Reference · Updated: 28 Oct 2026 · Freshness: ✅ Current

{% updates format="full" %}
{% update date="2026-10-28" tags="api" %}
## Version 2026-10 is now the default for new clients

New integrations registered from today are pinned to `2026-10`. Existing clients keep their pinned version; set `ApplySG-Version: 2026-10` to opt in.
{% endupdate %}

{% update date="2026-10-14" tags="api" %}
## `POST /submissions/{id}/transition`

Integrations with `submissions:write` can now perform lifecycle actions (for example `approve`) as the integration actor. The action is recorded in the case history and the audit log.
{% endupdate %}

{% update date="2026-09-23" tags="api,breaking" %}
## `classification` replaces `sensitivity` on Form (2026-10 only)

In version `2026-10` the `sensitivity` field on Form objects is renamed to `classification` and uses the whole-of-government labels (`official_open`, `official_closed`, `restricted`, `restricted_sensitive_normal`). Version `2026-04` is unchanged.
{% endupdate %}

{% update date="2026-08-19" tags="api" %}
## Webhook deliveries endpoint

`GET /webhooks/{id}/deliveries` returns the last 7 days of delivery attempts so you can diagnose failing endpoints without contacting support.
{% endupdate %}

{% update date="2026-07-02" tags="deprecated" %}
## `GET /submissions/export` deprecated

The synchronous CSV export endpoint is deprecated in favour of scheduled exports configured in the workspace. It will be removed on **2 July 2027**.
{% endupdate %}

{% update date="2026-05-20" tags="api" %}
## `updated_since` filter on `/submissions`

List submissions changed after a timestamp to support incremental syncs.
{% endupdate %}
{% endupdates %}
