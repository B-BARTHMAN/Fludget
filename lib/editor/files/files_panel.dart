import 'dart:async';

import 'package:fludget/editor/files/explorer_tree.dart';
import 'package:fludget/editor/files/files_actions.dart' as actions;
import 'package:fludget/editor/project/project_cubit.dart';
import 'package:fludget/editor/project/project_state.dart';
import 'package:fludget/editor/workspace/workspace_cubit.dart';
import 'package:fludget/project/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilesPanel extends StatelessWidget {
  const FilesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        final project = state.project;
        if (project == null) return const SizedBox.shrink();
        final tree = buildExplorerTree(project);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(child: _ProjectMenu(name: project.name)),
                  IconButton(
                    icon: const Icon(Icons.note_add_outlined),
                    tooltip: 'New component',
                    onPressed: () =>
                        unawaited(actions.createComponentIn(context, '')),
                  ),
                  IconButton(
                    icon: const Icon(Icons.create_new_folder_outlined),
                    tooltip: 'New folder',
                    onPressed: () =>
                        unawaited(actions.createFolderIn(context, '')),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  for (final folder in tree.folders)
                    _FolderTile(folder: folder),
                  for (final component in tree.components)
                    _ComponentTile(component: component, folder: ''),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectMenu extends StatelessWidget {
  const _ProjectMenu({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Project actions',
      position: PopupMenuPosition.under,
      onSelected: (value) {
        switch (value) {
          case 'open':
            unawaited(actions.openProject(context));
          case 'new':
            unawaited(actions.newProject(context));
          case 'rename':
            unawaited(actions.renameProject(context));
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'open', child: Text('Open project…')),
        PopupMenuItem(value: 'new', child: Text('New project')),
        PopupMenuItem(value: 'rename', child: Text('Rename project…')),
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
    );
  }
}

class _FolderTile extends StatelessWidget {
  const _FolderTile({required this.folder});

  final ExplorerFolder folder;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey('folder:${folder.path}'),
      initiallyExpanded: true,
      leading: const Icon(Icons.folder_outlined),
      tilePadding: const EdgeInsets.only(left: 16, right: 4),
      childrenPadding: const EdgeInsets.only(left: 12),
      title: Row(
        children: [
          Expanded(child: Text(folder.name, overflow: TextOverflow.ellipsis)),
          _FolderMenu(folder: folder),
        ],
      ),
      children: [
        for (final child in folder.folders) _FolderTile(folder: child),
        for (final component in folder.components)
          _ComponentTile(component: component, folder: folder.path),
      ],
    );
  }
}

class _FolderMenu extends StatelessWidget {
  const _FolderMenu({required this.folder});

  final ExplorerFolder folder;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      tooltip: 'Folder actions',
      onSelected: (value) {
        switch (value) {
          case 'new-component':
            unawaited(actions.createComponentIn(context, folder.path));
          case 'new-folder':
            unawaited(actions.createFolderIn(context, folder.path));
          case 'rename':
            unawaited(actions.renameFolder(context, folder));
          case 'move':
            unawaited(actions.moveFolder(context, folder));
          case 'delete':
            unawaited(actions.deleteFolder(context, folder));
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'new-component',
          child: Text('New component'),
        ),
        const PopupMenuItem(value: 'new-folder', child: Text('New folder')),
        if (folder.path.isNotEmpty) ...[
          const PopupMenuDivider(),
          const PopupMenuItem(value: 'rename', child: Text('Rename')),
          const PopupMenuItem(value: 'move', child: Text('Move')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ],
    );
  }
}

class _ComponentTile extends StatelessWidget {
  const _ComponentTile({required this.component, required this.folder});

  final Component component;
  final String folder;

  @override
  Widget build(BuildContext context) {
    final activeId = context
        .watch<WorkspaceCubit>()
        .state
        .activeTab
        ?.componentId;
    return ListTile(
      dense: true,
      selected: activeId == component.id,
      leading: const Icon(Icons.widgets_outlined, size: 20),
      contentPadding: const EdgeInsets.only(left: 16, right: 4),
      title: Text(component.name, overflow: TextOverflow.ellipsis),
      onTap: () => context.read<WorkspaceCubit>().openComponent(component.id),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20),
        tooltip: 'Component actions',
        onSelected: (value) {
          switch (value) {
            case 'rename':
              unawaited(actions.renameComponent(context, component));
            case 'move':
              unawaited(actions.moveComponent(context, component, folder));
            case 'delete':
              unawaited(actions.deleteComponent(context, component));
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'rename', child: Text('Rename')),
          PopupMenuItem(value: 'move', child: Text('Move')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}
