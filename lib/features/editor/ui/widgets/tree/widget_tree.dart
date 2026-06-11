import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:fludget/features/editor/ui/widgets/tree/widget_tree_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The outline of the current component: the recursive node tree, or a hint
/// when the component has no root yet.
class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComponentEditorCubit, ComponentEditorState>(
      buildWhen: (p, c) => p.root != c.root,
      builder: (context, state) {
        final root = state.root;
        if (root == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No widgets yet.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.topLeft,
            child: WidgetTreeNode(node: root),
          ),
        );
      },
    );
  }
}
