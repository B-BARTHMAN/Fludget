import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_node.freezed.dart';
part 'widget_node.g.dart';

/// A single node in the prototype tree. Immutable.
///
/// [props] holds only plain, JSON-safe values (numbers, strings, ints for
/// colors, maps for EdgeInsets/TextStyle). Conversion to real Flutter objects
/// happens at build/codegen time, never here.
@freezed
abstract class WidgetNode with _$WidgetNode {
  const factory WidgetNode({
    required String id,
    required String type,
    @Default(<String, dynamic>{}) Map<String, dynamic> props,
    @Default(<WidgetNode>[]) List<WidgetNode> children,
  }) = _WidgetNode;

  factory WidgetNode.fromJson(Map<String, dynamic> json) =>
      _$WidgetNodeFromJson(json);
}
