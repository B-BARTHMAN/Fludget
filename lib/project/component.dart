import 'package:fludget/catalog/model/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'component.freezed.dart';
part 'component.g.dart';

/// One component = one StatelessWidget's worth of content, stored as one JSON
/// file inside a project. [id] is a stable uuid and is what references point at;
/// [name] doubles as the on-disk filename (`<name>.json`).
@freezed
abstract class Component with _$Component {
  const factory Component({
    required String id,
    required String name,
    required WidgetNode root,
  }) = _Component;

  factory Component.fromJson(Map<String, dynamic> json) =>
      _$ComponentFromJson(json);
}
