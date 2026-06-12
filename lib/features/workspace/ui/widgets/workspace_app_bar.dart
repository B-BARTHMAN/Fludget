// features/workspace/ui/widgets/workspace_app_bar.dart
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The top bar: undo / redo / save / properties / view-code for the active
/// document. The properties button toggles the inline panel when wide and opens
/// the properties drawer when narrow — the parent supplies the behaviour.
class WorkspaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WorkspaceAppBar({
    required this.onViewCode,
    required this.onToggleProperties,
    required this.onOpenSettings,
    required this.showTitle,
    super.key,
  });

  final VoidCallback onViewCode;
  final VoidCallback onToggleProperties;
  final VoidCallback onOpenSettings;
  final bool showTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      buildWhen: (p, c) => p.active?.editor != c.active?.editor,
      builder: (context, state) {
        final editor = state.active?.editor;
        return AppBar(
          title: showTitle ? const Text('Fludget') : null,
          actions: [
            if (editor != null) ...[
              BlocBuilder<ComponentEditorCubit, ComponentEditorState>(
                bloc: editor,
                buildWhen: (p, c) =>
                    p.canUndo != c.canUndo || p.canRedo != c.canRedo,
                builder: (context, s) => Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo),
                      tooltip: 'Undo',
                      onPressed: s.canUndo ? editor.undo : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      tooltip: 'Redo',
                      onPressed: s.canRedo ? editor.redo : null,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () => context.read<WorkspaceCubit>().saveActive(),
              ),
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Properties',
                onPressed: onToggleProperties,
              ),
              IconButton(
                icon: const Icon(Icons.code),
                tooltip: 'View code',
                onPressed: onViewCode,
              ),
            ],
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: onOpenSettings,
            ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }
}
