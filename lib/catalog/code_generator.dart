import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/registry.dart';

String generateExpression(WidgetNode node) {
  final def = widgetRegistry[node.type];
  if (def == null) return 'const SizedBox.shrink()';
  final children = <String, List<String>>{
    for (final entry in node.slots.entries)
      entry.key: [for (final child in entry.value) generateExpression(child)],
  };
  return def.toCode(node, children);
}

String generate(WidgetNode root, {String className = 'MyWidget'}) =>
    '''
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    return ${generateExpression(root)};
  }
}
''';
