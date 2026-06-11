import 'package:fludget/core/ui/dialogs/confirm_dialog.dart';
import 'package:fludget/core/ui/dialogs/name_dialog.dart';
import 'package:fludget/core/ui/dialogs/option_picker_dialog.dart';
import 'package:fludget/core/ui/dialogs/save_changes_dialog.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Project-lifecycle glue: open / new / rename / delete. Switching away guards
/// unsaved work via [askSaveChanges] first.

Future<void> openProject(BuildContext context) async {
  final project = context.read<ProjectCubit>();
  final loaded = project.state.project;
  if (loaded == null) return;
  final names = await project.availableProjects();
  if (!context.mounted) return;
  final choice = await pickOption<String>(
    context,
    title: 'Open project',
    options: [
      for (final name in names..sort())
        PickerOption(
          name,
          name,
          icon: name == loaded.name ? Icons.folder_open : Icons.folder_outlined,
          current: name == loaded.name,
        ),
    ],
  );
  if (choice == null || choice == loaded.name || !context.mounted) return;
  if (await _ensureSaved(context)) await project.openProject(choice);
}

Future<void> newProject(BuildContext context) async {
  final project = context.read<ProjectCubit>();
  final name = await promptName(
    context,
    title: 'New project',
    initial: 'Untitled Project',
  );
  if (name == null || !context.mounted) return;
  if (await _ensureSaved(context)) {
    await project.createNewProject(name);
  }
}

Future<void> renameProject(BuildContext context) async {
  final loaded = context.read<ProjectCubit>().state.project;
  if (loaded == null) return;
  final name = await promptName(
    context,
    title: 'Rename project',
    initial: loaded.name,
  );
  if (name == null || !context.mounted) return;
  await context.read<ProjectCubit>().renameProject(name);
}

Future<void> deleteProject(BuildContext context) async {
  final loaded = context.read<ProjectCubit>().state.project;
  if (loaded == null) return;
  final ok = await confirm(
    context,
    title: 'Delete "${loaded.name}"?',
    message: 'Deletes the project and all its components.',
    confirmLabel: 'Delete',
    destructive: true,
  );
  if (ok && context.mounted) {
    await context.read<ProjectCubit>().deleteProject(loaded.name);
  }
}

/// True if it's safe to switch away — saving, discarding, or cancelling per the
/// user's choice when there's unsaved work.
Future<bool> _ensureSaved(BuildContext context) async {
  final workspace = context.read<WorkspaceCubit>();
  if (!workspace.state.anyDirty) return true;
  if (!context.mounted) return false; // guard before the dialog
  switch (await askSaveChanges(context, saveLabel: 'Save all')) {
    case SaveChoice.save:
      await workspace.saveAll();
      return true;
    case SaveChoice.discard:
      return true;
    case SaveChoice.cancel:
      return false;
  }
}
