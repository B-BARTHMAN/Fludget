import 'package:fludget/core/ui/menus/menu_action.dart';
import 'package:fludget/core/ui/tokens.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:fludget/features/project/ui/file_actions.dart' as actions;
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One component row in the explorer: tap to open it, with a menu of actions.
class ComponentTile extends StatelessWidget {
  const ComponentTile({
    required this.component,
    required this.folder,
    super.key,
  });

  final Component component;
  final String folder;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.read<WorkspaceCubit>().openComponent(component.id),
      child: SizedBox(
        height: Sizes.treeRow,
        child: Row(
          children: [
            const SizedBox(width: Insets.lg),
            Icon(
              Icons.description_outlined,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: Insets.sm),
            Expanded(
              child: Text(component.name, overflow: TextOverflow.ellipsis),
            ),
            ActionMenu(
              tooltip: 'Component actions',
              actions: [
                MenuAction(
                  'Rename',
                  () => actions.renameComponent(context, component),
                  icon: Icons.edit_outlined,
                ),
                MenuAction(
                  'Move',
                  () => actions.moveComponent(context, component, folder),
                  icon: Icons.drive_file_move_outlined,
                ),
                MenuAction(
                  'Delete',
                  () => actions.deleteComponent(context, component),
                  icon: Icons.delete_outline,
                  isDestructive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
