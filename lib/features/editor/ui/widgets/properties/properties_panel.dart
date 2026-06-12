// features/editor/ui/widgets/properties/properties_panel.dart
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/model/tree_ops.dart' as tree;
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:fludget/features/editor/ui/widgets/properties/property_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The properties of the selected node: one [PropertyField] per prop the node's
/// def declares, each wired to the editor's `updateProps`.
class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final source = context.read<WidgetSource>();
    return BlocBuilder<ComponentEditorCubit, ComponentEditorState>(
      buildWhen: (p, c) => p.selectedId != c.selectedId || p.root != c.root,
      builder: (context, state) {
        final root = state.root;
        final id = state.selectedId;
        final node = (root == null || id == null)
            ? null
            : tree.findById(root, id);
        if (node == null) return const _Empty();
        final def = source.defFor(node.type);
        if (def == null || def.props.isEmpty) return const _Empty();

        final editor = context.read<ComponentEditorCubit>();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final prop in def.props)
              PropertyField(
                prop: prop,
                node: node,
                onChanged: (value) =>
                    editor.updateProps(node.id, {prop.name: value}),
              ),
          ],
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Select a widget to edit its properties.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ),
  );
}
