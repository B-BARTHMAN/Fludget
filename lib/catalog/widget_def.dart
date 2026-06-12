import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots/slot.dart';
import 'package:fludget/catalog/widgets/category.dart';
import 'package:flutter/material.dart';

/// Everything the catalog knows about one widget type: its editable [props],
/// its named child [slots], where it sits in the picker ([category]), the
/// [icon]/[label] it shows there, and how to turn a node into a live widget
/// ([build]) and into Dart source ([toCode]).
class WidgetDef {
  WidgetDef({
    required this.type,
    required this.category,
    required this.build,
    this.icon = Icons.widgets_outlined,
    this.label,
    this.toCode,
    this.props = const [],
    this.slots = const [],
  });

  /// The widget kind, e.g. `'Container'`. Unique across the registry. For a
  /// composed component this is its id, so [label] supplies a readable name.
  final String type;

  final Category category;

  /// Shown on the picker square for this widget.
  final IconData icon;

  /// The name shown in the tree and picker; falls back to [type].
  final String? label;

  final List<Prop<dynamic>> props;
  final List<Slot> slots;

  final Widget Function(WidgetNode node, Map<String, List<Widget>> children)
  build;

  final String Function(WidgetNode node, Map<String, List<String>> code)?
  toCode;
}
