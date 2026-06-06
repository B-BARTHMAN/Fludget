import 'package:fludget/core/domain/widget_registry.dart';
import 'package:fludget/core/models/widget_node.dart';

WidgetNode normalizeNode(WidgetNode node) {
  final def = widgetRegistry[node.type];
  final children = [for (final c in node.children) normalizeNode(c)];

  if (def == null) {
    return node.copyWith(props: const {}, children: children);
  }

  final allowed = {for (final spec in def.properties) spec.name};
  final cleaned = {
    for (final entry in node.props.entries)
      if (allowed.contains(entry.key)) entry.key: entry.value,
  };

  return node.copyWith(props: cleaned, children: children);
}
