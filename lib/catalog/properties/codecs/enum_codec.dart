import 'package:fludget/catalog/properties/editors/enum_editor.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:flutter/widgets.dart';

class EnumCodec<T extends Enum> extends PropCodec<T> {
  const EnumCodec(this.values, this.fallback, {required this.typeName});

  final List<T> values;
  final T fallback;
  final String typeName;

  T _byName(Object? name) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }

  @override
  T decode(Object? json) => _byName(json);

  @override
  String toCode(Object? json) => '$typeName.${_byName(json).name}';

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      EnumEditor(value: value, options: values, onChanged: onChanged);

  @override
  Object? get defaultJson => fallback.name;
}
