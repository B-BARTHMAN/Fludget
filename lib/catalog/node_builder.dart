import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/registry.dart';
import 'package:flutter/material.dart';

/// Recursively renders a WidgetNode tree into real Flutter widgets for the
/// canvas. Per-type rendering lives here; the registry stays pure schema.
Widget buildNode(WidgetNode node) {
  final def = widgetRegistry[node.type];
  if (def == null) return const SizedBox.shrink();
  final children = <String, List<Widget>>{
    for (final entry in node.slots.entries)
      entry.key: [for (final child in entry.value) buildNode(child)],
  };
  return def.build(node, children);
}
