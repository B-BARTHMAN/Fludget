import 'package:fludget/core/domain/editors/pending_editor.dart';
import 'package:fludget/core/domain/prop.dart';
import 'package:flutter/material.dart';

class TextStyleCodec extends PropCodec<TextStyle?> {
  const TextStyleCodec();

  static const _weights = {
    'normal': FontWeight.normal,
    'bold': FontWeight.bold,
  };
  static const _weightCode = {
    'normal': 'FontWeight.normal',
    'bold': 'FontWeight.bold',
  };

  String _hex(int v) =>
      '0x${v.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  @override
  TextStyle? decode(Object? json) {
    if (json is! Map) return null;
    final color = json['color'];
    return TextStyle(
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      color: color is int ? Color(color) : null,
      fontWeight: _weights[json['fontWeight']],
    );
  }

  @override
  String toCode(Object? json) {
    if (json is! Map) return 'null';
    final parts = <String>[];
    final fs = (json['fontSize'] as num?)?.toDouble();
    if (fs != null) parts.add('fontSize: $fs');
    final color = json['color'];
    if (color is int) parts.add('color: Color(${_hex(color)})');
    final w = _weightCode[json['fontWeight']];
    if (w != null) parts.add('fontWeight: $w');
    return 'TextStyle(${parts.join(', ')})';
  }

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      const PendingEditor(label: 'textStyle');
}
