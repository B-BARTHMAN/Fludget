import 'package:fludget/core/domain/editors/double_editor.dart';
import 'package:fludget/core/domain/prop.dart';
import 'package:flutter/widgets.dart';

class DoubleCodec extends PropCodec<double?> {
  const DoubleCodec({this.fallback});

  final double? fallback;

  @override
  double? decode(Object? json) => (json as num?)?.toDouble() ?? fallback;

  @override
  String toCode(Object? json) => decode(json)?.toString() ?? 'null';

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      DoubleEditor(value: value, onChanged: onChanged);

  @override
  Object? get defaultJson => fallback;
}
