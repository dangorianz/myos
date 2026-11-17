---
paths:
  - "lib/**/*.dart"
  - "pubspec.yaml"
---

# Architecture Standards

Build the simplest architecture that satisfies current requirements while allowing safe evolution. Favor high cohesion, low coupling, testability and offline-first readiness. Do not introduce abstractions without a clear benefit.

## Structure (canonical)

```
lib/
├── main.dart
├── app/            app.dart, router/, theme/
├── core/           constants/, database/, error/, utils/, widgets/
└── features/       dashboard/, finance/, organizer/, goals/
    └── <feature>/  data/, domain/, presentation/
```

Create only the layers a feature's complexity needs. Never create empty layers.

## Dependency direction

`presentation → domain ← data`

- Domain has no Flutter, database or HTTP dependencies; keep it deterministic, immutable where practical and independently testable.
- Presentation never accesses the database directly.
- Data implements domain contracts when an abstraction is needed.
- No circular dependencies.

## Layers

- **Presentation**: renders UI, handles interaction, observes state, shows loading/success/error, delegates business operations. Never contains SQL, persistence, HTTP details, business validation or complex calculations.
- **Domain**: entities, business rules, repository contracts and use cases only when they add clarity (no use-case class per trivial operation).
- **Data**: local persistence, future remote sources, mapping, serialization, repository implementations, infrastructure error handling. Do not leak persistence models to presentation when domain separation is required; map explicitly when representations differ.

## Feature boundaries

- A feature owns its business responsibilities. Features never access another feature's internals; communicate through explicit interfaces, shared domain contracts or app-level coordination.
- Do not couple features to reuse a small utility. Move genuinely shared code to `core/`, but never turn `core/` into a home for business logic.
- Do not duplicate business rules across modules.

## State management (Riverpod)

- Riverpod is the only shared/async state solution; local widget state is for ephemeral presentation state.
- Providers are focused, with clear state ownership and a single source of truth. Avoid unnecessary global state.
- Model async states explicitly. No side effects during build. Dispose resources.

## Navigation (GoRouter)

Centralize route definitions; no hardcoded route strings; validate parameters and handle unknown routes; keep navigation free of business logic; respect platform back-navigation conventions; no circular navigation dependencies.

## Persistence (SQLite + Drift)

- Versioned migrations only; never destructive migrations without an approved recovery plan.
- Stable identifiers, data integrity, handled database errors, persistence isolated from UI.
- No remote synchronization without an approved technical design.

## Error handling

Handle errors at layer boundaries. Never swallow exceptions silently. Translate infrastructure failures into meaningful application errors; never expose technical details to users or log sensitive data.

## Dependency evaluation (canonical)

Before proposing a new package:

1. Check existing project code and the Flutter/Dart SDK.
2. Evaluate maintenance status, compatibility with the installed SDK, and iOS/Android impact.
3. Review known security advisories, license and transitive dependencies.
4. Weigh the added complexity against implementing it.
5. Justify it and obtain approval for significant dependencies.

Never add packages because they are popular. Avoid multiple libraries solving the same problem and abandoned packages for security-sensitive work. Code generation requires an approved dependency decision.

## Significant feature checklist

Before a significant feature: identify affected modules, data ownership, dependencies, persistence needs, business rules, testing strategy, and decisions worth an ADR.

## ADRs

Significant decisions are recorded in `docs/adr/ADR-XXX-<title>.md` (template in `myos-architect`). No ADRs for trivial details.

## Prohibited

- Business logic in widgets or SQL from presentation.
- Silent changes to public contracts.
- Microservices or speculative infrastructure in the Flutter app.
- Dependencies without justification.
