import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/model/widget_node.dart';

/// Returns a copy of [node] with any props or slots its definition doesn't
/// declare removed, recursively, resolving types through [source]. Keeps
/// stored data honest after a def changes — and tolerates unknown types rather
/// than failing on them.
WidgetNode normalizeNode(WidgetNode node, WidgetSource source) {
  final slots = {
    for (final entry in node.slots.entries)
      entry.key: [
        for (final child in entry.value) normalizeNode(child, source),
      ],
  };

  final def = source.defFor(node.type);
  if (def == null) {
    // Unknown type (e.g. a removed widget or deleted component): drop its
    // props but keep the normalized children, so data survives if it returns.
    return node.copyWith(props: const {}, slots: slots);
  }

  final allowedProps = {for (final p in def.props) p.name};
  final allowedSlots = {for (final s in def.slots) s.name};

  return node.copyWith(
    props: {
      for (final entry in node.props.entries)
        if (allowedProps.contains(entry.key)) entry.key: entry.value,
    },
    slots: {
      for (final entry in slots.entries)
        if (allowedSlots.contains(entry.key)) entry.key: entry.value,
    },
  );
}
