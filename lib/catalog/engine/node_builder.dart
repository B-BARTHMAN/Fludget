import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/model/widget_node.dart';
import 'package:flutter/material.dart';

/// Optional hook to wrap each built widget. The canvas uses it to tag nodes
/// for hit-testing and to draw the selection outline — keeping that concern
/// out of the engine.
typedef NodeDecorator = Widget Function(WidgetNode node, Widget built);

/// Builds the live preview for [node], resolving its type and children through
/// [source]. Children are built depth-first and handed to the def's `build`,
/// keyed by slot name. [decorate], if given, wraps every node's widget.
Widget buildNode(
  WidgetNode node,
  WidgetSource source, {
  NodeDecorator? decorate,
}) {
  final def = source.defFor(node.type);
  final Widget built;
  if (def == null) {
    built = _missing(node.type);
  } else {
    final children = {
      for (final entry in node.slots.entries)
        entry.key: [
          for (final child in entry.value)
            buildNode(child, source, decorate: decorate),
        ],
    };
    built = def.build(node, children);
  }
  return decorate == null ? built : decorate(node, built);
}

/// Shown for a type no source can resolve — an unknown widget, or a deleted
/// component once composition exists. Visible and selectable, never a crash.
Widget _missing(String type) => DecoratedBox(
  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFB00020))),
  child: Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      'Unknown widget: $type',
      style: const TextStyle(color: Color(0xFFB00020), fontSize: 12),
    ),
  ),
);
