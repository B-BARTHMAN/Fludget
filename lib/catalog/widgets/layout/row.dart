import 'package:fludget/catalog/properties/codecs/enum_codec.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:flutter/material.dart';

const Prop<MainAxisAlignment> _main = Prop(
  'mainAxisAlignment',
  EnumCodec(
    MainAxisAlignment.values,
    MainAxisAlignment.start,
    typeName: 'MainAxisAlignment',
  ),
);
const Prop<CrossAxisAlignment> _cross = Prop(
  'crossAxisAlignment',
  EnumCodec(
    CrossAxisAlignment.values,
    CrossAxisAlignment.center,
    typeName: 'CrossAxisAlignment',
  ),
);

final rowDef = WidgetDef(
  type: 'Row',
  props: [_main, _cross],
  slots: const {'children': SlotArity.many},
  build: (node, children) => Row(
    mainAxisAlignment: _main.read(node),
    crossAxisAlignment: _cross.read(node),
    children: children.many('children'),
  ),
  toCode: (node, children) =>
      '''
Row(
  mainAxisAlignment: ${_main.code(node)},
  crossAxisAlignment: ${_cross.code(node)},
  children: [${children.many('children').join(', ')}],
)''',
);
