# CLAUDE.md

Project guide for AI assistance and contributors. Read this before proposing or
writing code. Full detail lives in [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## What this is

A cross-platform Flutter tool for **prototyping and visualizing widgets** by
composing standard Flutter widgets. It is **not** an app builder — it produces
visual layouts and exportable Dart code, not working apps.

Targets: iOS, Android, macOS, Windows, Linux. Material first (Cupertino later).

## Golden rules

1. **No real behavior.** All interactive callbacks are empty lambdas
   (`onPressed: () {}`). Buttons, switches, and fields are visual only.
2. **Small everything.** Small files, small functions, small features. If a file
   or feature grows a second responsibility, split it.
3. **The registry is sacred.** Adding a widget type = appending one
   `WidgetDefinition` (build + toCode + properties) and nothing else. Never
   special-case a widget type elsewhere in the codebase.
4. **The model is dumb and serializable.** `WidgetNode.props` holds only plain
   JSON-safe values. Convert to `Color`/`EdgeInsets`/`TextStyle` at build/codegen
   time, never in the model.
5. **Architecture is fixed** (see below). Most other things are flexible — prefer
   the change that makes the code smaller and clearer, and explain it in the PR.

## Architecture (hard rule)

Feature-first. `core/` holds shared building blocks; `features/` holds features,
each split into `ui/` (`screens/`, `widgets/`, `dialogs/`), `cubit/`, `logic/`
(omit a folder a feature doesn't need).

```
lib/core/        models · services · repositories · routing · theme
lib/features/    workspace · document · widget_tree · canvas · properties · palette · code_export
```

- **State:** cubits via `flutter_bloc`. `WorkspaceCubit` owns the open tabs;
  one **`DocumentCubit`** per tab owns that tab's tree + selection + undo/redo.
- `widget_tree`, `canvas`, `properties`, `palette` are UI-only and read/command
  the active `DocumentCubit`. Don't duplicate document state in them.
- The recursive `WidgetNode → Widget` builder lives in `canvas/logic`; the
  registry of definitions lives in `core/services`.

## Editing model

- `WidgetNode` is **immutable**; edits return a new root via `copyWith`.
- Undo/redo = lists of past/future roots in `DocumentCubit`. Don't mutate in place.
- Drop targets respect `ChildRule` (none / single / multiple).

## Code style

- Prefer composition and pure functions over inheritance and stateful helpers.
- Property editors map `PropertyType → editor widget` — add a type, add an editor;
  don't branch on widget type in the panel.
- Keep `build` methods short; extract sub-widgets into `ui/widgets/`.

## Dependencies (minimize hard)

Allowed and expected: `flutter_bloc`, `path_provider`, optionally `equatable`
and a uuid/nanoid helper. **Everything else is hand-rolled** (color picker,
edge-insets editor, alignment grid, tabs, drag-and-drop, code export). Adding a
new dependency requires a one-line justification in the PR.

## Don't

- Don't give widgets real functionality or navigation.
- Don't put business/document logic inside button callbacks or widget `build`.
- Don't create large multi-purpose files or god-cubits.
- Don't special-case individual widget types outside the registry.
- Don't add a dependency for something small and self-contained.