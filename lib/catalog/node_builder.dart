import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/registry.dart';
import 'package:flutter/material.dart';

/// Optionally wraps each built node. Injected by the editor (e.g. for
/// selection tagging); the catalog stays unaware of what the wrapping does.
typedef NodeDecorator = Widget Function(WidgetNode node, Widget built);

/// Recursively renders a WidgetNode tree into real Flutter widgets for the
/// canvas. Per-type rendering lives here; the registry stays pure schema.
Widget buildNode(WidgetNode node, {NodeDecorator? decorate}) {
  final def = widgetRegistry[node.type];
  if (def == null) return const SizedBox.shrink();
  final children = <String, List<Widget>>{
    for (final entry in node.slots.entries)
      entry.key: [
        for (final child in entry.value) buildNode(child, decorate: decorate),
      ],
  };
  final built = def.build(node, children);
  return decorate == null ? built : decorate(node, built);
}
