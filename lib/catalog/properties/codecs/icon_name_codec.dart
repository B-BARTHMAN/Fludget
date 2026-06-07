import 'package:fludget/catalog/properties/editors/enum_editor.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:flutter/material.dart';

class IconNameCodec extends PropCodec<IconData> {
  const IconNameCodec();

  static const Map<String, IconData> _data = {
    'star': Icons.star,
    'favorite': Icons.favorite,
    'home': Icons.home,
    'settings': Icons.settings,
    'add': Icons.add,
  };
  static const _code = {
    'star': 'Icons.star',
    'favorite': 'Icons.favorite',
    'home': 'Icons.home',
    'settings': 'Icons.settings',
    'add': 'Icons.add',
  };

  @override
  IconData decode(Object? json) => _data[json] ?? Icons.star;

  @override
  String toCode(Object? json) => _code[json] ?? 'Icons.star';

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) => EnumEditor(
    value: value,
    options: _data.keys.toList(),
    onChanged: onChanged,
  );

  @override
  Object? get defaultJson => 'star';
}
