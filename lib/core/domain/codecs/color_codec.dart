import 'package:fludget/core/domain/editors/pending_editor.dart';
import 'package:fludget/core/domain/prop.dart';
import 'package:flutter/material.dart';

class ColorCodec extends PropCodec<Color?> {
  const ColorCodec();

  String _hex(int v) =>
      '0x${v.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  @override
  Color? decode(Object? json) => json is int ? Color(json) : null;

  @override
  String toCode(Object? json) => json is int ? 'Color(${_hex(json)})' : 'null';

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      const PendingEditor(label: 'color');
}
