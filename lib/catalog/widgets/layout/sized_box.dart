import 'package:fludget/catalog/properties/props.dart';
import 'package:fludget/catalog/slots/slot_children.dart';
import 'package:fludget/catalog/slots/slots.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:fludget/catalog/widgets/categories.dart';
import 'package:flutter/widgets.dart';

/// The template for every widget you add: compose shared `Props` and `Slots`,
/// name a category, and write only `build`. Code generation is produced
/// automatically from the props and slots below.
final sizedBoxDef = WidgetDef(
  type: 'SizedBox',
  category: Categories.layout,
  props: [Props.width, Props.height],
  slots: [Slots.child],
  build: (node, children) => SizedBox(
    width: Props.width.read(node),
    height: Props.height.read(node),
    child: children.one(Slots.child),
  ),
);
