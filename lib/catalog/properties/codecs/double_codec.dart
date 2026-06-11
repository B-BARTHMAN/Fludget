import 'package:fludget/catalog/properties/editors/double_editor.dart';
import 'package:fludget/catalog/properties/prop_codec.dart';
import 'package:flutter/widgets.dart';

/// Codec for a nullable `double` — the example every codec follows. Connects
/// the three forms of a property (JSON <-> live value <-> Dart source) and
/// supplies the editor for this type.
class DoubleCodec implements PropCodec<double?> {
  const DoubleCodec();

  @override
  double? decode(Object? json) => json is num ? json.toDouble() : null;

  @override
  String toCode(Object? json) => json is num ? '${json.toDouble()}' : 'null';

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      DoubleEditor(value: value, onChanged: onChanged);
}
