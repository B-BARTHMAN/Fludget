import 'package:fludget/core/domain/widget_registry.dart';
import 'package:fludget/core/models/child_rule.dart';
import 'package:fludget/core/models/widget_node.dart';
import 'package:fludget/features/document/cubit/document_state.dart';
import 'package:fludget/features/document/logic/tree_ops.dart' as tree;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit(WidgetNode root) : super(DocumentState(root: root));

  static const _uuid = Uuid();

  void select(String? id) => emit(state.copyWith(selectedId: id));

  void addChild(String parentId, String type) {
    final parent = tree.findById(state.root, parentId);
    if (parent == null) return;
    final rule = widgetRegistry[parent.type]?.childRule ?? ChildRule.none;
    if (rule == ChildRule.none) return;
    if (rule == ChildRule.single && parent.children.isNotEmpty) return;

    final child = WidgetNode(id: _uuid.v4(), type: type);
    _commit(tree.addChild(state.root, parentId, child));
  }

  void updateProps(String id, Map<String, dynamic> changes) =>
      _commit(tree.updateProps(state.root, id, changes));

  void delete(String id) {
    if (id == state.root.id) return; // never delete the root
    emit(
      state.copyWith(
        root: tree.removeById(state.root, id),
        past: [...state.past, state.root],
        future: const [],
        selectedId: state.selectedId == id ? null : state.selectedId,
      ),
    );
  }

  void undo() {
    if (state.past.isEmpty) return;
    final previous = state.past.last;
    emit(
      state.copyWith(
        root: previous,
        past: state.past.sublist(0, state.past.length - 1),
        future: [state.root, ...state.future],
        selectedId: _keepSelection(previous),
      ),
    );
  }

  void redo() {
    if (state.future.isEmpty) return;
    final next = state.future.first;
    emit(
      state.copyWith(
        root: next,
        past: [...state.past, state.root],
        future: state.future.sublist(1),
        selectedId: _keepSelection(next),
      ),
    );
  }

  void _commit(WidgetNode newRoot) => emit(
    state.copyWith(
      root: newRoot,
      past: [...state.past, state.root],
      future: const [],
    ),
  );

  String? _keepSelection(WidgetNode root) =>
      state.selectedId != null && tree.findById(root, state.selectedId!) != null
      ? state.selectedId
      : null;
}
