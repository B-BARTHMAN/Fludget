import 'package:fludget/catalog/widgets/categories.dart';
import 'package:fludget/catalog/widgets/picker_node.dart';
import 'package:fludget/features/composition/logic/component_library.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:fludget/features/project/logic/explorer_tree.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';
import 'package:flutter/material.dart';

/// The `Custom` picker branch: the project's components, mirroring the files
/// explorer. A component is offered only when inserting it into the component
/// being edited ([editingId]) wouldn't create a cycle. Null when none qualify.
PickerNode? buildCustomNode(LoadedProject project, String? editingId) {
  final graph = ComponentLibrary(project).graph();

  bool canInsert(Component component) {
    if (component.id == editingId) return false;
    if (editingId == null) return true;
    // Inserting makes [editingId] depend on it; reject if it already reaches
    // [editingId].
    return !graph.dependsOn(component.id, editingId);
  }

  final children = _nodesFor(buildExplorerTree(project), canInsert);
  if (children.isEmpty) return null;
  return PickerNode(
    label: 'Custom',
    icon: Categories.iconFor(Categories.custom.path),
    children: children,
  );
}

List<PickerNode> _nodesFor(
  ExplorerFolder folder,
  bool Function(Component) canInsert,
) {
  final nodes = <PickerNode>[];
  for (final sub in folder.folders) {
    final kids = _nodesFor(sub, canInsert);
    if (kids.isNotEmpty) {
      nodes.add(
        PickerNode(
          label: sub.name,
          icon: Icons.folder_outlined,
          children: kids,
        ),
      );
    }
  }
  for (final c in folder.components) {
    if (canInsert(c)) {
      nodes.add(
        PickerNode(
          label: c.name,
          icon: Icons.dashboard_customize_outlined,
          type: c.id,
        ),
      );
    }
  }
  return nodes;
}
