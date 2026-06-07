import 'package:fludget/catalog/model/widget_node.dart';
import 'package:flutter/widgets.dart';

/// Everything one property *kind* needs to know about itself
abstract class PropCodec<T> {
  const PropCodec();

  /// Stored JSON value -> real Flutter value (used when building the preview).
  T decode(Object? json);

  /// Stored JSON value -> Dart source (used for code export).
  String toCode(Object? json);

  /// The editor widget shown in the properties panel.
  Widget editor(Object? value, ValueChanged<Object?> onChanged);

  /// Default JSON-safe value when a node hasn't set this prop.
  Object? get defaultJson => null;
}

/// Binds a property name to a codec. Declared once, referenced in the def's
/// `props` list and inside its `build`/`toCode`.
class Prop<T> {
  const Prop(this.name, this.codec, {this.label});

  final String name;
  final String? label;
  final PropCodec<T> codec;

  T read(WidgetNode node) => codec.decode(node.props[name]);
  String code(WidgetNode node) => codec.toCode(node.props[name]);
  Object? get defaultJson => codec.defaultJson;
}
