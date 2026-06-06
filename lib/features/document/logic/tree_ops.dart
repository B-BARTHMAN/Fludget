import 'package:fludget/core/models/widget_node.dart';

WidgetNode? findById(WidgetNode node, String id) {
  if (node.id == id) return node;
  for (final child in node.children) {
    final found = findById(child, id);
    if (found != null) return found;
  }
  return null;
}

WidgetNode updateById(
  WidgetNode node,
  String id,
  WidgetNode Function(WidgetNode node) transform,
) {
  if (node.id == id) return transform(node);
  if (node.children.isEmpty) return node;
  return node.copyWith(
    children: [for (final c in node.children) updateById(c, id, transform)],
  );
}

WidgetNode addChild(WidgetNode tree, String parentId, WidgetNode child) =>
    updateById(
      tree,
      parentId,
      (p) => p.copyWith(children: [...p.children, child]),
    );

WidgetNode updateProps(
  WidgetNode tree,
  String id,
  Map<String, dynamic> changes,
) => updateById(tree, id, (n) => n.copyWith(props: {...n.props, ...changes}));

WidgetNode removeById(WidgetNode tree, String id) => tree.copyWith(
  children: [
    for (final c in tree.children)
      if (c.id != id) removeById(c, id),
  ],
);
