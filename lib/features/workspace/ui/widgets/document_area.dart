import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/ui/widgets/canvas/canvas_view.dart';
import 'package:fludget/features/editor/ui/widgets/properties/properties_panel.dart';
import 'package:fludget/features/editor/ui/widgets/tree/widget_tree.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_state.dart';
import 'package:fludget/features/workspace/ui/widgets/workspace_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The active tab's region: provides that tab's editor, then lays out the tab
/// bar over a tree · canvas · properties row. Shows a placeholder when no tab
/// is open.
class DocumentArea extends StatelessWidget {
  const DocumentArea({required this.source, super.key});

  final WidgetSource source;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      buildWhen: (p, c) => p.active?.editor != c.active?.editor,
      builder: (context, state) {
        final tab = state.active;
        if (tab == null) return const _NoTabs();
        return BlocProvider<ComponentEditorCubit>.value(
          value: tab.editor,
          child: Column(
            children: [
              const WorkspaceTabBar(),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 260, child: WidgetTree()),
                    const VerticalDivider(width: 1),
                    const Expanded(flex: 2, child: CanvasView()),
                    const VerticalDivider(width: 1),
                    SizedBox(
                      width: 300,
                      child: PropertiesPanel(source: source),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NoTabs extends StatelessWidget {
  const _NoTabs();

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      'Open a component from the files panel to start editing.',
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
  );
}
