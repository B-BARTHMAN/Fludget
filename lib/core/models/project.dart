import 'package:fludget/core/models/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// A project = one tab's content. One JSON file on disk.
@freezed
abstract class Project with _$Project {
  const factory Project({
    required String name,
    required WidgetNode root,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
