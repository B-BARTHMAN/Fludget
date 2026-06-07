import 'package:fludget/catalog/properties/editors/pending_editor.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:flutter/material.dart';

class AlignmentCodec extends PropCodec<Alignment?> {
  const AlignmentCodec();

  @override
  Alignment? decode(Object? json) {
    if (json is! Map) return null;
    return Alignment(
      (json['x'] as num?)?.toDouble() ?? 0,
      (json['y'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toCode(Object? json) {
    if (json is! Map) return 'null';
    final x = (json['x'] as num?)?.toDouble() ?? 0;
    final y = (json['y'] as num?)?.toDouble() ?? 0;
    return 'Alignment($x, $y)';
  }

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      const PendingEditor(label: 'alignment');
}
