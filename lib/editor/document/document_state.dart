import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/editor/document/tree_ops.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_state.freezed.dart';

@freezed
abstract class DocumentState with _$DocumentState {
  const factory DocumentState({
    required WidgetNode? root,
    required WidgetNode? savedRoot,
    String? selectedId,
    @Default(<WidgetNode>[]) List<WidgetNode> past,
    @Default(<WidgetNode>[]) List<WidgetNode> future,
  }) = _DocumentState;

  const DocumentState._();

  bool get canUndo => past.isNotEmpty;
  bool get canRedo => future.isNotEmpty;
  bool get isDirty => root != savedRoot;

  WidgetNode? get selectedNode => (root == null || selectedId == null)
      ? null
      : findById(root!, selectedId!);
}
