import 'package:fludget/catalog/widget_def.dart';
import 'package:fludget/catalog/widgets/categories.dart';
import 'package:fludget/catalog/widgets/picker_node.dart';

/// Groups [defs] into the picker's tree by their declared category path.
/// Sub-categories come first at each level, then widgets; both sorted by name.
List<PickerNode> buildCatalogNodes(Iterable<WidgetDef> defs) =>
    _group(defs.toList(), const [], 0);

List<PickerNode> _group(List<WidgetDef> defs, List<String> prefix, int depth) {
  final bySegment = <String, List<WidgetDef>>{};
  for (final def in defs) {
    bySegment.putIfAbsent(def.category.path[depth], () => []).add(def);
  }

  final nodes = <PickerNode>[];
  for (final entry in bySegment.entries) {
    final path = [...prefix, entry.key];
    final deeper = _group(
      [
        for (final d in entry.value)
          if (d.category.path.length > depth + 1) d,
      ],
      path,
      depth + 1,
    );
    final leaves = [
      for (final def in entry.value)
        if (def.category.path.length == depth + 1)
          PickerNode(
            label: def.label ?? def.type,
            icon: def.icon,
            type: def.type,
          ),
    ]..sort((a, b) => a.label.compareTo(b.label));
    nodes.add(
      PickerNode(
        label: entry.key,
        icon: Categories.iconFor(path),
        children: [...deeper, ...leaves],
      ),
    );
  }
  return nodes..sort((a, b) => a.label.compareTo(b.label));
}
