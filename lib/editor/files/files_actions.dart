import 'package:fludget/editor/files/explorer_tree.dart';
import 'package:fludget/editor/files/files_dialogs.dart';
import 'package:fludget/editor/project/project_cubit.dart';
import 'package:fludget/editor/workspace/workspace_cubit.dart';
import 'package:fludget/project/component.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> createComponentIn(BuildContext context, String folder) async {
  final project = context.read<ProjectCubit>();
  final workspace = context.read<WorkspaceCubit>();
  final name = await promptName(
    context,
    title: 'New component',
    initial: 'Untitled',
  );
  if (name == null) return;
  final id = await project.createComponent(folder: folder, name: name);
  if (id != null) workspace.openComponent(id);
}

Future<void> createFolderIn(BuildContext context, String parent) async {
  final project = context.read<ProjectCubit>();
  final name = await promptName(
    context,
    title: 'New folder',
    initial: 'New Folder',
  );
  if (name == null) return;
  await project.createFolder(parent: parent, name: name);
}

Future<void> renameComponent(BuildContext context, Component component) async {
  final project = context.read<ProjectCubit>();
  final name = await promptName(
    context,
    title: 'Rename component',
    initial: component.name,
  );
  if (name == null) return;
  await project.renameComponent(component.id, name);
}

Future<void> moveComponent(
  BuildContext context,
  Component component,
  String folder,
) async {
  final project = context.read<ProjectCubit>();
  final loaded = project.state.project;
  if (loaded == null) return;
  final destinations = <String>{'', ...loaded.folders}..remove(folder);
  final dest = await pickFolder(
    context,
    projectName: loaded.name,
    folders: destinations.toList()..sort(),
  );
  if (dest == null) return;
  await project.moveComponent(component.id, dest);
}

Future<void> deleteComponent(BuildContext context, Component component) async {
  final project = context.read<ProjectCubit>();
  final confirmed = await confirmDelete(context, label: component.name);
  if (!confirmed) return;
  await project.deleteComponent(component.id);
}

Future<void> renameFolder(BuildContext context, ExplorerFolder folder) async {
  final project = context.read<ProjectCubit>();
  final name = await promptName(
    context,
    title: 'Rename folder',
    initial: folder.name,
  );
  if (name == null) return;
  await project.renameFolder(folder.path, name);
}

Future<void> moveFolder(BuildContext context, ExplorerFolder folder) async {
  final project = context.read<ProjectCubit>();
  final loaded = project.state.project;
  if (loaded == null) return;
  final destinations = <String>{'', ...loaded.folders}..removeWhere(
    (f) =>
        f == folder.path ||
        f.startsWith('${folder.path}/') ||
        f == _parentOf(folder.path),
  );
  final dest = await pickFolder(
    context,
    projectName: loaded.name,
    folders: destinations.toList()..sort(),
  );
  if (dest == null) return;
  await project.moveFolder(folder.path, dest);
}

Future<void> deleteFolder(BuildContext context, ExplorerFolder folder) async {
  final project = context.read<ProjectCubit>();
  final confirmed = await confirmDelete(context, label: folder.name);
  if (!confirmed) return;
  await project.deleteFolder(folder.path);
}

String _parentOf(String path) {
  final i = path.lastIndexOf('/');
  return i == -1 ? '' : path.substring(0, i);
}