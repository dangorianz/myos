---
paths:
  - "lib/**/*.dart"
  - "test/**/*.dart"
  - "integration_test/**/*.dart"
---

# Dart Standards

Follow Effective Dart. Favor clarity and correctness over cleverness; use modern features (records, patterns, switch expressions, sealed classes, enhanced enums, extensions) only when they make code clearer.

## Naming

- `UpperCamelCase`: classes, enums, extensions, typedefs.
- `lowerCamelCase`: variables, functions, parameters, constants.
- `lowercase_with_underscores`: files and directories.
- Descriptive names; no unnecessary abbreviations.

## Types and null safety

- Avoid `dynamic` and unnecessary casts.
- Use explicit types where they aid clarity.
- Validate nullable values instead of using `!`.
- Never suppress type errors without a documented reason.

## Immutability

- Prefer `final`, `const` and immutable models.
- Return updated copies instead of mutating shared state.
- No mutable global state.

## Constructors and functions

- Use named parameters with `required` where they clarify intent.
- Prefer `const` constructors and validate invariants.
- Keep functions focused, with early returns and no hidden side effects.
- Avoid boolean parameters that obscure intent.
- Do not over-split simple functions.

## Async

- Prefer `async`/`await`.
- Never leave Futures unhandled.
- Manage and cancel Stream subscriptions.
- Do not block the UI isolate.
- Never use arbitrary delays to coordinate async work.

## Exceptions

- Catch specific exceptions, and only when there is a recovery strategy.
- Use `rethrow` to preserve stack traces.
- Never swallow errors or use exceptions for control flow.
- Never expose sensitive data in error messages.

## Collections, extensions, models

- Use `map`, `where`, `fold` and similar when they express intent; use loops when clearer.
- Avoid needless intermediate collections.
- Extensions must be cohesive, non-trivial and must not hide business logic.
- Models: immutable, meaningful equality when needed, persistence and presentation concerns kept apart, serialization isolated.

## Documentation

Use `///` for public APIs with non-obvious behavior, complex business rules and non-trivial algorithms. Do not write comments that restate the code.

## Analysis

- Follow `analysis_options.yaml`.
- Fix the underlying issue rather than suppressing a lint.
- Every suppression needs a justification.
- Do not use deprecated language features.
