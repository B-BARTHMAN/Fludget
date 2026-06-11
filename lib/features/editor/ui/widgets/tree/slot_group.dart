import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/slots/slot.dart';
import 'package:fludget/core/ui/tokens.dart';
import 'package:fludget/features/editor/ui/widgets/tree/add_child_button.dart';
import 'package:fludget/features/editor/ui/widgets/tree/widget_tree_node.dart';
import 'package:flutter/material.dart';

/// One slot of a node in the tree: its label, its child nodes (one level
/// deeper), and an add button when the slot has room.
class SlotGroup extends StatelessWidget {
  const SlotGroup({
    required this.parent,
    required this.slot,
    required this.depth,
    super.key,
  });

  final WidgetNode parent;
  final Slot slot;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: depth * Sizes.indentUnit,
            top: 4,
            bottom: 2,
          ),
          child: Text(
            slot.label ?? slot.name,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        for (final child in slot.children(parent))
          WidgetTreeNode(node: child, depth: depth + 1),
        if (slot.hasRoom(parent))
          Padding(
            padding: EdgeInsets.only(left: (depth + 1) * Sizes.indentUnit),
            child: AddChildButton(parentId: parent.id, slotName: slot.name),
          ),
      ],
    );
  }
}
