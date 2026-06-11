import 'package:fludget/catalog/widget_def.dart';

/// A node in the widget-picker tree: a category, its sub-categories, and the
/// widgets directly inside it. Built purely by grouping defs on their declared
/// category path — the picker's analogue of the files-explorer tree.
class CatalogCategory {
  const CatalogCategory({
    required this.name,
    this.subcategories = const [],
    this.widgets = const [],
  });

  final String name;
  final List<CatalogCategory> subcategories;
  final List<WidgetDef> widgets;
}

/// Groups [defs] into the category tree the picker renders, sorted by name at
/// every level.
List<CatalogCategory> buildCatalogTree(Iterable<WidgetDef> defs) =>
    _build(defs.toList(), 0);

List<CatalogCategory> _build(List<WidgetDef> defs, int depth) {
  final bySegment = <String, List<WidgetDef>>{};
  for (final def in defs) {
    bySegment.putIfAbsent(def.category.path[depth], () => []).add(def);
  }

  return [
    for (final entry in bySegment.entries)
      CatalogCategory(
        name: entry.key,
        widgets: [
          for (final def in entry.value)
            if (def.category.path.length == depth + 1) def,
        ]..sort((a, b) => a.type.compareTo(b.type)),
        subcategories: _build(
          [
            for (final def in entry.value)
              if (def.category.path.length > depth + 1) def,
          ],
          depth + 1,
        ),
      ),
  ]..sort((a, b) => a.name.compareTo(b.name));
}
