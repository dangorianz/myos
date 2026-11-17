---
paths:
  - "lib/features/finance/**"
  - "test/**/finance/**"
  - "integration_test/**/finance/**"
---

# Financial Data Standards (canonical)

Finance is the highest-risk module. These rules apply to any code that calculates, stores or displays money, including code outside `features/finance/`.

## Representation

- Never use `double` or floating-point arithmetic for monetary values or calculations.
- Use integer minor units (e.g. cents) or an exact decimal type.
- Store the ISO 4217 currency code with every amount.
- Never aggregate different currencies without an explicit conversion.
- Define rounding rules explicitly and apply them in one place.
- Format amounts with regional conventions in presentation only.

## Integrity

- Preserve original transaction values. Never silently modify transaction history.
- Validate amounts (sign, range, precision) before persisting.
- Prevent unintended duplicate operations (for example, double submission).
- Wrap related database changes in a single transaction.
- Protect against accidental data loss on edit or delete.

## Testing

- Prioritize unit tests for income, expense, balance and budget calculations, currency handling, rounding, boundaries and invalid amounts.
- Also test edits and deletions of transactions and their persistence.
- Use exact assertions. Never approximate floating-point matchers for money.
- An incorrect financial result is a CRITICAL defect.
