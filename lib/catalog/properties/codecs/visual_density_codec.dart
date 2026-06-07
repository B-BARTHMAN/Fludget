import 'package:fludget/catalog/properties/editors/enum_editor.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:flutter/material.dart';

class VisualDensityCodec extends PropCodec<VisualDensity> {
  const VisualDensityCodec();

  static const Map<String, VisualDensity> _data = {
    'standard': VisualDensity.standard,
    'comfortable': VisualDensity.comfortable,
    'compact': VisualDensity.compact,
  };
  static const _code = {
    'standard': 'VisualDensity.standard',
    'comfortable': 'VisualDensity.comfortable',
    'compact': 'VisualDensity.compact',
  };

  @override
  VisualDensity decode(Object? json) => _data[json] ?? VisualDensity.standard;

  @override
  String toCode(Object? json) => _code[json] ?? 'VisualDensity.standard';

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) => EnumEditor(
    value: value,
    options: _data.keys.toList(),
    onChanged: onChanged,
  );

  @override
  Object? get defaultJson => 'standard';
}
