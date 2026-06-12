import 'package:flutter/material.dart';

/// One square in the widget picker: a [label] under an [icon]. Either a
/// category to drill into (has [children]) or a selectable widget (has a
/// [type] — a built-in name or a component id). Built purely from the catalog
/// and, for the `Custom` branch, from the project's components.
@immutable
class PickerNode {
  const PickerNode({
    required this.label,
    required this.icon,
    this.type,
    this.children = const [],
  });

  final String label;
  final IconData icon;

  /// The widget type to insert when chosen, or null for a category.
  final String? type;

  final List<PickerNode> children;

  bool get isLeaf => type != null;
}
