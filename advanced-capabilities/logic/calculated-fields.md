---
description: "Compute fees, dates and derived values from applicant input with calculated fields, including rounding and SGD formatting."
icon: calculator
---

# Calculated fields

📄 Guide · Updated: 09 Oct 2026 · Freshness: ✅ Current

A calculated field holds a value that <code class="expression">space.vars.product_name</code> works out from other fields rather than from applicant input. Calculated fields are recomputed whenever a source field changes, are read-only to the applicant, and are stored on the submission so that officers and downstream systems see the same figure.

Common uses:

- Application and processing fees
- Expiry dates and processing deadlines
- Totals across a repeating group (for example, number of workers listed)
- Eligibility scores that drive [conditional logic](conditional-logic.md) or routing

## Fee calculation example

A licence fee of S$120 base plus S$35 per unit, with a 10 per cent discount for applications made more than 30 days before the start date.

{% tabs %}
{% tab title="Builder" %}
1. Add a field of type **Calculated** and name it `fee_total`.
2. Set the **Result type** to **Currency (SGD)**.
3. In the **Formula** box use the picker to insert fields and functions. The panel shows a live result using the current test persona.
4. Set **Rounding** to **2 decimal places, half up**.
{% endtab %}
{% tab title="Expression" %}
```
LET base = 120
LET per_unit = 35 * applicant.units
LET subtotal = base + per_unit
LET early = DATEDIFF(applicant.start_date, TODAY(), "days") > 30
ROUND(IF(early, subtotal * 0.9, subtotal), 2)
```

`LET` bindings are local to the formula and are not stored. Only the final expression is written to the field.
{% endtab %}
{% endtabs %}

The formatted value shown to the applicant is `S$328.50` for a 6-unit early application. The stored value is the number `328.5`; formatting is applied at display time.

## Function reference

| Function | Signature | Description |
| --- | --- | --- |
| `SUM` | `SUM(list)` | Adds numeric values in a repeating group, for example `SUM(applicant.workers.salary)`. |
| `COUNT` | `COUNT(list)` | Number of rows in a repeating group. |
| `IF` | `IF(condition, then, else)` | Returns one of two values. Nest for more than two branches, or use `LOOKUP`. |
| `DATEDIFF` | `DATEDIFF(later, earlier, unit)` | Difference between two dates in `"days"`, `"months"` or `"years"`. Negative if `later` is before `earlier`. |
| `DATEADD` | `DATEADD(date, amount, unit)` | Adds a number of days, months or years. Month arithmetic clamps to the last valid day. |
| `TODAY` | `TODAY()` | Current date in Singapore time. |
| `ROUND` | `ROUND(number, places)` | Half-up rounding. Use `ROUNDDOWN` or `ROUNDUP` for statutory rounding rules. |
| `LOOKUP` | `LOOKUP(key, table)` | Reads a value from a **lookup table** maintained under **Service settings**, for example a fee schedule by licence class. |
| `MIN` / `MAX` | `MIN(a, b, ...)` | Smallest or largest of the arguments. |
| `CONCAT` | `CONCAT(a, b, ...)` | Joins text values. Useful for building reference numbers. |

{% hint style="info" %}
Lookup tables are the recommended way to hold fee schedules. A fee change then becomes a table edit with its own change history, rather than a formula edit across several fields.
{% endhint %}

## Date arithmetic

Dates are handled as calendar dates in Singapore time with no time component. Examples:

```
DATEADD(submission.submitted_at, 14, "days")          -- processing deadline
DATEADD(applicant.start_date, 1, "years")             -- licence expiry
DATEDIFF(applicant.dob, TODAY(), "years") >= 18       -- age check
```

`DATEADD` on 31 January plus one month gives 28 (or 29) February rather than an error. If a deadline must fall on a working day, pass the result through `NEXT_WORKING_DAY(date)`, which skips weekends and gazetted Singapore public holidays.

## Rounding and currency

| Setting | Options | Default |
| --- | --- | --- |
| Rounding mode | Half up, half even, down, up | Half up |
| Decimal places | 0 to 4 | 2 for currency |
| Display format | `S$1,234.50`, `SGD 1,234.50`, `1,234.50` | `S$1,234.50` |

{% hint style="warning" %}
Round once, at the end. Rounding intermediate values (for example, rounding the per-unit amount before multiplying) produces totals that disagree with the agency finance system by a few cents, and those discrepancies are difficult to reconcile later.
{% endhint %}

## Using calculated values elsewhere

- **Conditional logic:** `WHEN fee_total > 500 THEN show section "Payment plan"`.
- **Notifications:** `{{ submission.fee_total | currency }}` renders the formatted amount.
- **Routing:** route high-value applications to a senior officer queue in [Workflow automation](../automation/workflow-automation.md).
- **Exports and API:** the raw number is returned in the submission payload; see [API Specs](https://app.gitbook.com/s/XSPACE_API/).

<details><summary>Error handling</summary>

If a formula cannot be evaluated (for example, a source field is empty), the calculated field is **blank** and any validation rule referencing it is skipped. Use `COALESCE(applicant.units, 0)` to supply a default and keep the fee visible while the applicant is still filling in the form.

</details>
