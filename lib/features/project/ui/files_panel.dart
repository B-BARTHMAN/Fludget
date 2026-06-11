import 'package:fludget/core/ui/menus/menu_action.dart';
import 'package:fludget/features/project/logic/explorer_tree.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/project/state/project_state.dart';
import 'package:fludget/features/project/ui/component_tile.dart';
import 'package:fludget/features/project/ui/file_actions.dart' as files;
import 'package:fludget/features/project/ui/folder_tile.dart';
import 'package:fludget/features/project/ui/project_actions.dart' as project;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The files explorer: a header (project menu + new buttons) over the folder
/// and component tree derived from the project.
class FilesPanel extends StatelessWidget {
  const FilesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        final loaded = state.project;
        if (loaded == null) return const SizedBox.shrink();
        final tree = buildExplorerTree(loaded);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(name: loaded.name),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  for (final folder in tree.folders) FolderTile(folder: folder),
                  for (final component in tree.components)
                    ComponentTile(component: component, folder: ''),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: ActionMenu(
              tooltip: 'Project actions',
              actions: [
                MenuAction(
                  'Open project…',
                  () => project.openProject(context),
                  icon: Icons.folder_open,
                ),
                MenuAction(
                  'New project',
                  () => project.newProject(context),
                  icon: Icons.create_new_folder,
                ),
                MenuAction(
                  'Rename project…',
                  () => project.renameProject(context),
                  icon: Icons.edit_outlined,
                ),
                MenuAction(
                  'Delete project',
                  () => project.deleteProject(context),
                  icon: Icons.delete_outline,
                  isDestructive: true,
                ),
              ],
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.note_add_outlined),
            tooltip: 'New component',
            onPressed: () => files.createComponentIn(context, ''),
          ),
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: 'New folder',
            onPressed: () => files.createFolderIn(context, ''),
          ),
        ],
      ),
    );
  }
}
