import 'package:fludget/features/canvas/ui/widgets/canvas_view.dart';
import 'package:fludget/features/widget_tree/ui/widgets/widget_tree_panel.dart';
import 'package:fludget/features/workspace/cubit/workspace_cubit.dart';
import 'package:fludget/features/workspace/cubit/workspace_state.dart';
import 'package:fludget/features/workspace/ui/widgets/document_area.dart';
import 'package:fludget/features/workspace/ui/widgets/empty_workspace.dart';
import 'package:fludget/features/workspace/ui/widgets/workspace_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        final workspace = context.read<WorkspaceCubit>();

        final tabBar = WorkspaceTabBar(
          tabs: [for (final t in state.tabs) t.name],
          activeIndex: state.activeIndex,
          onSelect: workspace.switchTo,
          onClose: workspace.closeTab,
          onNew: workspace.newDocument,
        );

        final active = state.activeDocument;
        if (active == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Fludget')),
            body: Column(
              children: [
                tabBar,
                const Divider(height: 1),
                const Expanded(child: EmptyWorkspace()),
              ],
            ),
          );
        }

        return BlocProvider.value(
          value: active,
          child: Scaffold(
            appBar: AppBar(
              title: Text(state.activeTab!.name),
              actions: [
                IconButton(
                  onPressed: workspace.saveActive,
                  icon: const Icon(Icons.save_outlined),
                  tooltip: 'Save',
                ),
              ],
            ),
            drawer: const Drawer(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Widget Tree',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Divider(height: 1),
                    Expanded(child: WidgetTreePanel()),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                tabBar,
                const Divider(height: 16),
                const Expanded(child: CanvasView()),
              ],
            ),
          ),
        );
      },
    );
  }
}
