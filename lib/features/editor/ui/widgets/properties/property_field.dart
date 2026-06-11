import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:flutter/material.dart';

/// One labelled row in the properties panel: the prop's label above its editor.
/// Uses [Prop.label] when set, otherwise humanizes the prop name.
class PropertyField extends StatelessWidget {
  const PropertyField({
    required this.prop,
    required this.node,
    required this.onChanged,
    super.key,
  });

  final Prop<dynamic> prop;
  final WidgetNode node;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prop.label ?? _humanize(prop.name),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          prop.editor(node, onChanged),
        ],
      ),
    );
  }
}

/// `mainAxisAlignment` -> `Main axis alignment`.
String _humanize(String name) {
  final spaced = name.replaceAllMapped(
    RegExp('[A-Z]'),
    (m) => ' ${m[0]!.toLowerCase()}',
  );
  return spaced.isEmpty
      ? name
      : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
