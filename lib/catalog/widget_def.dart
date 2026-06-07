import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots.dart';
import 'package:flutter/widgets.dart';

/// One supported widget type. Add a widget = add one of these in its own file.
class WidgetDef {
  WidgetDef({
    required this.type,
    required this.build,
    required this.toCode,
    this.props = const [],
    this.slots = const {},
  });

  final String type;
  final List<Prop<dynamic>> props;
  final Map<String, SlotArity> slots;
  final Widget Function(WidgetNode node, Map<String, List<Widget>> children)
  build;
  final String Function(WidgetNode node, Map<String, List<String>> children)
  toCode;
}
