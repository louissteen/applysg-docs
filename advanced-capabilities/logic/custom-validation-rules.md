---
description: "Go beyond required fields with checksum, pattern, cross-field and asynchronous validation rules, and write error messages applicants can act on."
icon: list-check
---

# Custom validation rules

📄 Guide · Updated: 25 Sep 2026 · Freshness: ✅ Current

Validation rules stop a submission that <code class="expression">space.vars.product_name</code> can already tell is incomplete or inconsistent, before an officer ever sees it. Each rule has a **condition**, a **severity** and an **error message**.

| Severity | Behaviour |
| --- | --- |
| `block` | Applicant cannot continue to the next page or submit. |
| `warn` | Applicant sees the message but may continue. The warning is recorded on the submission for the officer. |

## Built-in validators

These are available from the field settings panel with no configuration.

| Validator | Field types | Notes |
| --- | --- | --- |
| NRIC / FIN checksum | Text | Validates the prefix letter, seven digits and check letter. Accepts S, T, F, G and M series. |
| UEN | Text | Validates all three UEN formats used by ACRA-registered entities. |
| Singapore postal code | Text | Six digits, first two digits within a known sector range. |
| Singapore mobile | Text | Eight digits starting with 8 or 9, optional `+65`. |
| Email | Text | Syntax check only. Deliverability is not checked. |
| Date range | Date | Minimum and maximum, absolute or relative to today. |
| File | File upload | Type, size (default 10 MB) and virus scan result. |

{% hint style="info" %}
The NRIC / FIN checksum only confirms that the number is well formed. It does not confirm that the number belongs to the applicant. For identity assurance rely on the Singpass-verified fields, described in the [User Guide](https://app.gitbook.com/s/XSPACE_USER_GUIDE/).
{% endhint %}

## Pattern rules

Use a regular expression when a built-in validator does not fit, for example an agency's own reference format.

{% tabs %}
{% tab title="Builder" %}
1. Open the field and choose **Validation** then **Add pattern rule**.
2. Enter the expression and a sample value. The panel shows a live match result.
3. Write the error message and choose the severity.
{% endtab %}
{% tab title="Expression" %}
```
RULE licence_ref_format
  WHEN NOT MATCHES(applicant.licence_ref, "^LIC-[0-9]{4}-[A-Z]{2}[0-9]{5}$")
  SEVERITY block
  MESSAGE "Enter the licence reference exactly as printed, for example LIC-2026-AB12345."
```

Patterns use the ECMAScript dialect. Anchor with `^` and `$`; unanchored patterns match substrings and are the most common cause of rules that pass unexpectedly.
{% endtab %}
{% endtabs %}

## Cross-field rules

A cross-field rule compares two or more fields. It runs when either field changes and the message is shown on the field named in `ON`.

```
RULE end_after_start
  WHEN applicant.period_end <= applicant.period_start
  ON applicant.period_end
  SEVERITY block
  MESSAGE "The end date must be after the start date."

RULE declared_units_match
  WHEN applicant.units_declared != COUNT(applicant.unit_list)
  ON applicant.units_declared
  SEVERITY warn
  MESSAGE "You declared {{ applicant.units_declared }} units but listed {{ COUNT(applicant.unit_list) }}. Check before continuing."
```

Cross-field rules may reference fields on earlier pages, and may use the same functions as [Calculated fields](calculated-fields.md).

## Asynchronous validation against an agency API

An async rule sends the field value to an agency endpoint and blocks or warns based on the response. Typical uses are checking that a licence is still active, or that a UEN is not on a suspension list.

{% stepper %}
{% step %}
## Register the endpoint
Your agency administrator registers the endpoint under **Integrations** with its APEX or Intranet URL, authentication and a **timeout** (default 3 seconds, maximum 5). See the [Integrator Guide](https://app.gitbook.com/s/XSPACE_INTEGRATOR/) for the request and response contract.
{% endstep %}
{% step %}
## Attach the rule
In the field's **Validation** panel choose **Add async rule**, pick the endpoint and map the field value to the request. Choose which response outcome counts as a failure.
{% endstep %}
{% step %}
## Choose a fallback
Select what happens if the endpoint times out or returns an error: **Allow and flag** (recommended), **Block with retry** or **Warn**. The fallback outcome is written to the submission's audit trail so officers know the check did not complete.
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
Never use **Block with retry** as the fallback for a service with a statutory deadline. If the upstream system is unavailable, applicants would be unable to submit on time. Prefer **Allow and flag** and let the officer re-run the check from the submission view.
{% endhint %}

Async rules run at most once per field change and results are cached for the applicant's session, so an unchanged value is not re-sent when the applicant moves between pages.

## Writing error messages

Applicants act on messages that say what is wrong and what to do next. Follow the house style:

{% columns %}
{% column %}
### Avoid
- "Invalid input."
- "Error: regex mismatch."
- "Field is required!!"
- Blaming language: "You entered the wrong format."
{% endcolumn %}
{% column %}
### Prefer
- "Enter the UEN as shown on your ACRA profile, for example 201912345K."
- "The end date must be after the start date."
- "Enter a Singapore mobile number, such as 9123 4567."
- Plain, sentence case, one sentence, no exclamation marks.
{% endcolumn %}
{% endcolumns %}

Messages support template variables such as `{{ applicant.units_declared }}`, so you can quote the applicant's own value back to them. Keep messages under 160 characters so they also fit in an SMS if the rule is reused in a notification.

<details><summary>Order of validation</summary>

1. Required-field checks.
2. Built-in validators.
3. Pattern rules, in list order.
4. Cross-field rules, in list order.
5. Async rules, in parallel, after all synchronous checks pass.

A field stops at the first `block` failure, so order rules from cheapest to most expensive.

</details>
