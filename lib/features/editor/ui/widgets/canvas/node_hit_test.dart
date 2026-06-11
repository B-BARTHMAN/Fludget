import 'package:flutter/rendering.dart';

/// Maps a global tap [position] to the id of the deepest node under it, by
/// hit-testing the canvas [box] for the [MetaData] tags that `node_builder`
/// attaches to each built widget. Returns null if the tap hit no tagged node.
String? nodeIdAt(RenderBox box, Offset position) {
  final result = BoxHitTestResult();
  box.hitTest(result, position: box.globalToLocal(position));
  for (final entry in result.path) {
    final target = entry.target;
    if (target is RenderMetaData && target.metaData is String) {
      return target.metaData as String;
    }
  }
  return null;
}
