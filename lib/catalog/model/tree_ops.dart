import 'package:fludget/catalog/model/widget_node.dart';

/// Pure, structural operations over a [WidgetNode] tree. Each returns a new
/// tree and never mutates in place.
///
/// No *editing policy* lives here — e.g. whether a single-child slot may
/// accept another child is decided by the editor against the slot definition,
/// not by these functions. These are just the tree algebra.

/// The node with [id] in [root]'s subtree, or null if absent.
WidgetNode? findById(WidgetNode root, String id) {
  if (root.id == id) return root;
  for (final children in root.slots.values) {
    for (final child in children) {
      final found = findById(child, id);
      if (found != null) return found;
    }
  }
  return null;
}

/// A copy of [root] with the node matching [id] replaced by `transform(node)`.
/// Returns an equivalent tree if no node matches.
WidgetNode mapById(
  WidgetNode root,
  String id,
  WidgetNode Function(WidgetNode node) transform,
) {
  if (root.id == id) return transform(root);
  return root.copyWith(
    slots: {
      for (final entry in root.slots.entries)
        entry.key: [
          for (final child in entry.value) mapById(child, id, transform),
        ],
    },
  );
}

/// Merges [changes] into the props of the node with [id].
WidgetNode updateProps(
  WidgetNode root,
  String id,
  Map<String, Object?> changes,
) {
  return mapById(
    root,
    id,
    (node) => node.copyWith(props: {...node.props, ...changes}),
  );
}

/// Appends [child] to the [slot] of the node with [parentId].
WidgetNode addChild(
  WidgetNode root,
  String parentId,
  String slot,
  WidgetNode child,
) {
  return mapById(root, parentId, (parent) {
    final existing = parent.slots[slot] ?? const <WidgetNode>[];
    return parent.copyWith(
      slots: {
        ...parent.slots,
        slot: [...existing, child],
      },
    );
  });
}

/// Removes the node with [id] from [root]'s subtree. The root itself is never
/// removed — guard that at the call site.
WidgetNode removeById(WidgetNode root, String id) {
  return root.copyWith(
    slots: {
      for (final entry in root.slots.entries)
        entry.key: [
          for (final child in entry.value)
            if (child.id != id) removeById(child, id),
        ],
    },
  );
}
