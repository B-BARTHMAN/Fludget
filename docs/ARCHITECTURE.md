# Architecture

> These are interface sketches to align on, not final code. The goal is a small,
> readable codebase where **adding a new widget is one registry entry**.

## 1. The core idea

The app is not a tree of Flutter widgets. It is a **serializable data tree** that
gets rendered into Flutter widgets and exported as Dart source.

```
WidgetNode tree  ──build()──►  real Flutter widgets   (the live preview)
                 ──toCode()─►  Dart source            (code export)
                 ──toJson()─►  JSON                    (save / load)
```

Everything below exists to support that one pipeline.

## 2. Core domain models (`core/models/`)

```dart
/// A single node in the prototype tree. Immutable.
class WidgetNode {
  final String id;                    // stable, e.g. nanoid/uuid
  final String type;                  // registry key, e.g. "Container"
  final Map<String, Object?> props;   // raw, serializable property values
  final List<WidgetNode> children;

  WidgetNode copyWith({...});          // for immutable edits
}

enum ChildRule { none, single, multiple }

/// Describes one editable property of a widget type.
class PropertySpec {
  final String name;            // "padding", "color", "mainAxisAlignment"
  final PropertyType type;      // drives which editor widget is shown
  final Object? defaultValue;
  final List<Object>? options;  // only for PropertyType.enumValue
}

enum PropertyType {
  doubleValue, string, boolean, color, edgeInsets, alignment, enumValue, textStyle,
}

/// A project = one tab's content. One JSON file on disk.
class Project {
  final String name;
  final WidgetNode root;        // the top-level node (a StatelessWidget body)
}
```

`props` stays as plain serializable values (numbers, strings, ints for colors,
maps for EdgeInsets/TextStyle). Conversion to real `Color`/`EdgeInsets`/`TextStyle`
happens only at build/codegen time. This keeps JSON trivial and the model dumb.

## 3. The widget registry (`core/services/widget_registry.dart`)

The single most important file for extensibility. One `WidgetDefinition` per
supported widget type; the registry is just a `Map<String, WidgetDefinition>`.

```dart
class WidgetDefinition {
  final String type;
  final ChildRule childRule;
  final List<PropertySpec> properties;

  /// Build the live preview widget from a node + its already-built children.
  final Widget Function(WidgetNode node, List<Widget> children) build;

  /// Emit Dart source for this node, given its children's source.
  final String Function(WidgetNode node, List<String> childCode) toCode;
}
```

**Adding a new widget = appending one `WidgetDefinition`.** It automatically
gets a property editor (panel reads `properties`), a preview (`build`), and
code export (`toCode`). No other file needs to change. This is the backbone of
requirement #7.

Starting catalog (Material): `Container`, `Padding`, `Center`, `Align`,
`SizedBox`, `Row`, `Column`, `Stack`, `Expanded`, `Flexible`, `Text`, `Icon`,
`Image`, `Card`, `Divider`.

## 4. Rendering pipeline (`features/canvas/logic/node_builder.dart`)

A small recursive function, registry-driven:

```dart
Widget buildNode(WidgetNode node) {
  final def = registry[node.type]!;
  final children = node.children.map(buildNode).toList();
  return def.build(node, children);
}
```

Selection outline is **not** baked into `build`. The canvas wraps the result in
a transparent overlay that draws a border around the currently selected node's
bounds, so the preview stays a faithful representation of the real widget.

## 5. Code export (`core/services/code_generator.dart`)

Mirror of `buildNode`, registry-driven, producing a `StatelessWidget`:

```dart
String generate(WidgetNode root, {String className = 'MyWidget'}) { ... }
```

All callbacks are emitted as empty lambdas (`onPressed: () {}`), because this is
a visualization tool, not an app builder. Output is a single formatted Dart
string shown in an export view with a copy button.

## 6. State management — cubits (`flutter_bloc`)

Two cubits, clear ownership:

- **`WorkspaceCubit`** (`features/workspace/cubit/`) — the open tabs. Holds a
  list of `DocumentCubit`s (one per tab) and the active index. Opening, closing,
  and switching tabs lives here. Tabs keep their state alive when inactive.

