import 'package:fludget/core/ui/dialogs/confirm_dialog.dart';
import 'package:fludget/core/ui/dialogs/name_dialog.dart';
import 'package:fludget/core/ui/dialogs/option_picker_dialog.dart';
import 'package:fludget/core/util/path.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:fludget/features/project/logic/explorer_tree.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The async glue the explorer menus call: prompt with a dialog, then hand off
/// to the cubit. Each is the same short shape.

Future<void> createComponentIn(BuildContext context, String folder) async {
  final name = await promptName(
    context,
    title: 'New component',
    initial: 'Untitled',
  );
  if (name == null || !context.mounted) return;
  final id = await context.read<ProjectCubit>().createComponent(
    folder: folder,
    name: name,
  );
  if (context.mounted) context.read<WorkspaceCubit>().openComponent(id);
}

Future<void> renameComponent(BuildContext context, Component component) async {
  final name = await promptName(
    context,
    title: 'Rename component',
    initial: component.name,
  );
  if (name == null || !context.mounted) return;
  await context.read<ProjectCubit>().renameComponent(component.id, name);
}

Future<void> deleteComponent(BuildContext context, Component component) async {
  final ok = await confirm(
    context,
    title: 'Delete "${component.name}"?',
    message: 'This cannot be undone.',
    confirmLabel: 'Delete',
    destructive: true,
  );
  if (ok && context.mounted) {
    await context.read<ProjectCubit>().deleteComponent(component.id);
  }
}

Future<void> moveComponent(
  BuildContext context,
  Component component,
  String currentFolder,
) async {
  final dest = await _pickFolder(context, exclude: currentFolder);
  if (dest == null || !context.mounted) return;
  await context.read<ProjectCubit>().moveComponent(component.id, dest);
}

Future<void> createFolderIn(BuildContext context, String parent) async {
  final name = await promptName(
    context,
    title: 'New folder',
    initial: 'New Folder',
  );
  if (name == null || !context.mounted) return;
  await context.read<ProjectCubit>().createFolder(parent: parent, name: name);
}

Future<void> renameFolder(BuildContext context, ExplorerFolder folder) async {
  final name = await promptName(
    context,
    title: 'Rename folder',
    initial: folder.name,
  );
  if (name == null || !context.mounted) return;
  await context.read<ProjectCubit>().renameFolder(folder.path, name);
}

Future<void> deleteFolder(BuildContext context, ExplorerFolder folder) async {
  final ok = await confirm(
    context,
    title: 'Delete "${folder.name}"?',
    message: 'Deletes the folder and everything in it.',
    confirmLabel: 'Delete',
    destructive: true,
  );
  if (ok && context.mounted) {
    await context.read<ProjectCubit>().deleteFolder(folder.path);
  }
}

Future<void> moveFolder(BuildContext context, ExplorerFolder folder) async {
  final dest = await _pickFolder(context, exclude: folder.path);
  if (dest == null || !context.mounted) return;
  await context.read<ProjectCubit>().moveFolder(folder.path, dest);
}

Future<String?> _pickFolder(BuildContext context, {required String exclude}) {
  final project = context.read<ProjectCubit>().state.project!;
  final destinations = <String>{'', ...project.folders}
    ..removeWhere(
      (f) =>
          f == exclude || f.startsWith('$exclude/') || f == parentOf(exclude),
    );
  return pickOption<String>(
    context,
    title: 'Move to',
    options: [
      for (final folder in destinations.toList()..sort())
        PickerOption(
          folder,
          folder.isEmpty ? project.name : folder,
          icon: folder.isEmpty ? Icons.home_outlined : Icons.folder_outlined,
        ),
    ],
  );
}
