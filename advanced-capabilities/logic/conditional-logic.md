---
description: "Show, hide and skip fields, sections and pages in an ApplySG form based on earlier answers, using the rule builder or the expression language."
icon: code-branch
---

# Conditional logic

📄 Guide · Updated: 18 Sep 2026 · Freshness: ✅ Current

Conditional logic lets a single form adapt to each applicant. Instead of maintaining separate forms for residents and non-residents, or for individual and corporate applicants, you keep one form and let <code class="expression">space.vars.product_name</code> decide what to show.

Rules are attached to a **target** (a field, a section or a page) and evaluated every time an applicant changes an answer. A rule has the shape:

```
WHEN applicant.residency == "Non-resident" THEN show section "Work pass details"
```

## What a rule can do

| Action | Applies to | Effect |
| --- | --- | --- |
| `show` / `hide` | Field, section | Toggles visibility. Hidden fields are not validated and are cleared on submission. |
| `require` / `optional` | Field | Changes whether a value is mandatory. |
| `skip` | Page | Removes the page from the applicant's journey and from the progress indicator. |
| `set` | Field | Pre-fills a value (for example, copies a postal code). Applicants can overwrite it unless the field is read-only. |
| `lock` | Field | Makes a field read-only, typically after an officer has verified it. |

{% hint style="info" %}
Hidden and skipped content is still present in the published version. Officers viewing a submission can toggle **Show hidden fields** to see the full form, which is useful when investigating a rule that behaved unexpectedly.
{% endhint %}

## Building a rule

{% tabs %}
{% tab title="Builder" %}
1. Open the target field, section or page and choose **Logic** in the settings panel.
2. Select **Add rule** and pick the action (`show`, `hide`, `skip` and so on).
3. Choose the **source field** and an operator (`equals`, `is one of`, `is empty`, `greater than`, `contains`).
4. Add further conditions with **AND** or **OR**. Mixed groups are bracketed automatically.
5. Save and use **Preview as applicant** to test both branches.

The builder writes the equivalent expression for you. Open the **Expression** tab at any time to inspect it.
{% endtab %}
{% tab title="Expression" %}
Switch the rule editor to **Expression** to type the rule directly:

```
WHEN applicant.residency == "Non-resident"
  AND applicant.employment_status IN ["Employed", "Self-employed"]
THEN show section "Work pass details"
```

Supported operators:

| Operator | Meaning |
| --- | --- |
| `==`, `!=` | Equal, not equal |
| `<`, `<=`, `>`, `>=` | Numeric or date comparison |
| `IN [...]` | Value is one of a list |
| `IS EMPTY`, `IS NOT EMPTY` | Field has or has no value |
| `CONTAINS` | Substring match on text, or membership for checkbox groups |
| `AND`, `OR`, `NOT` | Boolean combination; `NOT` binds tightest, then `AND`, then `OR` |

Field keys are shown in the field settings panel. Keys are stable across versions, so renaming a field label does not break rules.
{% endtab %}
{% endtabs %}

## Evaluation order

Rules are evaluated in a fixed order to keep the result predictable:

1. **Page skip** rules, in page order.
2. **Section** show/hide rules, top to bottom.
3. **Field** rules within each visible section, top to bottom.
4. **Set** and **lock** actions, after all visibility has been resolved.

Where two rules target the same element and conflict, the **last rule in the list wins**. The builder flags conflicts with an amber marker; resolve them rather than relying on ordering.

{% hint style="warning" %}
A rule may only reference fields on the **same page or an earlier page**. Referencing a later page is rejected at save time, because the applicant has not answered it yet.
{% endhint %}

## Worked example: residency branch

{% columns %}
{% column %}
### Before
One form with every question visible. Residents are asked for a work pass number they do not have, and non-residents are asked for an NRIC. Officers report a high rate of "N/A" answers.
{% endcolumn %}
{% column %}
### After
Two rules on the **Identity** section:

```
WHEN applicant.residency == "Resident" THEN show field nric
WHEN applicant.residency == "Non-resident" THEN show field fin
```

and one page-level rule:

```
WHEN applicant.residency == "Resident" THEN skip page "Work pass details"
```
{% endcolumn %}
{% endcolumns %}

## Testing

Use **Preview as applicant** with saved **test personas**. A persona is a set of answers (for example, "Non-resident, employed, Sensitive-Normal attachments") that you can replay after every change. Personas are stored with the draft version and are not published.

<details><summary>Common mistakes</summary>

- **Rule on a required field that is sometimes hidden.** Hidden fields are never validated, so this is safe, but remember the value is cleared on submission.
- **Comparing a number field to a quoted string.** `applicant.units == "3"` compares text; write `applicant.units == 3`.
- **Forgetting the default state.** A section with only a `show` rule is hidden by default. Add `hide` rules only when you need the opposite default.

</details>

See also [Custom validation rules](custom-validation-rules.md) for conditions that block submission rather than change what is shown.
