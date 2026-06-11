import 'package:fludget/catalog/engine/node_builder.dart';
import 'package:fludget/core/ui/tokens.dart';
import 'package:flutter/material.dart';

/// Builds the [NodeDecorator] the canvas hands to `buildNode`: every node is
/// tagged with its id for hit-testing, and the selected node gets an outline.
NodeDecorator selectionDecorator({
  required String? selectedId,
  required Color color,
}) {
  return (node, built) {
    final tagged = MetaData(
      metaData: node.id,
      behavior: HitTestBehavior.translucent,
      child: built,
    );
    if (node.id != selectedId) return tagged;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: Sizes.selectionBorder),
      ),
      child: tagged,
    );
  };
}
