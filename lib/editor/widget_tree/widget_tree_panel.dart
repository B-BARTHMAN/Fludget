import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
import 'package:fludget/editor/widget_tree/widget_tree_node.dart';
import 'package:fludget/editor/widget_tree/widget_type_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetTreePanel extends StatelessWidget {
  const WidgetTreePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      buildWhen: (previous, current) =>
          previous.root != current.root ||
          previous.selectedId != current.selectedId,
      builder: (context, state) {
        final root = state.root;
        if (root == null) return const _EmptyOutline();
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: WidgetTreeNode(
            node: root,
            selectedId: state.selectedId,
            depth: 0,
          ),
        );
      },
    );
  }
}

class _EmptyOutline extends StatelessWidget {
  const _EmptyOutline();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No widgets yet.',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          WidgetTypeMenu(
            onSelected: (type) => context.read<DocumentCubit>().setRoot(type),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16, color: colors.primary),
                const SizedBox(width: 6),
                Text('Add a widget', style: TextStyle(color: colors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
