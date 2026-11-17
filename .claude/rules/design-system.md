---
paths:
  - "lib/app/*.dart"
  - "lib/app/theme/**"
  - "lib/core/widgets/**"
  - "lib/**/presentation/**"
  - "test/**/presentation/**"
---

# Design System Standards

MyOS ("Organiza tu vida, a tu manera.") must feel like one cohesive, premium, calm application: simple, clear, organized, trustworthy, personal. It is mobile-first: one-handed use, comfortable touch targets, readable type, native platform expectations. Lead with content, not decoration (no gratuitous gradients, effects or empty decorative areas). Equivalent components behave identically. Use progressive disclosure: essentials first, advanced options on demand.

## Source of truth

- Approved Figma designs are the visual source of truth; approved values take precedence over everything below.
- When Figma is available: inspect the approved design, extract properties, identify reusable components, compare the implementation and report differences.
- Never invent measurements. If exact values are unavailable, use approved tokens and state the assumption.
- Changing established patterns or approved designs requires justification and authorization.

## Tokens (provisional until confirmed in Figma)

| Group | Values |
|---|---|
| Brand | primary `#6366F1`, primaryDark `#4F46E5` |
| Light neutrals | background `#F8FAFC`, surface `#FFFFFF`, textPrimary `#0F172A`, textSecondary `#64748B` |
| Module accents | finance `#10B981`, productivity `#3B82F6`, goals `#8B5CF6`, calendar `#F97316` |
| Status | success `#10B981`, warning `#F59E0B`, error `#EF4444` |
| Spacing | 4, 8, 12, 16, 24, 32, 40, 48 (named: xs 4, sm 8, md 16, lg 24, xl 32, xxl 48); smaller steps allowed for visual precision |
| Radius | small 8, medium 16, large 24, extraLarge 32 (large dashboard cards per Figma) |
| Typography | approved modern sans-serif; styles Display, Headline, Title, Body, Label, Caption via `TextTheme` |

- Reference semantic tokens (`primary`, `onPrimary`, `surface`, `onSurface`, `onSurfaceVariant`, `success`, `warning`, `error`, `financeAccent`, `productivityAccent`, `goalsAccent`, `calendarAccent`), never raw values. No per-component ad-hoc colors, sizes or text styles.
- Tokens live under `lib/app/theme/` (e.g. `myos_theme.dart`, `myos_colors.dart`, `myos_typography.dart`, `myos_spacing.dart`, `myos_radius.dart`; names are suggestions). Inspect what exists first and never duplicate theme infrastructure.

## Dark mode, elevation, icons

- **Dark mode**: light and dark themes are both required.
  - Use approved dark tokens. Never invert colors and never hardcode white surfaces or black text.
  - Adapt shadows and borders, keep module identity, and respect the system theme.
- **Elevation**: subtle and consistent levels, clean surfaces, adapted for dark mode. Elevation must never be the only interactivity cue.
- **Icons**: one consistent icon system (stroke, size, semantic colors).
  - Label icons that carry meaning.
  - Prefer existing icons over custom artwork.
  - No emoji as production icons; emoji in user content is fine.

## Shared components

Create shared components (e.g. `MyOSCard`, `MyOSButton`, `MyOSTextField`, `MyOSBottomSheet`, `MyOSEmptyState`, `MyOSErrorState`, `MyOSLoadingState`, `MyOSSectionHeader`) when real reuse appears. Never build a large library upfront, and never create two components for the same pattern.

## Navigation and quick actions

- **Bottom navigation** with destinations Inicio, Finanzas, Organizar, Objetivos.
  - The selected destination is clearly indicated.
  - Respect safe areas, keep touch targets accessible, never overcrowd the bar.
- **Central action button** opens a consistent bottom sheet of creation actions (expense, income, task, event, note).
  - It is not a navigation destination.
  - Never expose actions for unavailable features without clear behavior.

## Forms and feedback

- **Forms**:
  - Clear labels and minimal required fields.
  - Appropriate keyboards and clear primary actions.
  - Visible validation, input preserved on error.
  - No needless confirmation steps; optimize frequent actions.
- **Feedback states**: every relevant screen or component considers initial, loading, success, error, empty, disabled and (when applicable) offline states.
  - Use consistent feedback components; never design only the happy path.
  - Prefer non-intrusive feedback for routine actions and avoid unnecessary dialogs.

## Accessibility (canonical)

WCAG 2.2 AA is the reference. Accessibility is never sacrificed for visual fidelity. Requirements:

- Sufficient contrast.
- System text scaling, with no fixed-height text containers that clip.
- Comfortable touch targets.
- Semantic labels via `Semantics`; screen-reader support.
- No color-only communication.
- Reduced-motion support.
- Focus accessibility where applicable.

## Responsive, motion, internationalization

- **Responsive**: support small and large phones, densities, safe areas and cutouts, keyboard insets, text scaling and orientation. Avoid fixed dimensions that overflow.
- **Motion**: subtle, consistent durations, used to communicate state changes. Never decorative-only or performance-heavy; respect reduced-motion settings.
- **Internationalization**: translatable text and regional date, number and currency formats. Layouts never depend on fixed text length.

## Visual validation

Before approving UI, compare against approved Figma:

- Typography, colors, spacing and radius.
- Component behavior.
- Light and dark themes.
- Small screens and text scaling.
- Key interactive states.

Never claim pixel-perfect fidelity without a visual comparison.
