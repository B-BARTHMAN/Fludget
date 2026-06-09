import 'package:fludget/editor/canvas/canvas_view.dart';
import 'package:fludget/editor/code_view/code_view_page.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/document/document_state.dart';
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

enum _CloseAction { save, discard, cancel }

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
    final workspace = context.read<WorkspaceCubit>();
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
                const SingleActivator(
                  LogicalKeyboardKey.keyS,
                  control: true,
                ): workspace.saveActive,
                const SingleActivator(
                  LogicalKeyboardKey.keyS,
                  meta: true,
                ): workspace.saveActive,
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

    // Provide the active document ONLY to the regions that read it. LeftPanel is
    // intentionally NOT wrapped: only its Outline needs the document, and it
    // provides that for itself, so the panel (and its animated SegmentedButton)
    // is not rebuilt every time the active component changes.
    Widget withDoc(Widget child) => active == null
        ? child
        : BlocProvider.value(value: active, child: child);

    final tabBar = WorkspaceTabBar(
      tabs: [
        for (final t in state.tabs)
          (
            componentId: t.componentId,
            name: _nameOf(t.componentId),
            cubit: t.cubit,
          ),
      ],
      activeIndex: state.activeIndex,
      onSelect: workspace.switchTo,
      onReorder: workspace.reorderTab,
      onClose: (index) => _confirmClose(
        context,
        workspace,
        name: _nameOf(state.tabs[index].componentId),
        index: index,
        isDirty: state.tabs[index].cubit.state.isDirty,
      ),
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
            withDoc(const UndoRedoButtons()),
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
            BlocBuilder<DocumentCubit, DocumentState>(
              bloc: active,
              buildWhen: (p, c) => p.isDirty != c.isDirty,
              builder: (context, docState) => IconButton(
                onPressed: docState.isDirty ? workspace.saveActive : null,
                icon: Icon(docState.isDirty ? Icons.save : Icons.save_outlined),
                tooltip: 'Save',
              ),
            ),
          ],
        ],
      ),
      drawer: wide ? null : const Drawer(child: LeftPanel()),
      endDrawer: active == null
          ? null
          : Drawer(
              child: withDoc(
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
      body: wide
          ? _ResizableLeft(
              panel: const LeftPanel(),
              body: withDoc(canvasColumn),
            )
          : withDoc(canvasColumn),
    );
  }
}

Future<void> _confirmClose(
  BuildContext context,
  WorkspaceCubit workspace, {
  required String name,
  required int index,
  required bool isDirty,
}) async {
  if (!isDirty) {
    await workspace.closeTab(index);
    return;
  }
  final action = await showDialog<_CloseAction>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Save changes to "$name"?'),
      content: const Text("Your changes will be lost if you don't save them."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _CloseAction.cancel),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _CloseAction.discard),
          child: const Text('Discard'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _CloseAction.save),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  switch (action) {
    case _CloseAction.save:
      await workspace.saveTabAt(index);
      await workspace.closeTab(index);
    case _CloseAction.discard:
      await workspace.closeTab(index);
    case _CloseAction.cancel:
    case null:
      break;
  }
}

class _ResizableLeft extends StatefulWidget {
  const _ResizableLeft({required this.panel, required this.body});

  final Widget panel;
  final Widget body;

  @override
  State<_ResizableLeft> createState() => _ResizableLeftState();
}

class _ResizableLeftState extends State<_ResizableLeft> {
  static const _min = 220.0;
  double _width = 300;
  double _max = 480;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _max = (constraints.maxWidth - 280).clamp(_min, 560).toDouble();
        final width = _width.clamp(_min, _max);
        return Row(
          children: [
            SizedBox(width: width, child: widget.panel),
            MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (d) => setState(
                  () => _width = (_width + d.delta.dx).clamp(_min, _max),
                ),
                child: const SizedBox(
                  width: 8,
                  child: Center(child: VerticalDivider(width: 1)),
                ),
              ),
            ),
            Expanded(child: widget.body),
          ],
        );
      },
    );
  }
}
