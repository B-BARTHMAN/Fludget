import 'package:fludget/catalog/registry.dart';
import 'package:flutter/material.dart';

/// Lists every registered widget type and reports the chosen one. Pass either
/// [icon] or [child] as the trigger (not both — PopupMenuButton asserts).
class WidgetTypeMenu extends StatelessWidget {
  const WidgetTypeMenu({
    required this.onSelected,
    this.icon,
    this.child,
    this.tooltip = 'Add widget',
    super.key,
  });

  final ValueChanged<String> onSelected;
  final Widget? icon;
  final Widget? child;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: tooltip,
      onSelected: onSelected,
      icon: icon,
      child: child,
      itemBuilder: (context) => [
        for (final type in widgetRegistry.keys)
          PopupMenuItem(value: type, child: Text(type)),
      ],
    );
  }
}
