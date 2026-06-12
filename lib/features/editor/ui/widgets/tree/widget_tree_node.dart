import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/core/ui/tokens.dart';
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:fludget/features/editor/ui/widgets/tree/slot_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One node in the widget tree: its type, tap-to-select, delete, and a
/// [SlotGroup] for each slot its def declares. Recurses through the slots.
class WidgetTreeNode extends StatelessWidget {
  const WidgetTreeNode({required this.node, this.depth = 0, super.key});

  final WidgetNode node;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final source = context.read<WidgetSource>();
    final editor = context.read<ComponentEditorCubit>();
    final colors = Theme.of(context).colorScheme;
    final def = source.defFor(node.type);
    final slots = def?.slots ?? const [];
    final name = def?.label ?? node.type;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<ComponentEditorCubit, ComponentEditorState>(
          buildWhen: (p, c) =>
              (p.selectedId == node.id) != (c.selectedId == node.id),
          builder: (context, state) {
            final selected = state.selectedId == node.id;
            return InkWell(
              onTap: () => editor.select(selected ? null : node.id),
              child: Container(
                height: Sizes.treeRow,
                padding: EdgeInsets.only(
                  left: depth * Sizes.indentUnit + Insets.md,
                  right: Insets.sm,
                ),
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
                      child: Text(name, overflow: TextOverflow.ellipsis),
                    ),
                    if (selected)
                      InkWell(
                        onTap: () => editor.delete(node.id),
                        child: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: colors.error,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        for (final slot in slots)
          SlotGroup(parent: node, slot: slot, depth: depth + 1),
      ],
    );
  }
}
