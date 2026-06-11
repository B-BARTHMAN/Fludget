import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/properties/prop_codec.dart';
import 'package:flutter/material.dart';

/// Binds a property [name] to its [codec], a [fallback] used when the value is
/// absent, and an optional display [label]. Declared once as a constant and
/// referenced by object, so the string [name] lives in exactly one place.
class Prop<T> {
  const Prop(this.name, this.codec, {required this.fallback, this.label});

  final String name;
  final PropCodec<T> codec;

  /// The value used when [name] is missing — also the value a freshly added
  /// widget starts with.
  final T fallback;

  /// Shown in the properties panel; falls back to [name] when null.
  final String? label;

  /// The effective typed value of this prop on [node], for the live preview.
  T read(WidgetNode node) => codec.decode(node.props[name]) ?? fallback;

  /// The Dart source for this prop's value on [node], for code export.
  String toCode(WidgetNode node) => codec.toCode(node.props[name]);

  /// An editor for this prop on [node], reporting edits as new JSON values.
  Widget editor(WidgetNode node, ValueChanged<Object?> onChanged) =>
      codec.editor(node.props[name], onChanged);
}
