---
paths:
  - "lib/**/*.dart"
---

# Flutter Implementation Standards

How to implement in Flutter. Architecture boundaries live in `architecture.md`; user-facing UI requirements (tokens, accessibility, states, responsive, motion, i18n) live in `design-system.md`.

## SDK and APIs

- Flutter stable channel.
- Verify API and package compatibility with the installed SDK.
- Avoid deprecated APIs.
- Never upgrade the SDK without approval.
- Follow official Flutter guidance when compatible with project decisions.

## Widgets

- One responsibility per widget; prefer composition and `const` constructors.
- Keep `build` readable and avoid needless nesting.
- Extract a widget when it is reused or improves readability, not by default. No premature generic components and no giant widget files.
- `StatelessWidget` unless the widget owns mutable local state or lifecycle resources (`AnimationController`, `TextEditingController`, `FocusNode`). Dispose everything you own.
- Never manage shared business state with `setState`; use Riverpod.

## Build method

`build` only describes UI. Never put any of these in `build`:

- Database writes or network calls.
- Navigation side effects.
- Uncontrolled async work.
- Shared state mutation.
- Repeated expensive computation.

## Riverpod usage

- `ref.watch` for reactive dependencies, `ref.read` in callbacks.
- Render `AsyncValue` loading/data/error explicitly.
- Manage provider lifecycles; avoid unnecessary global providers.
- Never introduce another state-management framework without approval.

## Async and context

- Handle exceptions and avoid unhandled Futures.
- Prevent duplicate submissions.
- Handle cancellation where relevant.
- Check `context.mounted` before using `BuildContext` after an `await`.
- Never update disposed widgets.

## Layout and scrolling

- Work with constraints (`Expanded`, `Flexible`, `LayoutBuilder`, `SafeArea`, slivers). Do not use `MediaQuery` width as a substitute for understanding constraints.
- Avoid fixed dimensions and absolute positioning that can overflow.
- Use lazy builders (`ListView.builder`, `SliverList`, ...) for large collections. Avoid nested scroll views with conflicting gestures.

## Performance

- Use `const`, avoid needless rebuilds, and size images appropriately.
- Dispose controllers and subscriptions.
- Measure before optimizing; no optimizations based on assumptions.

## Forms

- Validate fields with understandable messages.
- Use appropriate keyboard types and input actions; handle keyboard dismissal.
- Never clear input after a failed submission.

## Theming and assets

- Styles come from the centralized theme (`ThemeData`, `ColorScheme`, `TextTheme`, tokens). Never hardcode repeated colors, text styles or spacing.
- Organize and register assets, prefer vectors, handle missing images, and never embed large images in source.

## Errors

- No stack traces or technical details in the UI.
- Offer retry where appropriate.
- Handle offline scenarios gracefully.
- Log technical failures without sensitive data.

## Platform

- Every change must work on iOS and Android. Avoid platform-specific APIs unless necessary.
- For native integration: document why, check platform support and required permissions, note the maintenance cost, and get approval.

## Strings

Never hardcode user-facing strings once localization infrastructure exists. Use the approved localization approach; never add a new i18n framework without approval.
