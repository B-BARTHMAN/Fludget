import 'package:fludget/catalog/engine/code_generator.dart';
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/core/util/identifiers.dart';
import 'package:fludget/features/composition/logic/component_graph.dart';
import 'package:fludget/features/composition/logic/component_library.dart';
import 'package:fludget/features/project/logic/component.dart';

/// Generates the full Dart for [target]: a StatelessWidget class for it and for
/// every component it uses, in dependency order, so the output compiles alone.
/// The (possibly unsaved) [target] is used for itself; saved roots for the
/// rest. Empty components are skipped.
String generateProgram(
  Component target,
  WidgetSource source,
  ComponentLibrary library,
) {
  final deps = {for (final c in library.all) c.id: library.directDeps(c.root)};
  deps[target.id] = library.directDeps(target.root);

  Component? resolve(String id) => id == target.id ? target : library.byId(id);

  final classes = <String>[];
  for (final id in ComponentGraph(deps).resolutionOrder(target.id)) {
    final component = resolve(id);
    final root = component?.root;
    if (root == null) continue;
    classes.add(generate(root, source, className: pascalCase(component!.name)));
  }
  return classes.join('\n\n');
}
