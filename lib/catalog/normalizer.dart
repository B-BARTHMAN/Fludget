import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/registry.dart';

WidgetNode normalizeNode(WidgetNode node) {
  final def = widgetRegistry[node.type];
  final slots = {
    for (final entry in node.slots.entries)
      entry.key: [for (final c in entry.value) normalizeNode(c)],
  };

  if (def == null) {
    return node.copyWith(props: const {}, slots: slots);
  }

  final allowedProps = {for (final p in def.props) p.name};
  final allowedSlots = def.slots.keys.toSet();

  return node.copyWith(
    props: {
      for (final e in node.props.entries)
        if (allowedProps.contains(e.key)) e.key: e.value,
    },
    slots: {
      for (final e in slots.entries)
        if (allowedSlots.contains(e.key)) e.key: e.value,
    },
  );
}
