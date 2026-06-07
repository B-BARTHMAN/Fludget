# Architecture

> This describes the implemented design. The guiding goal is a small, readable
> codebase where **adding a new widget is one registry entry**.

## 1. The core idea

The app is not a tree of Flutter widgets. It is a **serializable data tree** that
gets rendered into Flutter widgets and exported as Dart source.

```
WidgetNode tree  ──buildNode()──►  real Flutter widgets   (the live preview)
                 ──generate()──►   Dart source            (code export)
                 ──toJson()────►   JSON                    (save / load)
```

Everything below exists to support that one pipeline.

## 2. Four layers

The top level maps to the four concerns of the app, with a strict one-way
dependency chain:

```
catalog  ←  project  ←  editor  ←  app
```

```
lib/
  main.dart
  app/        bootstrap · router · theme
  catalog/    the widget system (engine)
  project/    the persisted document + storage
  editor/     editing state + UI
```

`catalog/` knows nothing about the rest. `project/` builds on `catalog/`.
`editor/` builds on both. `app/` wires them together. There are no cycles.

## 3. The model (`catalog/model/`)

```dart
/// A single node in the prototype tree. Immutable, serializable.
@freezed
abstract class WidgetNode with _$WidgetNode {
  const factory WidgetNode({
    required String id,                                 // stable, uuid v4
    required String type,                               // registry key, e.g. "Container"
    @Default(<String, dynamic>{}) Map<String, dynamic> props,
    @Default(<String, List<WidgetNode>>{})
    Map<String, List<WidgetNode>> slots,                // named child lists
  }) = _WidgetNode;

  factory WidgetNode.fromJson(Map<String, dynamic> json) => _$WidgetNodeFromJson(json);
}
```

`props` holds only plain serializable values (numbers, strings, ints for colors,
maps for `EdgeInsets`/`TextStyle`). Children live in **named slots** rather than
one flat list, so a single widget can expose several distinct child positions
(e.g. `IconButton`'s `icon` slot, `Row`'s `children` slot). `freezed` +
`json_serializable` generate equality, `copyWith`, and JSON — the model stays
declarative.

`Project` (the persisted document) lives separately in `project/` (see §8).

## 4. The property system (`catalog/properties/`)

A property type is described by a **codec** that knows everything one property
kind needs: how to decode JSON to a real value, how to emit Dart source, and
which editor widget to show.

```dart
abstract class PropCodec<T> {
  const PropCodec();
  T decode(Object? json);                                   // for the preview
  String toCode(Object? json);                              // for code export
  Widget editor(Object? value, ValueChanged<Object?> onChanged); // for the panel
  Object? get defaultJson => null;
}

/// Binds a property name to a codec. Declared once, referenced in a def's
/// `props` list and inside its `build` / `toCode`.
class Prop<T> {
  const Prop(this.name, this.codec, {this.label});
  final String name;
  final String? label;
  final PropCodec<T> codec;

  T read(WidgetNode node) => codec.decode(node.props[name]);
  String code(WidgetNode node) => codec.toCode(node.props[name]);
}
```

- **`codecs/`** — one `PropCodec` per kind: string, color, double, enum,
  edge_insets, alignment, text_style, icon_name, visual_density.
- **`editors/`** — the Flutter editor widgets codecs return: string, bool,
  double, enum, and a `PendingEditor` placeholder for kinds whose editor isn't
  built yet.

Because codecs return their own editors, the properties panel never branches on
type — it just renders `prop.codec.editor(...)`.

## 5. Widget definitions (`catalog/widgets/`, `catalog/widget_def.dart`)

One `WidgetDef` per supported widget type. This is the backbone of extensibility.

```dart
class WidgetDef {
  WidgetDef({
    required this.type,
    required this.build,
    required this.toCode,
    this.props = const [],
    this.slots = const {},
  });

  final String type;
  final List<Prop<dynamic>> props;
  final Map<String, SlotArity> slots;                       // single / many
  final Widget Function(WidgetNode node, Map<String, List<Widget>> children) build;
  final String Function(WidgetNode node, Map<String, List<String>> children) toCode;
}
```

Defs are grouped by category so the catalog stays navigable and the question
"where does a new widget go?" answers itself:

```
catalog/widgets/
  layout/    container · padding · center · sized_box · row · column
  display/   text · icon
  input/     icon_button
```

**Adding a widget = adding one file here + one line in `registry.dart`.** It
then gets a property editor, a preview, and code export for free.

`SlotArity` and the `.one(slot)` / `.many(slot)` accessors live in
`catalog/slots.dart`; defs read their children through them.

## 6. The registry (`catalog/registry.dart`)

The single most important file. One `WidgetDef` per type, collected into a map:

```dart
final List<WidgetDef> _definitions = [
  textDef, iconDef, containerDef, paddingDef, centerDef,
  sizedBoxDef, rowDef, columnDef, iconButtonDef,
];

final Map<String, WidgetDef> widgetRegistry = {
  for (final def in _definitions) def.type: def,
};
```

## 7. Tree consumers (`catalog/`)

Three small registry-driven traversals, mirror images of each other:

- **`node_builder.dart`** — `buildNode(node)` recursively renders a node into
  real Flutter widgets for the canvas, resolving each slot and calling
  `def.build`.
