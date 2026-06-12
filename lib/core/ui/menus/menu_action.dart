import 'package:flutter/material.dart';

/// One entry in a popup menu: a [label] and what to do when chosen. Replaces
/// the stringly-typed `PopupMenuButton` value + `onSelected` switch — each
/// action carries its own callback, so there's no value to match.
@immutable
class MenuAction {
  const MenuAction(
    this.label,
    this.onSelected, {
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onSelected;
  final IconData? icon;
  final bool isDestructive;
}

/// A popup menu built from typed [MenuAction]s. Selecting one runs its
/// callback directly — no string matching anywhere.
class ActionMenu extends StatelessWidget {
  const ActionMenu({
    required this.actions,
    this.icon = Icons.more_vert,
    this.tooltip,
    this.child,
    super.key,
  });

  final List<MenuAction> actions;
  final IconData icon;
  final String? tooltip;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PopupMenuButton<MenuAction>(
      tooltip: tooltip ?? '',
      icon: child == null ? Icon(icon, size: 20) : null,
      position: PopupMenuPosition.under,
      onSelected: (action) => action.onSelected(),
      itemBuilder: (context) => [
        for (final action in actions)
          PopupMenuItem(
            value: action,
            child: Row(
              children: [
                if (action.icon != null) ...[
                  Icon(
                    action.icon,
                    size: 18,
                    color: action.isDestructive ? colors.error : null,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  action.label,
                  style: action.isDestructive
                      ? TextStyle(color: colors.error)
                      : null,
                ),
              ],
            ),
          ),
      ],
      child: child,
    );
  }
}
