import 'package:fludget/catalog/properties/editors/string_editor.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:flutter/widgets.dart';

class StringCodec extends PropCodec<String> {
  const StringCodec({this.fallback = ''});

  final String fallback;

  @override
  String decode(Object? json) => json is String ? json : fallback;

  @override
  String toCode(Object? json) {
    final v = decode(json).replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    return "'$v'";
  }

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      StringEditor(value: value, onChanged: onChanged);

  @override
  Object? get defaultJson => fallback;
}
