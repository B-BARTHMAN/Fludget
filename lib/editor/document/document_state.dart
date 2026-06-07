import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/editor/document/tree_ops.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_state.freezed.dart';

@freezed
abstract class DocumentState with _$DocumentState {
  const factory DocumentState({
    required WidgetNode root,
    String? selectedId,
    @Default(<WidgetNode>[]) List<WidgetNode> past,
    @Default(<WidgetNode>[]) List<WidgetNode> future,
  }) = _DocumentState;

  const DocumentState._();

  bool get canUndo => past.isNotEmpty;
  bool get canRedo => future.isNotEmpty;

  WidgetNode? get selectedNode =>
      selectedId == null ? null : findById(root, selectedId!);
}
