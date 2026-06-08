import 'package:fludget/catalog/slots.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:flutter/material.dart';

final centerDef = WidgetDef(
  type: 'Center',
  slots: const {'child': SlotArity.single},
  build: (node, children) => Center(child: children.one('child')),
  toCode: (node, children) =>
      'Center(child: ${children.one('child') ?? 'null'})',
);
