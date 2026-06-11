import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/features/editor/ui/screens/code_view_page.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/project/ui/files_panel.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:fludget/features/workspace/ui/widgets/document_area.dart';
import 'package:fludget/features/workspace/ui/widgets/editor_shortcuts.dart';
import 'package:fludget/features/workspace/ui/widgets/resizable_panel.dart';
import 'package:fludget/features/workspace/ui/widgets/workspace_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The editor's main screen — pure composition: the app bar, keyboard
/// shortcuts, the files panel, and the active document's area.
class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({required this.source, super.key});

  final WidgetSource source;

  @override
  Widget build(BuildContext context) {
    final workspace = context.read<WorkspaceCubit>();
    return Scaffold(
      appBar: WorkspaceAppBar(onViewCode: () => _viewCode(context)),
      body: EditorShortcuts(
        onUndo: () => workspace.state.active?.editor.undo(),
        onRedo: () => workspace.state.active?.editor.redo(),
        onSave: workspace.saveActive,
        child: Row(
          children: [
            const ResizablePanel(child: FilesPanel()),
            const VerticalDivider(width: 1),
            Expanded(child: DocumentArea(source: source)),
          ],
        ),
      ),
    );
  }

  Future<void> _viewCode(BuildContext context) async {
    final tab = context.read<WorkspaceCubit>().state.active;
    final project = context.read<ProjectCubit>().state.project;
    final root = tab?.editor.state.root;
    if (tab == null || project == null || root == null) return;
    final name = project.components[tab.componentId]?.name ?? 'Component';
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CodeViewPage(
          root: root,
          className: _pascalCase(name),
          source: source,
        ),
      ),
    );
  }
}

/// `My button` -> `MyButton`, a valid class identifier.
String _pascalCase(String name) {
  final words = name.split(RegExp('[^A-Za-z0-9]+')).where((w) => w.isNotEmpty);
  return words.map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join();
}
