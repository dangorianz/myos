# MyOS — Project Instructions

## Product

MyOS is a personal life-management mobile app for iOS and Android, built with Flutter and Dart and distributed through the App Store and Google Play.

Vision: "Organiza tu vida, a tu manera."

Modules: Dashboard, Personal Finance, Tasks, Calendar, Goals, Habits, Notes.

Priorities, in order:

1. User experience.
2. Simplicity.
3. Customization.
4. Privacy.
5. Reliability.
6. Maintainability.
7. Accessibility.
8. Performance.

Never trade correctness for speed.

## Scope

- The initial product is free. Do not implement subscriptions, payments or monetization without explicit requirements.
- Build only approved requirements. No speculative functionality, no work outside the requested scope.
- Current phase: the Flutter app only (design and dashboard first). Do not implement backend services until explicitly requested.

## Stack

- App: Flutter (stable), Dart, Riverpod, GoRouter, Material 3.
- Local persistence: SQLite + Drift.
- Future backend (not started): NestJS, PostgreSQL, REST.

These are approved directions, not permission to install packages. Evaluate every new dependency with the checklist in `.claude/rules/architecture.md`.

## Architecture

- Pragmatic feature-first layout: `lib/app`, `lib/core`, `lib/features/<feature>/{data,domain,presentation}`.
- Apply SOLID, DRY, KISS and YAGNI pragmatically.
- Create only the layers a feature needs; no unnecessary abstractions.
- Canonical structure and layer rules: `.claude/rules/architecture.md`.

## Rules

`.claude/rules/git-workflow.md` is always loaded. The other rules load automatically when a matching file is read or edited:

| Rule | Loads for | Covers |
|---|---|---|
| `architecture.md` | `lib/**/*.dart`, `pubspec.yaml` | structure, layers, state, navigation, persistence, dependencies, ADRs |
| `dart.md` | Dart in `lib/`, `test/`, `integration_test/` | language standards |
| `flutter.md` | `lib/**/*.dart` | Flutter implementation practices |
| `design-system.md` | theme, `core/widgets`, `presentation/` | tokens, components, accessibility, visual validation |
| `testing.md` | `test/**`, `integration_test/**` | test strategy, completion criteria |
| `security.md` | data layer, database, network, auth, `android/`, `ios/`, `pubspec.yaml` | privacy, storage, credentials, network |
| `finance.md` | finance feature and tests | monetary precision and integrity |
| `dashboard.md` | dashboard feature and tests | dashboard content, widgets, personalization |

When you plan, design or review without opening matching files, read the applicable rule explicitly. If rules conflict, report the conflict and ask.

## Non-negotiable constraints

These apply everywhere, even when no rule file is loaded:

- Money is never a `double`. Use integer minor units or exact decimals, and store the ISO currency code (see `finance.md`).
- Never hardcode secrets or credentials. Never log sensitive data (financial records, notes, tokens, personal data).
- No analytics, telemetry or third-party data transfer without approval.
- No destructive data operations (deletion, destructive migrations) without approval.
- Figma: never invent measurements, and never claim Figma was inspected if the integration was unavailable. Request the reference instead.
- Never claim a test or check passed unless it was executed.

## Autonomy policy

Classify every task:

- **SMALL**: minor visual tweaks, text changes, local bug fixes. Implement directly within scope.
- **MEDIUM**: new widgets or screens, changes inside an existing module. Give a concise plan, then proceed if requirements are clear and no approval-sensitive decision exists.
- **LARGE**: new modules, architectural changes, database schema changes or migrations, authentication, synchronization, external integrations, significant dependencies, security-sensitive work. Present a technical plan and wait for explicit approval.

Never treat silence as approval. When important information is missing, ask focused questions.

## Agent coordination

The main conversation coordinates: it analyzes, classifies, plans, delegates, consolidates results and verifies completion. There is no orchestrator agent.

| Agent | Use for | Never |
|---|---|---|
| `myos-architect` | boundaries, contracts, persistence and schema design, dependency evaluation, ADR drafts, technical risk | edits files |
| `myos-uiux` | Figma analysis, visual and interaction specs, UX and accessibility evaluation, design consistency | edits files or business logic |
| `myos-flutter` | implementing Flutter code and its initial tests | changes approved architecture or design on its own |
| `myos-flutter-qa` | independent tests from requirements, test execution, defect reports | edits outside `test/` and `integration_test/` |
| `myos-flutter-reviewer` | independent review of diffs and verdict | edits code or tests |

<!-- myos-backend: planned for the backend phase, after dashboard design and Flutter implementation. Not created yet; do not delegate backend work until it exists. -->

How to delegate:

- Use the minimum coordination needed. SMALL tasks rarely need an agent, and not every task needs every agent.
- Typical significant-feature flow:
  1. `myos-architect`, if architecture, persistence or contracts are affected.
  2. `myos-uiux`, for significant UI.
  3. `myos-flutter`.
  4. `myos-flutter-qa`, for important functionality.
  5. `myos-flutter-reviewer`, for significant changes.
  6. Verify the completion criteria.
- Subagents do not see this conversation. Every brief states the objective, context, files or modules involved, constraints, acceptance criteria and expected deliverable.
- Never let two agents edit the same files concurrently. Use worktrees for parallel implementation.
- Architect and UI/UX are read-only. The main conversation writes their approved ADRs and specs to `docs/`.

## Workflow

- **Before**: understand the requirement, inspect existing code and reusable components, read applicable rules, identify affected modules and testing needs, and get approval when required.
- **During**: respect the architecture, keep changes focused, preserve unrelated changes, add relevant tests.
- **After**: run the quality gates, review the diff, report.

## Quality gates

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

- Run integration tests and coverage when the acceptance criteria require them and the environment allows.
- If a check cannot run, report why.
- Significant functionality is not complete while blocking defects remain. Completion criteria: `.claude/rules/testing.md`.

## Severity scale

Shared by QA, review and UX findings:

- **CRITICAL**: data loss or corruption, security vulnerability, incorrect financial result, core task impossible.
- **HIGH**: important function broken, significant regression, serious architecture or security risk, major user confusion.
- **MEDIUM**: incorrect behavior with a workaround, demonstrated maintainability problem, violation of an approved rule, relevant UX friction.
- **LOW**: minor visual, consistency or clarity improvement.

## Documentation

- Project documentation lives in `docs/` (`architecture/`, `adr/`, `features/`, `design/`).
- Record significant architectural decisions as ADRs (template in `myos-architect`).
- Do not generate unnecessary documentation.

## Communication

- Speak to the user in Spanish.
- Use English for code identifiers, file names, technical interfaces, commit messages and code documentation.
- Explain decisions clearly, avoid verbosity, and never invent results.

## Task completion format

End every development task with:

### Resultado
What was implemented.

### Archivos modificados
Relevant files.

### Validaciones
Checks executed and their results.

### Riesgos
Known limitations.

### Estado
COMPLETADO / PARCIAL / BLOQUEADO.
