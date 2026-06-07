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
3. **The registry is sacred.** Adding a widget type = appending one `WidgetDef`
   (build + toCode + props + slots) and registering it. Never special-case a
   widget type anywhere else.
4. **The model is dumb and serializable.** `WidgetNode.props` holds only plain
   JSON-safe values. Conversion to `Color`/`EdgeInsets`/`TextStyle` happens in
   the codecs at build/codegen time, never in the model.
5. **Architecture is fixed** (see below). Most other things are flexible — prefer
   the change that makes the code smaller and clearer, and explain it in the PR.

## Architecture (hard rule)

Four top-level areas with a strict one-way dependency chain:

```
catalog  ←  project  ←  editor  ←  app
```

```
lib/
  main.dart
  app/        bootstrap · router · theme
  catalog/    the widget system: model · defs · props · registry · render · codegen
  project/    the persisted document + its storage
  editor/     editing state + UI (one folder per feature)
```

- **`catalog/` depends on nothing internal.** It is the engine. Adding a widget
  or a property type touches only `catalog/`.
- **`project/`** holds the `Project` model, the repository, and file IO.
- **`editor/`** holds the cubits and the UI. UI features read and command the
  active cubit; they never duplicate document state.
- **`app/`** wires everything together (providers, router, theme).
- **State:** `WorkspaceCubit` owns the open tabs; one **`DocumentCubit`** per tab
  owns that tab's tree + selection + undo/redo.

### Inside `catalog/`

```
catalog/
  registry.dart          Map<String, WidgetDef> — the hub
  widget_def.dart        the WidgetDef contract
  slots.dart             SlotArity + child access
  node_builder.dart      node -> live Flutter widget (preview)
  code_generator.dart    node -> Dart source
  normalizer.dart        clean a tree against the registry
  model/                 WidgetNode (the serializable tree node)
  widgets/               concrete defs by category: layout/ display/ input/
  properties/            prop.dart + codecs/ + editors/
```

## Adding a widget

1. Create `lib/catalog/widgets/<category>/<name>.dart` with a `WidgetDef`.
2. Add one import and one list entry in `lib/catalog/registry.dart`.

That is the only change. The widget automatically gets a property panel (the
panel reads `props`), a live preview (`build`), and code export (`toCode`).

Categories: **layout** (Container, Padding, Row, Column, …), **display** (Text,
Icon, …), **input** (IconButton, …).

## Adding a property type

A property type is a `PropCodec` plus the editor widget it renders.

1. Add a codec in `lib/catalog/properties/codecs/` implementing `decode`,
   `toCode`, `editor`, and `defaultJson`.
2. If it needs a new editor, add it in `lib/catalog/properties/editors/`.
3. Reference it from a `Prop` in the widget defs that use it.

Never branch on widget type in the properties panel — the panel renders whatever
`PropCodec.editor` returns.

## Editing model

- `WidgetNode` is **immutable**; edits return a new root via `copyWith`. Pure
  tree mutations live in `editor/document/tree_ops.dart`.
- Children live in named **slots** (`Map<String, List<WidgetNode>>`); drop
  targets respect `SlotArity` (`single` / `many`).
- Undo/redo = lists of past/future roots in `DocumentCubit`. Don't mutate in place.

## Code style

- Prefer composition and pure functions over inheritance and stateful helpers.
- Keep `build` methods short; extract sub-widgets.
- `.freezed.dart` / `.g.dart` files sit beside their source. Never edit them by
  hand — run `dart run build_runner build --delete-conflicting-outputs`.

## Dependencies (minimize hard)

Used and expected: `flutter_bloc` (state), `go_router` (routing),
`path_provider` (storage), `uuid` (node ids), `freezed` + `json_serializable`
(model codegen). Hand-roll small UI (color picker, alignment grid, tabs,
drag-and-drop) rather than adding a package. Any new dependency needs a one-line
justification in the PR.

## Don't

- Don't give widgets real functionality or navigation.
- Don't put document logic inside button callbacks or widget `build` methods.
- Don't create large multi-purpose files or god-cubits.
- Don't special-case individual widget types outside the registry.
- Don't make `catalog/` depend on `editor/` or `app/`.
- Don't add a dependency for something small and self-contained.