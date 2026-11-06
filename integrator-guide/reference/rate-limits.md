---
description: "Per-client request quotas for each ApplySG environment, the headers that report them, and how to handle bursts."
icon: gauge-high
---

# Rate limits

📄 Reference · Updated: 07 Oct 2026 · Freshness: ✅ Current

The <code class="expression">space.vars.product_name</code> API applies rate limits **per integration client ID**, per environment. Limits protect the shared platform during peak periods such as grant application deadlines, when several agencies' workflows can spike at once.

## Quotas

| Environment | Requests per minute | Token requests per minute | Concurrent export streams |
| --- | --- | --- | --- |
| Sandbox | **60** | 10 | 1 |
| Staging | 300 | 10 | 2 |
| Production | **600** | 10 | 4 |

Limits use a sliding one-minute window. Every request counts, including those that fail with `4xx`. Webhook deliveries *to* you and scheduled exports do not count against your quota.

{% hint style="info" %}
Agencies with a demonstrated need (for example, a nationwide scheme with a hard submission deadline) can request a temporary uplift by emailing <code class="expression">space.vars.support_email</code> at least five working days in advance, stating the client ID, the window and the expected peak.
{% endhint %}

## Response headers

Every response carries the current state of your window:

| Header | Meaning |
| --- | --- |
| `X-RateLimit-Limit` | Requests permitted per minute for this client in this environment |
| `X-RateLimit-Remaining` | Requests left in the current window |
| `X-RateLimit-Reset` | Unix seconds at which the window fully resets |
| `Retry-After` | Only on `429`: seconds to wait before retrying |

Example from Production:

```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 600
X-RateLimit-Remaining: 412
X-RateLimit-Reset: 1761275620
X-ApplySG-Request-Id: req_01HXR7V2K9MP4T8C3N6W1E5ZQB
```

When the quota is exhausted:

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 17
X-RateLimit-Limit: 600
X-RateLimit-Remaining: 0
Content-Type: application/json

{ "error": { "code": "rate_limited", "message": "Rate limit exceeded. Retry after 17 seconds.", "request_id": "req_01HXR7W8..." } }
```

## Handling bursts

Most integrations never approach the limit in steady state. Problems arise during backfills, retries after an outage, or when a scheduler fires the same job on several hosts. Recommended practice:

{% stepper %}
{% step %}
## Read the headers on every response
Keep `X-RateLimit-Remaining` in memory. When it drops below 10 per cent of the limit, slow down voluntarily rather than waiting for a `429`.
{% endstep %}

{% step %}
## Honour `Retry-After`
On `429`, sleep for exactly the number of seconds given, then retry the same request. Do not shorten it; the window is enforced server-side regardless.
{% endstep %}

{% step %}
## Add jitter to retries
If several workers back off simultaneously they will return simultaneously. Add 0–30 per cent random jitter to each wait.
{% endstep %}

{% step %}
## Prefer bulk endpoints
One export page of 500 submissions costs one request. Fetching 500 submissions individually costs 500. Use the [export API](../patterns/exporting-submissions.md) and [webhooks](../patterns/webhooks.md) instead of polling.
{% endstep %}

{% step %}
## Coordinate across hosts
Run backfills from a single worker, or share a token bucket through your own cache so the whole fleet respects one quota.
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
Requesting a new access token on every API call is the most common way integrations hit `token_requests_exceeded`. Tokens last one hour; cache them.
{% endhint %}

## Token-bucket example

{% tabs %}
{% tab title="Node.js" %}
```javascript
import Bottleneck from 'bottleneck';

// 600/min in Production, keep 10% headroom
const limiter = new Bottleneck({ reservoir: 540, reservoirRefreshAmount: 540, reservoirRefreshInterval: 60_000, maxConcurrent: 8 });

export const call = (fn) => limiter.schedule(async () => {
  const res = await fn();
  if (res.status === 429) {
    const wait = Number(res.headers.get('retry-after') || 5);
    await new Promise(r => setTimeout(r, wait * 1000 * (1 + Math.random() * 0.3)));
    return fn();
  }
  return res;
});
```
{% endtab %}

{% tab title="Python" %}
```python
import random, time, requests

def call_with_backoff(session, method, url, **kw):
    for attempt in range(5):
        resp = session.request(method, url, **kw)
        if resp.status_code != 429:
            return resp
        wait = int(resp.headers.get("Retry-After", 5))
        time.sleep(wait * (1 + random.random() * 0.3))
    resp.raise_for_status()
```
{% endtab %}
{% endtabs %}

## Other limits

| Limit | Value |
| --- | --- |
| Request body | 10 MB (attachments uploaded separately, 25 MB default) |
| Export page size | 500 |
| Webhook endpoints per integration | 20 |
| Scheduled exports per workspace | 10 |
