import 'package:fludget/core/domain/codecs/edge_insets_codec.dart';
import 'package:fludget/core/domain/prop.dart';
import 'package:fludget/core/domain/slots.dart';
import 'package:fludget/core/domain/widget_def.dart';
import 'package:flutter/material.dart';

const Prop<EdgeInsets?> _padding = Prop(
  'padding',
  EdgeInsetsCodec(fallback: 8),
);

final paddingDef = WidgetDef(
  type: 'Padding',
  props: [_padding],
  slots: const {'child': SlotArity.single},
  build: (node, children) => Padding(
    padding: _padding.read(node) ?? EdgeInsets.zero,
    child: children.one('child'),
  ),
  toCode: (node, c) =>
      'Padding(padding: ${_padding.code(node)}, child: ${c.one('child') ?? 'null'})',
);
