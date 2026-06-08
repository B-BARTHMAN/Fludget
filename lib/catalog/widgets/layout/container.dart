import 'package:fludget/catalog/properties/codecs/alignment_codec.dart';
import 'package:fludget/catalog/properties/codecs/color_codec.dart';
import 'package:fludget/catalog/properties/codecs/double_codec.dart';
import 'package:fludget/catalog/properties/codecs/edge_insets_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:flutter/material.dart';

const Prop<double?> _width = Prop('width', DoubleCodec());
const Prop<double?> _height = Prop('height', DoubleCodec());
const Prop<Color?> _color = Prop('color', ColorCodec());
const Prop<EdgeInsets?> _padding = Prop('padding', EdgeInsetsCodec());
const Prop<Alignment?> _alignment = Prop('alignment', AlignmentCodec());

final containerDef = WidgetDef(
  type: 'Container',
  props: [_width, _height, _color, _padding, _alignment],
  slots: const {'child': SlotArity.single},
  build: (node, children) => Container(
    width: _width.read(node),
    height: _height.read(node),
    color: _color.read(node),
    padding: _padding.read(node),
    alignment: _alignment.read(node),
    child: children.one('child'),
  ),
  toCode: (node, children) =>
      '''
Container(
  width: ${_width.code(node)},
  height: ${_height.code(node)},
  color: ${_color.code(node)},
  padding: ${_padding.code(node)},
  alignment: ${_alignment.code(node)},
  child: ${children.one('child') ?? 'null'},
)''',
);
