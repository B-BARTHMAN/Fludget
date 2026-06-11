import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The top bar: undo / redo / save / view-code for the active document.
class WorkspaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WorkspaceAppBar({required this.onViewCode, super.key});

  final VoidCallback onViewCode;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      buildWhen: (p, c) => p.active?.editor != c.active?.editor,
      builder: (context, state) {
        final editor = state.active?.editor;
        return AppBar(
          title: const Text('Fludget'),
          actions: editor == null
              ? const []
              : [
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
                    onPressed: () =>
                        context.read<WorkspaceCubit>().saveActive(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.code),
                    tooltip: 'View code',
                    onPressed: onViewCode,
                  ),
                  const SizedBox(width: 8),
                ],
        );
      },
    );
  }
}
