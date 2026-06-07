import 'package:fludget/core/domain/editors/pending_editor.dart';
import 'package:fludget/core/domain/prop.dart';
import 'package:flutter/material.dart';

class EdgeInsetsCodec extends PropCodec<EdgeInsets?> {
  const EdgeInsetsCodec({this.fallback});

  final double? fallback;

  double _n(Map<dynamic, dynamic> m, String k) =>
      (m[k] as num?)?.toDouble() ?? 0;

  @override
  EdgeInsets? decode(Object? json) {
    if (json is num) return EdgeInsets.all(json.toDouble());
    if (json is Map) {
      return EdgeInsets.fromLTRB(
        _n(json, 'left'),
        _n(json, 'top'),
        _n(json, 'right'),
        _n(json, 'bottom'),
      );
    }
    return fallback == null ? null : EdgeInsets.all(fallback!);
  }

  @override
  String toCode(Object? json) {
    if (json is num) return 'EdgeInsets.all(${json.toDouble()})';
    if (json is Map) {
      return 'EdgeInsets.fromLTRB(${_n(json, 'left')}, ${_n(json, 'top')}, '
          '${_n(json, 'right')}, ${_n(json, 'bottom')})';
    }
    return fallback == null ? 'null' : 'EdgeInsets.all($fallback)';
  }

  @override
  Widget editor(Object? value, ValueChanged<Object?> onChanged) =>
      const PendingEditor(label: 'edgeInsets');

  @override
  Object? get defaultJson => fallback;
}
