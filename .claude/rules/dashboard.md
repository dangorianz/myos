---
paths:
  - "lib/features/dashboard/**"
  - "test/**/dashboard/**"
  - "integration_test/**/dashboard/**"
---

# Dashboard Standards

The dashboard is MyOS's primary experience. It communicates what matters at a glance. Build only what is in the approved scope; the capabilities below are product direction, not permission to implement them all at once.

## Content

- Prioritize relevant information with a clear hierarchy and minimal scrolling.
- Support quick actions.
- Never add unrelated content to fill space, and never sacrifice readability to fit more widgets.
- The daily summary states facts from real data, for example: "Tienes 3 tareas pendientes y una reunión a las 10:00."
  - No generic filler.
  - It must stay consistent with the underlying modules: no contradictory or stale counts.

## Dashboard widgets

- Each widget defines its identity, title, content, optional primary and secondary actions, empty, error and loading states, and supported sizes.
- Widgets never assume every module is enabled.
- **Sizes**: compact (essentials), medium (summary plus limited detail), expanded (more context or interaction).
  - Only the sizes explicitly defined for each widget are supported.
  - Grid and dimensions come from Figma. No arbitrary resizing.

## Personalization

- **Direction**: users add, remove and reorder widgets, change between supported sizes and restore defaults.
- **Edit mode**:
  - Clearly distinct from view mode.
  - Clear drag handles where appropriate, with visible feedback.
  - Prevents accidental changes and remains accessible.
- **Preferences**:
  - Configuration persists.
  - Never auto-reorder widgets when the user chose a manual order.

## Testing (only for implemented, approved behavior)

Verify:

- Rendering, order, visibility and configuration of widgets.
- State updates and persistence of preferences.
- Empty states.
- Navigation from cards.
- Freshness of displayed data.
