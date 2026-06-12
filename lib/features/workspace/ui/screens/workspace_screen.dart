import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/features/composition/logic/component_codegen.dart';
import 'package:fludget/features/composition/logic/component_library.dart';
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/ui/screens/code_view_page.dart';
import 'package:fludget/features/editor/ui/widgets/properties/properties_panel.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/project/ui/files_panel.dart';
import 'package:fludget/features/settings/ui/settings_dialog.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_state.dart';
import 'package:fludget/features/workspace/ui/widgets/canvas_area.dart';
import 'package:fludget/features/workspace/ui/widgets/editor_shortcuts.dart';
import 'package:fludget/features/workspace/ui/widgets/explorer_panel.dart';
import 'package:fludget/features/workspace/ui/widgets/resizable_panel.dart';
import 'package:fludget/features/workspace/ui/widgets/workspace_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// At or above this width the explorer and properties sit inline beside the
/// canvas; below it they collapse into drawers and the canvas fills the screen.
const _wide = 800.0;

/// The editor's main screen. Provides the active tab's editor to the regions
/// that need it (tree, canvas, properties), then arranges those three regions
/// responsively — inline panels when wide, drawers when narrow.
class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final _scaffold = GlobalKey<ScaffoldState>();
  bool _showProperties = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      buildWhen: (p, c) => p.active?.editor != c.active?.editor,
      builder: (context, state) {
        final editor = state.active?.editor;
        final scaffold = LayoutBuilder(
          builder: (context, constraints) => _scaffoldFor(
            context,
            editor: editor,
            wide: constraints.maxWidth >= _wide,
          ),
        );
        return editor == null
            ? scaffold
            : BlocProvider<ComponentEditorCubit>.value(
                value: editor,
                child: scaffold,
              );
      },
    );
  }

  Widget _scaffoldFor(
    BuildContext context, {
    required ComponentEditorCubit? editor,
    required bool wide,
  }) {
    final workspace = context.read<WorkspaceCubit>();
    final hasTab = editor != null;
    return EditorShortcuts(
      onUndo: () => workspace.state.active?.editor.undo(),
      onRedo: () => workspace.state.active?.editor.redo(),
      onSave: workspace.saveActive,
      child: Scaffold(
        key: _scaffold,
        appBar: WorkspaceAppBar(
          onViewCode: () => _viewCode(context),
          onToggleProperties: () => _toggleProperties(wide),
          onOpenSettings: () => showSettingsDialog(context),
          showTitle: wide,
        ),
        drawer: wide
            ? null
            : Drawer(
                child: SafeArea(
                  child: hasTab ? const ExplorerPanel() : const FilesPanel(),
                ),
              ),
        endDrawer: (!wide && hasTab)
            ? const Drawer(child: SafeArea(child: PropertiesPanel()))
            : null,
        body: wide ? _wideBody(hasTab: hasTab) : _center(hasTab),
      ),
    );
  }

  Widget _wideBody({required bool hasTab}) => Row(
    children: [
      ResizablePanel(
        max: 360,
        initial: 280,
        child: hasTab ? const ExplorerPanel() : const FilesPanel(),
      ),
      const VerticalDivider(width: 1),
      Expanded(child: _center(hasTab)),
      if (hasTab && _showProperties) ...[
        const VerticalDivider(width: 1),
        const SizedBox(width: 300, child: PropertiesPanel()),
      ],
    ],
  );

  Widget _center(bool hasTab) => hasTab ? const CanvasArea() : const _NoTabs();

  void _toggleProperties(bool wide) {
    if (wide) {
      setState(() => _showProperties = !_showProperties);
    } else {
      _scaffold.currentState?.openEndDrawer();
    }
  }

  Future<void> _viewCode(BuildContext context) async {
    final tab = context.read<WorkspaceCubit>().state.active;
    final project = context.read<ProjectCubit>().state.project;
    final source = context.read<WidgetSource>();
    if (tab == null || project == null) return;
    final saved = project.components[tab.componentId];
    if (saved == null) return;
    final target = saved.copyWith(root: tab.editor.state.root);
    if (target.root == null) return;
    final code = generateProgram(target, source, ComponentLibrary(project));
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            CodeViewPage(code: code, title: pascalCase(target.name)),
      ),
    );
  }
}

/// `My button` -> `MyButton`, a valid class identifier.
String pascalCase(String name) {
  final words = name.split(RegExp('[^A-Za-z0-9]+')).where((w) => w.isNotEmpty);
  return words.map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join();
}

class _NoTabs extends StatelessWidget {
  const _NoTabs();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'Open a component from the files panel to start editing.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ),
  );
}