- **`DocumentCubit`** (`features/document/cubit/`) — the heart. Owns one tab's
  state: the `WidgetNode` root, the selected node id, and undo/redo history.
  Every edit (add child, edit property, delete node) is a pure tree
  transformation that produces a new root and pushes the previous root onto an
  undo stack.

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
canvas and properties both react to it — that is why selection, outline, and the
property panel stay in sync for free.

Undo/redo is cheap precisely because `WidgetNode` is immutable: history is just a
list of past roots.

## 7. Persistence (`core/repositories/project_repository.dart`)

- `WidgetNode`/`Project` ⇄ JSON via hand-written `toJson`/`fromJson` (no codegen
  dependency; the model is small).
- `ProjectRepository` saves/loads JSON files using `dart:io` + `path_provider`
  for a writable app directory. Arbitrary-location import/export (`file_picker`)
  is a later add.

## 8. Feature map (folder layout)

```
lib/
  main.dart
  app.dart                         # MaterialApp + root BlocProviders + theme
  core/
    models/                        # WidgetNode, PropertySpec, WidgetDefinition, Project, enums
    services/
      widget_registry.dart         # the catalog (one WidgetDefinition per type)
      code_generator.dart
    repositories/
      project_repository.dart      # JSON save / load
    routing/                       # minimal for now (single workspace screen)
    theme/                         # light + dark ThemeData
  features/
    workspace/                     # adaptive shell + tab bar
      ui/screens/ ui/widgets/
      cubit/                       # WorkspaceCubit
      logic/                       # adaptive layout helpers
    document/                      # the editing state feature (no UI of its own)
      cubit/                       # DocumentCubit
      logic/                       # tree mutations, undo/redo
    widget_tree/                   # left tree view (UI only)
      ui/widgets/ ui/dialogs/
    canvas/                        # preview area, device frame, zoom/pan, outline
      ui/widgets/
      cubit/                       # CanvasCubit (zoom, pan, device size)
      logic/                       # node_builder.dart
    properties/                    # right/bottom property panel
      ui/widgets/
      ui/widgets/editors/          # color, edge_insets, alignment, enum, text_style, double...
    palette/                       # addable-widget catalog + drag sources
      ui/widgets/
    code_export/                   # export view
      ui/screens/
      cubit/
```

Keep features small. If a feature grows a second responsibility, split it.

## 9. Editing UX

- **Adaptive layout** (mobile-first): on a phone, one pane at a time — canvas with
  the tree and properties reachable via a drawer / bottom sheet. On wide screens,
  a 3-pane layout (tree │ canvas │ properties). Driven by `LayoutBuilder` /
  width breakpoints in `workspace/logic`.
- **Adding widgets:** drag from the palette onto a container node (tree or
  canvas), or use the `+` button on a node. Drop is allowed only where
  `ChildRule` permits (e.g. not onto a `Text`).
- **Property panel:** generated from the selected node's `PropertySpec` list;
  each `PropertyType` maps to one editor widget under `properties/ui/widgets/editors/`.
- **Canvas:** resizable device frame, zoom + pan, selection overlay.

## 10. Dependencies (kept minimal)

| Package         | Why                                              |
|-----------------|--------------------------------------------------|
| `flutter_bloc`  | Cubits — the chosen state management.            |
| `path_provider` | Writable directory for JSON projects.            |
| `equatable`     | (Optional) clean value-equality on cubit states. |
| `uuid`/`nanoid` | Stable node ids. (Optional — can hand-roll.)     |
| `go_router`     | routing     |

Everything else — color picker, edge-insets editor, alignment grid, tabs,
undo/redo, drag-and-drop, code export — is hand-rolled. Add a dependency only
when it clearly beats writing it, and note why in the PR.

## 11. Deferred (cheap to add later, by design)

- Reorder-by-drag and move/reparent (immutable tree → remove + insert).
- Copy/paste of subtrees.
- Cupertino catalog (just more `WidgetDefinition`s).
- Stateful root toggle (only matters for code export).
- `file_picker` for arbitrary import/export locations.