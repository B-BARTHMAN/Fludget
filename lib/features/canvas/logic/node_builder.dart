import 'package:fludget/core/models/widget_node.dart';
import 'package:fludget/features/canvas/logic/prop_decode.dart';
import 'package:flutter/material.dart';

/// Recursively renders a WidgetNode tree into real Flutter widgets for the
/// canvas. Per-type rendering lives here; the registry stays pure schema.
Widget buildNode(WidgetNode node) {
  final children = [for (final c in node.children) buildNode(c)];
  final props = node.props;
  Widget? firstChild() => children.isEmpty ? null : children.first;

  switch (node.type) {
    case 'Text':
      return Text(
        (props['data'] as String?) ?? 'Text',
        style: decodeTextStyle(props['style']),
      );
    case 'Icon':
      return Icon(
        iconCatalog[props['icon']] ?? Icons.star,
        size: (props['size'] as num?)?.toDouble(),
        color: decodeColor(props['color']),
      );
    case 'Container':
      return Container(
        width: (props['width'] as num?)?.toDouble(),
        height: (props['height'] as num?)?.toDouble(),
        color: decodeColor(props['color']),
        padding: props['padding'] == null
            ? null
            : decodeEdgeInsets(props['padding']),
        alignment: decodeAlignment(props['alignment']),
        child: firstChild(),
      );
    case 'Padding':
      return Padding(
        padding: decodeEdgeInsets(props['padding'] ?? 8.0),
        child: firstChild(),
      );
    case 'Center':
      return Center(child: firstChild());
    case 'SizedBox':
      return SizedBox(
        width: (props['width'] as num?)?.toDouble(),
        height: (props['height'] as num?)?.toDouble(),
        child: firstChild(),
      );
    case 'Row':
      return Row(
        mainAxisAlignment: enumByName(
          MainAxisAlignment.values,
          props['mainAxisAlignment'],
          MainAxisAlignment.start,
        ),
        crossAxisAlignment: enumByName(
          CrossAxisAlignment.values,
          props['crossAxisAlignment'],
          CrossAxisAlignment.center,
        ),
        children: children,
      );
    case 'Column':
      return Column(
        mainAxisAlignment: enumByName(
          MainAxisAlignment.values,
          props['mainAxisAlignment'],
          MainAxisAlignment.start,
        ),
        crossAxisAlignment: enumByName(
          CrossAxisAlignment.values,
          props['crossAxisAlignment'],
          CrossAxisAlignment.center,
        ),
        children: children,
      );
    default:
      return const SizedBox.shrink();
  }
}
