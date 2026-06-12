// features/workspace/ui/tab_actions.dart
import 'package:fludget/core/ui/dialogs/save_changes_dialog.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Closes the tab at [index] with the same unsaved-changes guard the app-exit
/// and project-switch paths use: a clean tab closes immediately; a dirty one
/// asks to save (persist then close), discard (close), or cancel (keep open).
Future<void> closeTab(BuildContext context, int index) async {
  final workspace = context.read<WorkspaceCubit>();
  final tab = workspace.state.tabs[index];
  if (tab.editor.state.isDirty) {
    switch (await askSaveChanges(context)) {
      case SaveChoice.save:
        await workspace.saveTab(index);
      case SaveChoice.discard:
        break;
      case SaveChoice.cancel:
        return;
    }
  }
  await workspace.closeTab(index);
}
