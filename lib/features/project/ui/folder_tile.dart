import 'package:fludget/core/ui/menus/menu_action.dart';
import 'package:fludget/features/project/logic/explorer_tree.dart';
import 'package:fludget/features/project/ui/component_tile.dart';
import 'package:fludget/features/project/ui/file_actions.dart' as actions;
import 'package:flutter/material.dart';

/// One folder in the explorer: an expandable row with an actions menu,
/// containing its sub-folders and components. Recurses through sub-folders.
class FolderTile extends StatelessWidget {
  const FolderTile({required this.folder, super.key});

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
          ActionMenu(
            tooltip: 'Folder actions',
            actions: [
              MenuAction(
                'New component',
                () => actions.createComponentIn(context, folder.path),
                icon: Icons.note_add_outlined,
              ),
              MenuAction(
                'New folder',
                () => actions.createFolderIn(context, folder.path),
                icon: Icons.create_new_folder_outlined,
              ),
              MenuAction(
                'Rename',
                () => actions.renameFolder(context, folder),
                icon: Icons.edit_outlined,
              ),
              MenuAction(
                'Move',
                () => actions.moveFolder(context, folder),
                icon: Icons.drive_file_move_outlined,
              ),
              MenuAction(
                'Delete',
                () => actions.deleteFolder(context, folder),
                icon: Icons.delete_outline,
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
      children: [
        for (final child in folder.folders) FolderTile(folder: child),
        for (final component in folder.components)
          ComponentTile(component: component, folder: folder.path),
      ],
    );
  }
}
