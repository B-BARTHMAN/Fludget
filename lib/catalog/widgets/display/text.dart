import 'package:fludget/catalog/properties/codecs/string_codec.dart';
import 'package:fludget/catalog/properties/codecs/text_style_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:flutter/material.dart';

const Prop<String> _data = Prop('data', StringCodec(fallback: 'Text'));
const Prop<TextStyle?> _style = Prop('style', TextStyleCodec());

final textDef = WidgetDef(
  type: 'Text',
  props: [_data, _style],
  build: (node, children) => Text(_data.read(node), style: _style.read(node)),
  toCode: (node, c) => 'Text(${_data.code(node)}, style: ${_style.code(node)})',
);
