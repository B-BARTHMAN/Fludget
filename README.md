# Widget Composer

A cross-platform Flutter tool for **prototyping and visualizing widgets**. Compose
standard Flutter widgets into a tree, see them rendered live, edit their
properties, and export the result as Dart code.

It is a design/visualization tool, not an app builder — interactive elements are
intentionally non-functional (empty callbacks).

## Features

- Visual **widget tree** with select / add / delete / edit.
- Live **canvas** preview in a resizable device frame with zoom and pan.
- **Property editing** with purpose-built editors (color picker, padding/margin,
  alignment grid, enum dropdowns, text style, and more).
- **Add widgets** by drag-and-drop from the palette or via a `+` button.
- **Undo / redo.**
- **Multiple projects** open in tabs.
- **Save / load** projects as JSON.
- **Export** the composed tree to a Flutter `StatelessWidget`.

## Platforms

iOS · Android · macOS · Windows · Linux. (Web is not a target.)

## Tech

Flutter (stable) · cubits via `flutter_bloc` · minimal dependencies.

## Getting started

```bash
# clone, then:
flutter pub get
flutter run -d macos     # or windows / linux / chrome-less mobile device
```

If scaffolding from scratch:

```bash
flutter create --platforms=ios,android,macos,windows,linux --org com.yourname widget_composer
```

## Project structure

Feature-first. `lib/core` holds shared models, services, repositories, routing,
and theme; `lib/features` holds small, focused features (`workspace`, `document`,
`widget_tree`, `canvas`, `properties`, `palette`, `code_export`), each with
`ui/`, `cubit/`, and `logic/` as needed.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full design and
[`CLAUDE.md`](CLAUDE.md) for contribution conventions.

## Contributing

The codebase favors small files and small features. The key extension point: to
support a new widget, add one `WidgetDefinition` to the registry (build + code
generation + properties) — nothing else should need to change. Please read
`CLAUDE.md` first.

## License

TODO: choose a license before publishing (MIT and Apache-2.0 are common choices
for shared Flutter projects).