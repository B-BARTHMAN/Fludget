import 'package:fludget/catalog/properties/codecs/double_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:flutter/material.dart';

const Prop<double?> _width = Prop('width', DoubleCodec());
const Prop<double?> _height = Prop('height', DoubleCodec());

final sizedBoxDef = WidgetDef(
  type: 'SizedBox',
  props: [_width, _height],
  slots: const {'child': SlotArity.single},
  build: (node, children) => SizedBox(
    width: _width.read(node),
    height: _height.read(node),
    child: children.one('child'),
  ),
  toCode: (node, c) =>
      'SizedBox(width: ${_width.code(node)}, '
      'height: ${_height.code(node)}, child: ${c.one('child') ?? 'null'})',
);
