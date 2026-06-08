import 'package:fludget/catalog/properties/codecs/color_codec.dart';
import 'package:fludget/catalog/properties/codecs/double_codec.dart';
import 'package:fludget/catalog/properties/codecs/icon_name_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:flutter/material.dart';

const Prop<IconData> _icon = Prop('icon', IconNameCodec());
const Prop<double?> _size = Prop('size', DoubleCodec(fallback: 24));
const Prop<Color?> _color = Prop('color', ColorCodec());

final iconDef = WidgetDef(
  type: 'Icon',
  props: [_icon, _size, _color],
  build: (node, children) =>
      Icon(_icon.read(node), size: _size.read(node), color: _color.read(node)),
  toCode: (node, children) =>
      'Icon(${_icon.code(node)}, size: ${_size.code(node)}, color: ${_color.code(node)})',
);
