# Widget Composer

A cross-platform Flutter tool for **prototyping and visualizing widgets**. Compose
standard Flutter widgets into a tree, see them rendered live, edit their
properties, and export the result as Dart code.

It is a design/visualization tool, not an app builder — interactive elements are
intentionally non-functional (empty callbacks).

## Features

- Visual **widget tree** with select / add / delete / edit.
- Live **canvas** preview in a resizable device frame.
- **Property editing** with purpose-built editors (color picker, padding/margin,
  alignment grid, enum dropdowns, text style, and more).
- **Add widgets** via a `+` button on a slot (drag-from-palette planned).
- **Undo / redo.**
- **Multiple projects** open in tabs.
- **Save / load** projects as JSON.
- **Export** the composed tree to a Flutter `StatelessWidget`.

## Platforms

iOS · Android · macOS · Windows · Linux. (Web is not a target.)

## Tech

Flutter (stable) · cubits via `flutter_bloc` · `go_router` · `freezed` +
`json_serializable` for the model · `uuid` · `path_provider`. Minimal
dependencies; small UI is hand-rolled.

## Getting started

```bash
# clone, then:
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d macos     # or windows / linux / a mobile device
```

If scaffolding from scratch:

```bash
flutter create --platforms=ios,android,macos,windows,linux --org com.yourname fludget
```

## Project structure

Four layers with a strict one-way dependency chain
(`catalog ← project ← editor ← app`):

```
lib/
  main.dart
  app/        bootstrap · router · theme
  catalog/    the widget system: model · defs · props · registry · render · codegen
  project/    the persisted document + storage
  editor/     editing state + UI (workspace · document · widget_tree · canvas · properties)
```

`catalog/` is the engine and depends on nothing internal. Concrete widget
definitions live under `catalog/widgets/` grouped by category (`layout/`,
`display/`, `input/`); the property-type system (codecs + editors) lives under
`catalog/properties/`.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full design and
[`CLAUDE.md`](CLAUDE.md) for contribution conventions.

## Contributing

The codebase favors small files and small features. The key extension point: to
support a new widget, add one `WidgetDef` file under
`lib/catalog/widgets/<category>/` and register it with one line in
`lib/catalog/registry.dart` — nothing else needs to change. Please read
`CLAUDE.md` first.

## License

TODO: choose a license before publishing (MIT and Apache-2.0 are common choices
for shared Flutter projects).