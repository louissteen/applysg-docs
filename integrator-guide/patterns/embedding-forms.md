---
description: "Render an ApplySG form inside an agency web page or intranet portal using the embed script or an iframe."
icon: window-maximize
---

# Embedding forms

📄 Guide · Updated: 09 Oct 2026 · Freshness: ✅ Current

Embedding lets citizens or officers complete an <code class="expression">space.vars.product_name</code> form without leaving your agency's site. The form itself continues to run on <code class="expression">space.vars.portal_url</code>: ApplySG handles validation, attachments, TechPass sign-in and submission. Your page only hosts it. **No client secret is involved**, so this pattern is safe for public web pages.

## Option 1: JavaScript embed (recommended)

The embed script renders the form into a container element, resizes it automatically and lets you pass prefill data and listen for events.

```html
<div id="applysg-form"></div>
<script src="https://apply.gov.sg/embed.js" defer></script>
<script>
  window.addEventListener('applysg:ready', function () {
    ApplySG.embed({
      formId: 'frm_01HXK2D8P6M4R1S7Q9W3E5T2AB',
      container: '#applysg-form',
      environment: 'production',          // 'sandbox' | 'staging' | 'production'
      prefill: {
        applicant_uen: '201912345K',
        contact_email: 'ops@agency.gov.sg'
      },
      theme: 'agency-light',
      onSubmitted: function (event) {
        console.log('Submitted', event.submissionId);
      }
    });
  });
</script>
```

### Options

| Option | Type | Notes |
| --- | --- | --- |
| `formId` | string | Required. Use the ID for the target environment |
| `container` | string or Element | Required. CSS selector or DOM node |
| `environment` | string | Defaults to `production` |
| `prefill` | object | Keys match field keys in the form builder. Prefilled values are still validated server-side |
| `theme` | string | `applysg-default`, `agency-light`, `agency-dark`, or a custom theme ID |
| `locale` | string | `en`, `zh`, `ms` or `ta` |
| `onSubmitted` | function | Receives `{ submissionId, formId }` |
| `onError` | function | Receives `{ code, message }` |

{% hint style="info" %}
Prefill is a convenience, not a security control. Anything you put in `prefill` is visible to the person completing the form. Use [TechPass SSO](techpass-sso.md) claims if you need trusted identity fields.
{% endhint %}

## Option 2: iframe

If your content management system does not allow custom scripts, use a plain iframe. You lose auto-resizing and events, but prefill still works through query parameters.

```html
<iframe
  src="https://apply.gov.sg/f/frm_01HXK2D8P6M4R1S7Q9W3E5T2AB?embed=1&prefill[contact_email]=ops%40agency.gov.sg"
  title="Grant application"
  width="100%"
  height="900"
  style="border:0"
  allow="camera; microphone"
  referrerpolicy="strict-origin-when-cross-origin">
</iframe>
```

The `allow` attribute is only needed for forms with file-upload or photo-capture fields.

## Content Security Policy

If your site sends a CSP header, allowlist the following. Both options need `frame-src`; the script embed additionally needs `script-src` and `connect-src`.

```
script-src  https://apply.gov.sg;
frame-src   https://apply.gov.sg https://*.apply.gov.sg;
connect-src https://api.apply.gov.sg https://apply.gov.sg;
img-src     https://cdn.apply.gov.sg data:;
```

Sandbox and Staging use the same pattern with `sandbox.apply.gov.sg` and `staging.apply.gov.sg` respectively.

## Allowed origins

ApplySG refuses to render inside pages it does not recognise. Add every origin that will host the form under **Form settings → Embedding → Allowed origins** in the workspace (for example `https://www.agency.gov.sg`, `https://intranet.agency.gov.sg`). Wildcards are permitted for subdomains only. Pages on an unlisted origin receive the `embed_origin_not_allowed` error.

## Styling tokens

Themes are defined in the workspace under **Settings → Branding**. For finer control, override the CSS custom properties below on the container element; the embed inherits them across the frame boundary.

```css
#applysg-form {
  --asg-font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
  --asg-colour-primary: #1F4E79;
  --asg-colour-primary-contrast: #FFFFFF;
  --asg-colour-surface: #FFFFFF;
  --asg-colour-border: #D5DBE3;
  --asg-radius: 4px;
  --asg-spacing-unit: 8px;
}
```

Only the tokens listed are honoured; arbitrary CSS cannot reach inside the form, which keeps the Digital Service Standards accessibility baseline intact.

<details>
<summary>Testing an embed locally</summary>

Sandbox allows `http://localhost:*` and `http://127.0.0.1:*` as origins by default, so you can test from a local dev server without changing allowed origins. Staging and Production do not.

</details>

{% hint style="success" %}
After a citizen submits, the embedded form shows ApplySG's standard acknowledgement with the submission reference. You can replace this with your own page by passing `redirectUrl` in `ApplySG.embed`, as long as the URL is on an allowed origin.
{% endhint %}
