import 'package:fludget/core/domain/widget_registry.dart';
import 'package:fludget/core/models/child_rule.dart';
import 'package:fludget/core/models/widget_node.dart';
import 'package:fludget/features/document/cubit/document_cubit.dart';
import 'package:fludget/features/widget_tree/ui/widgets/add_child_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetTreeNode extends StatelessWidget {
  const WidgetTreeNode({
    required this.node,
    required this.selectedId,
    required this.depth,
    super.key,
  });

  final WidgetNode node;
  final String? selectedId;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final document = context.read<DocumentCubit>();
    final colors = Theme.of(context).colorScheme;
    final selected = node.id == selectedId;
    final isRoot = depth == 0;

    final rule = widgetRegistry[node.type]?.childRule ?? ChildRule.none;
    final canAddChild =
        rule == ChildRule.multiple ||
        (rule == ChildRule.single && node.children.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => document.select(node.id),
          child: Container(
            height: 36,
            padding: EdgeInsets.only(left: 12.0 + depth * 16.0, right: 4),
            color: selected ? colors.primaryContainer : null,
            child: Row(
              children: [
                Icon(
                  Icons.widgets_outlined,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(node.type, overflow: TextOverflow.ellipsis),
                ),
                if (canAddChild) AddChildButton(parentId: node.id),
                if (!isRoot)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Delete',
                    onPressed: () => document.delete(node.id),
                  ),
              ],
            ),
          ),
        ),
        for (final child in node.children)
          WidgetTreeNode(node: child, selectedId: selectedId, depth: depth + 1),
      ],
    );
  }
}
