import 'package:fludget/catalog/model/widget_node.dart';

WidgetNode? findById(WidgetNode node, String id) {
  if (node.id == id) return node;
  for (final list in node.slots.values) {
    for (final child in list) {
      final found = findById(child, id);
      if (found != null) return found;
    }
  }
  return null;
}

WidgetNode updateById(
  WidgetNode node,
  String id,
  WidgetNode Function(WidgetNode node) transform,
) {
  if (node.id == id) return transform(node);
  if (node.slots.isEmpty) return node;
  return node.copyWith(
    slots: {
      for (final entry in node.slots.entries)
        entry.key: [for (final c in entry.value) updateById(c, id, transform)],
    },
  );
}

WidgetNode addChild(
  WidgetNode tree,
  String parentId,
  String slot,
  WidgetNode child,
) => updateById(
  tree,
  parentId,
  (p) => p.copyWith(
    slots: {
      ...p.slots,
      slot: [...(p.slots[slot] ?? const []), child],
    },
  ),
);

WidgetNode updateProps(
  WidgetNode tree,
  String id,
  Map<String, dynamic> changes,
) => updateById(tree, id, (n) => n.copyWith(props: {...n.props, ...changes}));

WidgetNode removeById(WidgetNode tree, String id) => tree.copyWith(
  slots: {
    for (final entry in tree.slots.entries)
      entry.key: [
        for (final c in entry.value)
          if (c.id != id) removeById(c, id),
      ],
  },
);
