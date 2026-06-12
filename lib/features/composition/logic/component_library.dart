import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/features/composition/logic/component_graph.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';

/// A read-only view of a project's components as composable widgets: lookup by
/// id, the references each holds, and the dependency [graph].
class ComponentLibrary {
  ComponentLibrary(this._project);

  final LoadedProject _project;

  Component? byId(String id) => _project.components[id];
  bool contains(String id) => _project.components.containsKey(id);
  Iterable<Component> get all => _project.components.values;

  /// Names of components that reference [id] — for delete-in-use warnings.
  List<String> dependentsOf(String id) => [
    for (final c in all)
      if (directDeps(c.root).contains(id)) c.name,
  ];

  /// The components [root] references directly.
  Set<String> directDeps(WidgetNode? root) {
    final deps = <String>{};
    void walk(WidgetNode node) {
      if (contains(node.type)) deps.add(node.type);
      for (final children in node.slots.values) {
        children.forEach(walk);
      }
    }

    if (root != null) walk(root);
    return deps;
  }

  ComponentGraph graph() =>
      ComponentGraph({for (final c in all) c.id: directDeps(c.root)});
}
