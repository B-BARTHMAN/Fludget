import 'package:fludget/catalog/registry.dart';
import 'package:fludget/catalog/widgets/catalog_tree.dart';
import 'package:flutter/material.dart';

/// A categorized picker over the widget catalog. Opens a nested menu (built
/// from [buildCatalogTree]) and reports the chosen widget [type] via
/// [onSelected]. Shared by the empty canvas ("add the first widget") and the
/// tree ("add a child").
class WidgetPicker extends StatelessWidget {
  const WidgetPicker({
    required this.onSelected,
    required this.child,
    super.key,
  });

  /// Called with the chosen widget type, e.g. `'Container'`.
  final ValueChanged<String> onSelected;

  /// The trigger (a button, an add icon, …).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: _menu(buildCatalogTree(widgetRegistry.values)),
      builder: (context, controller, child) => GestureDetector(
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: child,
      ),
      child: child,
    );
  }

  List<Widget> _menu(List<CatalogCategory> categories) => [
    for (final category in categories)
      SubmenuButton(
        menuChildren: [
          ..._menu(category.subcategories),
          for (final def in category.widgets)
            MenuItemButton(
              onPressed: () => onSelected(def.type),
              child: Text(def.type),
            ),
        ],
        child: Text(category.name),
      ),
  ];
}
