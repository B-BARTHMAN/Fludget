import 'package:fludget/editor/canvas/canvas_view.dart';
import 'package:fludget/editor/code_view/code_view_page.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/project/project_cubit.dart';
import 'package:fludget/editor/project/project_state.dart';
import 'package:fludget/editor/properties/properties_panel.dart';
import 'package:fludget/editor/workspace/empty_workspace.dart';
import 'package:fludget/editor/workspace/left_panel.dart';
import 'package:fludget/editor/workspace/undo_redo_buttons.dart';
import 'package:fludget/editor/workspace/workspace_cubit.dart';
import 'package:fludget/editor/workspace/workspace_state.dart';
import 'package:fludget/editor/workspace/workspace_tab_bar.dart';
import 'package:fludget/project/loaded_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _wideBreakpoint = 720.0;

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, projectState) {
        final project = projectState.project;
        if (project == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _Workspace(project: project);
      },
    );
  }
}

class _Workspace extends StatelessWidget {
  const _Workspace({required this.project});

  final LoadedProject project;

  String _nameOf(String componentId) =>
      project.component(componentId)?.name ?? 'Untitled';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        final active = state.activeDocument;
        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= _wideBreakpoint;
            // Always the same shape -> the Scaffold/drawer survive active changes.
            return CallbackShortcuts(
              bindings: <ShortcutActivator, VoidCallback>{
                const SingleActivator(
                  LogicalKeyboardKey.keyZ,
                  control: true,
                ): () =>
                    active?.undo(),
                const SingleActivator(
                  LogicalKeyboardKey.keyZ,
                  meta: true,
                ): () =>
                    active?.undo(),
                const SingleActivator(
                  LogicalKeyboardKey.keyZ,
                  control: true,
                  shift: true,
                ): () =>
                    active?.redo(),
                const SingleActivator(
                  LogicalKeyboardKey.keyZ,
                  meta: true,
                  shift: true,
                ): () =>
                    active?.redo(),
                const SingleActivator(
                  LogicalKeyboardKey.keyY,
                  control: true,
                ): () =>
                    active?.redo(),
              },
              child: Focus(
                autofocus: true,
                child: _scaffold(context, state, active, wide: wide),
              ),
            );
          },
        );
      },
    );
  }

  Widget _scaffold(
    BuildContext context,
    WorkspaceState state,
    DocumentCubit? active, {
    required bool wide,
  }) {
    final workspace = context.read<WorkspaceCubit>();

    // Provide the active document ONLY to the regions that read it, instead of
    // wrapping the whole Scaffold. The Scaffold and its drawers keep their place
    // in the tree when `active` appears/disappears, so the open drawer's
    // animation is never disposed mid-flight — that was the crash.
    Widget withDoc(Widget child) => active == null
        ? child
        : BlocProvider.value(value: active, child: child);

    final tabBar = WorkspaceTabBar(
      tabs: [for (final t in state.tabs) _nameOf(t.componentId)],
      activeIndex: state.activeIndex,
      onSelect: workspace.switchTo,
      onClose: workspace.closeTab,
    );

    final canvasColumn = Column(
      children: [
        tabBar,
        const Divider(height: 16),
        Expanded(
          child: active == null ? const EmptyWorkspace() : const CanvasView(),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          active == null ? 'Fludget' : _nameOf(state.activeTab!.componentId),
        ),
        actions: [
          if (active != null) ...[
            withDoc(const UndoRedoButtons()), // ← 1. reads the document
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CodeViewPage(root: active.state.root),
                ),
              ),
              icon: const Icon(Icons.code),
              tooltip: 'View Code',
            ),
            Builder(
              builder: (context) => IconButton(
                onPressed: Scaffold.of(context).openEndDrawer,
                icon: const Icon(Icons.tune),
                tooltip: 'Properties',
              ),
            ),
            IconButton(
              onPressed: workspace.saveActive,
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save',
            ),
          ],
        ],
      ),
      // 2. The Drawer widget itself is unchanged (so its controller survives);
      //    only its child — the Outline, which reads the document — is wrapped.
      drawer: wide ? null : Drawer(child: withDoc(const LeftPanel())),
      endDrawer: active == null
          ? null
          : Drawer(
              child: withDoc(
                // ← 3. Properties panel
                const SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Properties',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Divider(height: 1),
                      Expanded(child: PropertiesPanel()),
                    ],
                  ),
                ),
              ),
            ),
      // 4. Canvas (and, when wide, the left Outline column) reads the document.
      body: withDoc(
        wide
            ? Row(
                children: [
                  const SizedBox(width: 300, child: LeftPanel()),
                  const VerticalDivider(width: 1),
                  Expanded(child: canvasColumn),
                ],
              )
            : canvasColumn,
      ),
    );
  }
}
