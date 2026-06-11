import 'package:fludget/catalog/engine/code_format.dart';
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/slots/slot.dart';

/// Dart source for [node]'s widget expression, resolving types and children
/// through [source]. Children are generated depth-first; output is 2-space
/// indented (see code_format). A def's custom `toCode` wins when present;
/// otherwise the constructor is built from its declared props and slots.
String generateExpression(WidgetNode node, WidgetSource source) {
  final def = source.defFor(node.type);
  if (def == null) return '/* unknown: ${node.type} */';

  final childCode = {
    for (final entry in node.slots.entries)
      entry.key: [
        for (final child in entry.value) generateExpression(child, source),
      ],
  };

  final custom = def.toCode;
  if (custom != null) return custom(node, childCode);

  final args = <String, String>{};
  for (final prop in def.props) {
    if (node.props.containsKey(prop.name)) args[prop.name] = prop.toCode(node);
  }
  for (final slot in def.slots) {
    final code = childCode[slot.name] ?? const [];
    if (code.isEmpty) continue;
    args[slot.name] = slot.arity == SlotArity.single
        ? code.first
        : emitList(code);
  }
  return emitConstructor(node.type, args);
}

/// Wraps [node] in a minimal StatelessWidget named [className].
String generate(
  WidgetNode node,
  WidgetSource source, {
  required String className,
}) {
  final body = generateExpression(node, source).replaceAll('\n', '\n    ');
  return '''
class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    return $body;
  }
}''';
}
