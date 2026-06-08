# Architecture

> This describes the implemented design. Two guiding goals: adding a new widget
> is one registry entry, and a project is a directory of composable components.

## 1. The core idea

Two ideas stacked.

A **component** is not a tree of Flutter widgets. It is a serializable data tree
that gets rendered into Flutter widgets and exported as Dart source:

```
WidgetNode tree  ──buildNode()──►  real Flutter widgets   (the live preview)
                 ──generate()──►   Dart source            (code export)
                 ──toJson()────►   JSON                    (save / load)
```

A **project** is a directory of these components, organized in folders. Each
component is one StatelessWidget's worth of content stored as one JSON file.
Components reference each other by stable id (the composition step), so a `Card`
can contain an `Avatar` without copying it.

Everything below exists to support those two ideas.

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
  project/    the persisted components + storage
  editor/     editing state + UI
```

`catalog/` knows nothing about the rest. `project/` builds on `catalog/`.
`editor/` builds on both. `app/` wires them together. There are no cycles.

## 3. The model (`catalog/model/`)

```dart
/// A single node in a component's tree. Immutable, serializable.
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
`json_serializable` generate equality, `copyWith`, and JSON.

`Component` (the persisted unit — one StatelessWidget's worth of content) lives
in `project/` (see §8).

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

Defs are grouped by category so the catalog stays navigable:

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
  `def.build`. It takes an optional `NodeDecorator` so the editor can wrap each
  node (selection tagging) without the catalog knowing what the wrapping does.
- **`code_generator.dart`** — `generate(root, {className})` emits a
  `StatelessWidget`, mirroring `buildNode` via `def.toCode`. All callbacks are
  emitted as empty lambdas — this is a visualization tool, not an app builder.
- **`normalizer.dart`** — `normalizeNode(node)` drops props and slots a type
  doesn't declare, keeping loaded JSON consistent with the current registry.

Selection outline is **not** baked into `build`; the canvas draws it as an
overlay (via the decorator) so the preview stays a faithful representation of the
real widget.

> **Composition (next step):** these three traversals each gain an injected
> component resolver — `WidgetNode? Function(String type)` returning a referenced
> component's current root, or null for a built-in. Resolution is a plain
> fallback (`widgetRegistry[type]` first, else `resolve(type)`), so the registry
> stays untouched and no widget type is special-cased.

## 8. Persistence (`project/`)

A **project is a directory**, not a file. Folders are real subdirectories and
each **component** is a `<name>.json` file containing `{ id, name, root }`. There
is no manifest — the directory tree is the source of truth for organization.

```
project/
  component.dart            Component model (id + name + root), freezed/json
  loaded_project.dart       in-memory index of a loaded project, freezed
  project_repository.dart    disk <-> LoadedProject, normalizes on load and save
  project_file_service.dart  raw directory IO via dart:io + path
```

A `Component` is what a project used to be: one StatelessWidget's worth of
content, one file. Its `id` is a stable uuid and is what cross-component
references point at, so renaming or moving a file never breaks composition —
names and folder paths are organization/display only.

`LoadedProject` is the in-memory snapshot the repository hands back: `id ->
Component` (the live roots), `id -> folder` (containing folder, `''` for the
project root), and the set of all folder paths (so empty folders survive). It is
derived from disk on load and kept `/`-separated in memory on every platform.

`ProjectFileService` does low-level directory IO and knows nothing about JSON: it
lists project directories, walks a project into raw folder + file entries, writes
and deletes component files, and creates/moves/deletes folders.
`ProjectRepository` parses those entries into `Component`s, runs `normalizeNode`
on each root in and out, and returns a `LoadedProject`. Component rename/move are
done by writing the new file and deleting the old, so the JSON `name` and the
filename never drift.

## 9. State management — cubits (`editor/`, `flutter_bloc`)

Three cubits, clear ownership:

- **`ProjectCubit`** (`editor/project/`) — owns the loaded project: `id ->
  Component` (the live roots, the single source of truth), the folder layout, and
  persistence + CRUD. On launch it bootstraps (ensure the projects root exists;
  if there are none, create a default project with one default component) and
  loads the first project. Every mutation (create/rename/move/delete of
  components and folders) is a filesystem op followed by a reload, so the
  in-memory index always mirrors disk. `saveComponent` writes a component's file
  and updates its in-memory copy.

- **`WorkspaceCubit`** (`editor/workspace/`) — which components are open as tabs,
  and the active one. Each tab is a `(componentId, DocumentCubit)` record; the
  display name is looked up from `ProjectCubit`, so renames reflect for free. It
  seeds a `DocumentCubit` from a component's root when a tab opens, auto-opens
  the first component once the project loads, routes saves through `ProjectCubit`,
  and prunes any tab whose component no longer exists (deleted directly or via a
  deleted folder). Inactive tabs keep their state alive.

- **`DocumentCubit`** (`editor/document/`) — the heart. Owns one open component's
  state and every edit is a pure tree transformation that produces a new root.

```dart
class DocumentState {
  final WidgetNode root;
  final String? selectedId;
  final List<WidgetNode> past;     // undo
  final List<WidgetNode> future;   // redo
}
```

`widget_tree`, `canvas`, `properties`, and `files` are **UI-only** features.
`widget_tree`/`canvas`/`properties` read and command the active `DocumentCubit`;
`files` reads `ProjectCubit` and commands open tabs via `WorkspaceCubit`.
Selecting in the tree sets `selectedId`; canvas and properties both react to it —
which is why selection, outline, and the property panel stay in sync for free.

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
      editors/                string, bool, double, enum, pending, …
  project/
    component.dart            (+ .freezed.dart + .g.dart)
    loaded_project.dart       (+ .freezed.dart)
    project_repository.dart   directory <-> LoadedProject
    project_file_service.dart writable-directory directory IO
  editor/
    project/                  ProjectCubit + ProjectState (the loaded project)
    workspace/                shell · tab bar · left panel · WorkspaceCubit
    document/                 DocumentCubit + tree mutations (no UI)
    files/                    Files explorer (tree, panel, actions, dialogs)
    widget_tree/              Outline (the widget tree of the active component)
    canvas/                   preview area / device frame + selection overlay
    properties/               property panel
    code_view/                exported-code page
```

Keep features small. If a feature grows a second responsibility, split it.

## 11. Editing UX

- **Adaptive layout** (`LayoutBuilder`, ~720px breakpoint): below it, the
  Files/Outline panel is the left drawer and Properties is the end drawer; at or
  above it, the Files/Outline panel is a persistent left column (Properties stays
  an end drawer). Verified down to ~360px.
- **Left panel:** a segmented switch between **Files** (the project's folder tree
  of components — tap a component to open it; per-row menus create/rename/move/
  delete components and folders, all reachable by tap) and **Outline** (the
  widget tree of the active component).
- **Top tab bar:** open components, horizontally scrollable, keyed on component
  id. Names come from the project, so renames show up live.
- **Adding widgets:** the `+` button on a slot (a flat picker for now). Drop is
  allowed only where `SlotArity` permits.
- **Property panel:** generated from the selected node's `Prop` list; each codec
  supplies its own editor.
- **Canvas:** device frame with tap-to-select (hit-tests the tagged node under
  the pointer) and a selection outline drawn as an overlay; zoom and pan planned.

## 12. Dependencies (kept minimal)

| Package                          | Why                                        |
|----------------------------------|--------------------------------------------|
| `flutter_bloc`                   | Cubits — the chosen state management.      |
| `go_router`                      | Routing.                                   |
| `path_provider`                  | Writable directory for projects.           |
| `path`                           | Correct cross-platform path joins/relative.|
| `uuid`                           | Stable node and component ids.             |
| `freezed` / `json_serializable`  | Model equality, `copyWith`, and JSON.      |

Everything else — color picker, edge-insets editor, alignment grid, tabs,
undo/redo, Files explorer, code export — is hand-rolled. Add a dependency only
when it clearly beats writing it, and note why in the PR.

## 13. Deferred (cheap to add later, by design)

- **Component composition:** referencing one component inside another (resolver
  threaded through the `catalog/` traversals, cycle detection, per-class
  multi-component export). The model already carries the stable ids it needs.
- Parameterized components (passing props into your own widgets).
- A categorized "add widget" picker (the slot `+` is flat for now).
- Multi-project switching UI (bootstrap loads the first/default project today).
- Real editors for the `PendingEditor` placeholders (color, alignment, …).
- Reorder-by-drag, move/reparent, and copy/paste of subtrees.
- A `CanvasCubit` for zoom / pan / device size.
- Cupertino catalog (just more `WidgetDef`s).
- `file_picker` for arbitrary import/export locations.