- **`code_generator.dart`** — `generate(root, {className})` emits a
  `StatelessWidget`, mirroring `buildNode` via `def.toCode`. All callbacks are
  emitted as empty lambdas — this is a visualization tool, not an app builder.
- **`normalizer.dart`** — `normalizeNode(node)` drops props and slots a type
  doesn't declare, keeping loaded JSON consistent with the current registry.

Selection outline is **not** baked into `build`; the canvas draws it as an
overlay so the preview stays a faithful representation of the real widget.

## 8. Persistence (`project/`)

```
project/
  project.dart              Project model (name + root WidgetNode), freezed/json
  project_repository.dart    Project <-> JSON, normalizes on load and save
  project_file_service.dart  raw file IO via dart:io + path_provider
```

`ProjectFileService` reads/writes JSON files in a writable app directory.
`ProjectRepository` maps between `Project` and JSON and runs `normalizeNode` on
the way in and out. Arbitrary-location import/export (`file_picker`) is a later
add.

## 9. State management — cubits (`editor/`, `flutter_bloc`)

Two cubits, clear ownership:

- **`WorkspaceCubit`** (`editor/workspace/`) — the open tabs. Holds a list of
  `DocumentTab` records `(name, DocumentCubit)` and the active index. Opening,
  closing, switching, saving, and creating tabs live here. Inactive tabs keep
  their state alive.

- **`DocumentCubit`** (`editor/document/`) — the heart. Owns one tab's state and
  every edit is a pure tree transformation that produces a new root.

```dart
class DocumentState {
  final WidgetNode root;
  final String? selectedId;
  final List<WidgetNode> past;     // undo
  final List<WidgetNode> future;   // redo
}
```

`widget_tree`, `canvas`, and `properties` are **UI-only** features that read and
command the active `DocumentCubit`. Selecting in the tree sets `selectedId`;
canvas and properties both react to it — which is why selection, outline, and the
property panel stay in sync for free.

Undo/redo is cheap precisely because `WidgetNode` is immutable: history is just a
list of past roots. Pure mutations (`findById`, `updateById`, `addChild`,
`updateProps`, `removeById`) live in `editor/document/tree_ops.dart`.

## 10. Feature map (folder layout)

```
lib/
  main.dart
  app/
    app.dart                  MaterialApp.router + root providers + theme
    router.dart               GoRouter
    routes.dart               route constants
    theme.dart                light + dark ThemeData
  catalog/
    registry.dart             the catalog (one WidgetDef per type)
    widget_def.dart           WidgetDef contract
    slots.dart                SlotArity + child access
    node_builder.dart         WidgetNode -> Widget (preview)
    code_generator.dart       WidgetNode -> Dart source
    normalizer.dart           clean a tree vs the registry
    model/
      widget_node.dart        (+ .freezed.dart + .g.dart)
    widgets/
      layout/ display/ input/ concrete WidgetDefs by category
    properties/
      prop.dart               Prop + PropCodec
      codecs/                 one codec per property kind
      editors/                color, edge_insets, alignment, enum, double, …
  project/
    project.dart              (+ .freezed.dart + .g.dart)
    project_repository.dart   JSON save / load
    project_file_service.dart writable-directory file IO
  editor/
    workspace/                shell + tab bar + WorkspaceCubit
    document/                 DocumentCubit + tree mutations (no UI)
    widget_tree/              left tree view
    canvas/                   preview area / device frame
    properties/               property panel
```

Keep features small. If a feature grows a second responsibility, split it. A
feature can reintroduce a `ui/` subfolder once it outgrows a single folder.

## 11. Editing UX

- **Adaptive layout** (mobile-first): on a phone, the tree and properties are
  reachable via drawers; on wide screens, a 3-pane layout (tree │ canvas │
  properties).
- **Adding widgets:** the `+` button on a slot, or (later) drag from a palette.
  Drop is allowed only where `SlotArity` permits.
- **Property panel:** generated from the selected node's `Prop` list; each codec
  supplies its own editor.
- **Canvas:** device frame today; zoom, pan, and a selection overlay are planned.

## 12. Dependencies (kept minimal)

| Package                          | Why                                        |
|----------------------------------|--------------------------------------------|
| `flutter_bloc`                   | Cubits — the chosen state management.      |
| `go_router`                      | Routing.                                   |
| `path_provider`                  | Writable directory for JSON projects.      |
| `uuid`                           | Stable node ids.                           |
| `freezed` / `json_serializable`  | Model equality, `copyWith`, and JSON.      |

Everything else — color picker, edge-insets editor, alignment grid, tabs,
undo/redo, drag-and-drop, code export — is hand-rolled. Add a dependency only
when it clearly beats writing it, and note why in the PR.

## 13. Deferred (cheap to add later, by design)

- Reorder-by-drag and move/reparent (immutable tree → remove + insert).
- Copy/paste of subtrees.
- Real editors for the `PendingEditor` placeholders (color, alignment, …).
- A palette feature and drag-to-add.
- A `CanvasCubit` for zoom / pan / device size, plus the selection overlay.
- Cupertino catalog (just more `WidgetDef`s).
- `file_picker` for arbitrary import/export locations.