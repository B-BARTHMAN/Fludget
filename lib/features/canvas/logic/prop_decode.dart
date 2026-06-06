import 'package:flutter/material.dart';

Color? decodeColor(Object? v) => v is int ? Color(v) : null;

EdgeInsets decodeEdgeInsets(Object? v) {
  if (v is num) return EdgeInsets.all(v.toDouble());
  if (v is Map) {
    double n(String k) => (v[k] as num?)?.toDouble() ?? 0;
    return EdgeInsets.fromLTRB(n('left'), n('top'), n('right'), n('bottom'));
  }
  return EdgeInsets.zero;
}

Alignment? decodeAlignment(Object? v) {
  if (v is! Map) return null;
  return Alignment(
    (v['x'] as num?)?.toDouble() ?? 0,
    (v['y'] as num?)?.toDouble() ?? 0,
  );
}

TextStyle? decodeTextStyle(Object? v) {
  if (v is! Map) return null;
  return TextStyle(
    fontSize: (v['fontSize'] as num?)?.toDouble(),
    color: decodeColor(v['color']),
    fontWeight: _fontWeights[v['fontWeight']],
  );
}

const Map<Object?, FontWeight> _fontWeights = {
  'normal': FontWeight.normal,
  'bold': FontWeight.bold,
};

const Map<Object?, IconData> iconCatalog = {
  'star': Icons.star,
  'favorite': Icons.favorite,
  'home': Icons.home,
  'settings': Icons.settings,
  'add': Icons.add,
};

T enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}
