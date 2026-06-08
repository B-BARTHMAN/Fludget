import 'package:fludget/catalog/properties/codecs/color_codec.dart';
import 'package:fludget/catalog/properties/codecs/double_codec.dart';
import 'package:fludget/catalog/properties/codecs/edge_insets_codec.dart';
import 'package:fludget/catalog/properties/codecs/visual_density_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:flutter/material.dart';

const Prop<double?> _iconSize = Prop('iconSize', DoubleCodec(fallback: 24));
const Prop<VisualDensity> _density = Prop(
  'visualDensity',
  VisualDensityCodec(),
);
const Prop<EdgeInsets?> _padding = Prop('padding', EdgeInsetsCodec());
const Prop<Color?> _color = Prop('color', ColorCodec());

final iconButtonDef = WidgetDef(
  type: 'IconButton',
  props: [_iconSize, _density, _padding, _color],
  slots: const {'icon': SlotArity.single},
  build: (node, children) => IconButton(
    iconSize: _iconSize.read(node),
    visualDensity: _density.read(node),
    padding: _padding.read(node),
    color: _color.read(node),
    onPressed: () {},
    icon: children.one('icon') ?? const Icon(Icons.star),
  ),
  toCode: (node, children) =>
      '''
IconButton(
  iconSize: ${_iconSize.code(node)},
  visualDensity: ${_density.code(node)},
  padding: ${_padding.code(node)},
  color: ${_color.code(node)},
  onPressed: () {},
  icon: ${children.one('icon') ?? 'const Icon(Icons.star)'},
)''',
);
