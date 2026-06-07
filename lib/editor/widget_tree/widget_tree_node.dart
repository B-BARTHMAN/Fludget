import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/registry.dart';
import 'package:fludget/catalog/slots.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/widget_tree/add_child_button.dart';
import 'package:flutter/material.dart';
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
    final slots =
        widgetRegistry[node.type]?.slots ?? const <String, SlotArity>{};

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
        for (final entry in slots.entries)
          _SlotGroup(
            node: node,
            slot: entry.key,
            arity: entry.value,
            selectedId: selectedId,
            depth: depth,
          ),
      ],
    );
  }
}

class _SlotGroup extends StatelessWidget {
  const _SlotGroup({
    required this.node,
    required this.slot,
    required this.arity,
    required this.selectedId,
    required this.depth,
  });

  final WidgetNode node;
  final String slot;
  final SlotArity arity;
  final String? selectedId;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final children = node.slots[slot] ?? const [];
    final canAdd = arity == SlotArity.many || children.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.0 + (depth + 1) * 16.0, right: 4),
          child: Row(
            children: [
              Text(
                slot,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (canAdd) AddChildButton(parentId: node.id, slot: slot),
            ],
          ),
        ),
        for (final child in children)
          WidgetTreeNode(node: child, selectedId: selectedId, depth: depth + 2),
      ],
    );
  }
}
