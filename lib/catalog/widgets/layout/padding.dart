import 'package:fludget/catalog/properties/codecs/edge_insets_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots.dart';
import 'package:fludget/catalog/widget_def.dart';
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
  toCode: (node, children) =>
      'Padding(padding: ${_padding.code(node)}, child: ${children.one('child') ?? 'null'})',
);
