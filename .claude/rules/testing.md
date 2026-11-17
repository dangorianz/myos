---
paths:
  - "test/**"
  - "integration_test/**"
---

# Testing Standards

Tests validate requirements and behavior, not implementation details. Quality is measured by defects prevented, not by test count or coverage percentage.

## Strategy

- Most business rules: fast unit tests. UI behavior: widget tests. Critical end-to-end flows: `integration_test`.
- Mirror the `lib/` structure under `test/` (e.g. `test/features/finance/domain/...`) so path-scoped rules apply.
- Use official Flutter tooling (`flutter_test`, `integration_test`); additional test frameworks need approval.

## Unit tests

- Cover calculations, validations, transformations, domain rules, state transitions and error handling.
- Include positive, negative and boundary cases.
- Follow Arrange, Act, Assert.

## Widget tests

- Verify behavior (interactions, forms, validation, loading/empty/error states, conditional rendering), not mere existence.
- Use stable selectors: Keys, types, `Semantics`. Avoid finders that break with localization.

## Integration tests

- Use isolated data and never production environments.
- Clean up safely and assert outcomes.
- Use proper synchronization, never arbitrary delays.
- Run them when acceptance criteria require it and the device/environment is available.

## Riverpod and navigation

- Use isolated `ProviderContainer`s with controlled overrides.
- Verify initial state, transitions, async loading, success, error and recovery.
- For GoRouter, verify valid navigation, required parameters, back navigation and unknown routes, without coupling to router internals.

## Persistence (Drift/SQLite)

- Use isolated in-memory or temporary databases.
- Verify CRUD, constraints, integrity, migrations, restarts and error handling.
- Never touch real user data.

## Accessibility and goldens

- **Accessibility checks**: semantic labels, text scaling, touch targets, focus, screen-reader information. Automated checks do not replace manual review.
- **Golden tests**: only for stable, visually important components, with controlled viewport, fonts, animations and data. Never update goldens automatically to hide a regression.

## Test data and doubles

- **Test data**: synthetic, deterministic, isolated and relevant. Never real credentials, tokens, personal data or production financial records. Use factories or fixtures when they help.
- **Test doubles**: prefer real domain logic. Fake or mock only external services, database boundaries, platform integrations, time and network. Never write tests that only verify mock calls.

## Independence and naming

- Each test is repeatable on its own. Tests never depend on execution order, shared mutable state, real accounts, network, uncontrolled time or sleeps.
- Names state scenario and expected behavior (e.g. `rejects transaction with invalid amount`); never `test1` or `works`.

## Coverage

- Measure with `flutter test --coverage` when requested.
- Prioritize business rules, validation, state transformations and persistence.
- No arbitrary 100% target. Thresholds only after analysis and approval. Never claim coverage without measuring.

## Regression and failures

- Every confirmed defect is evaluated for a regression test: reproduce it, write a failing test, fix, verify, run related tests.
- When a test fails: reproduce it, find the root cause and decide whether the implementation or the test is wrong. Report and coordinate the fix.
- Never delete a test, weaken an assertion or match incorrect behavior to make a run pass.

## Completion criteria (canonical)

A feature is complete when:

1. Acceptance criteria are met.
2. Relevant tests pass.
3. Analysis and formatting pass.
4. No blocking defects remain.
5. Limitations are documented.
6. Required reviews are done.

Report any check that could not run, and never declare full validation while checks are pending.
