import 'package:fludget/catalog/widgets/category.dart';
import 'package:flutter/material.dart';

/// Top-level categories, declared once with their picker icons. Nest by
/// declaring an explicit path, e.g.
/// `static const buttons = Category(['Material', 'Buttons'], icon: ...);`
abstract final class Categories {
  static const layout = Category(['Layout'], icon: Icons.dashboard_outlined);
  static const display = Category(['Display'], icon: Icons.image_outlined);
  static const input = Category(['Input'], icon: Icons.keyboard_outlined);

  /// Where the project's own components appear, mirroring the files tree.
  static const custom = Category(
    ['Custom'],
    icon: Icons.dashboard_customize_outlined,
  );

  static const List<Category> _declared = [layout, display, input, custom];

  /// The icon for the category at [path] — its declared icon, else a folder.
  static IconData iconFor(List<String> path) {
    final probe = Category(path);
    for (final category in _declared) {
      if (category == probe) return category.icon ?? Icons.folder_outlined;
    }
    return Icons.folder_outlined;
  }
}
