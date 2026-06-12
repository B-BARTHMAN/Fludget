import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/model/tree_ops.dart' as tree;
import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/slots/slot.dart';
import 'package:fludget/features/editor/state/component_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/// Owns the editable tree of one component: structural edits (via the pure
/// `tree_ops`), selection, and snapshot undo/redo. Editing *policy* lives here
/// too — a single slot won't take a second child — using slot definitions
/// resolved through [WidgetSource].
class ComponentEditorCubit extends Cubit<ComponentEditorState> {
  ComponentEditorCubit(this._source, WidgetNode? root)
    : super(ComponentEditorState(root: root, savedRoot: root));

  final WidgetSource _source;
  static const _uuid = Uuid();

  void select(String? id) => emit(state.copyWith(selectedId: id));

  /// Sets the component's first widget. No-op once a root exists.
  void setRoot(String type) {
    if (state.root != null) return;
    _commit(WidgetNode(id: _uuid.v4(), type: type));
  }

  void addChild(String parentId, String slotName, String type) {
    final root = state.root;
    if (root == null) return;
    final parent = tree.findById(root, parentId);
    if (parent == null) return;
    final slot = _slot(parent.type, slotName);
    if (slot == null || !slot.hasRoom(parent)) return; // policy lives here
    _commit(
      tree.addChild(
        root,
        parentId,
        slotName,
        WidgetNode(id: _uuid.v4(), type: type),
      ),
    );
  }

  void updateProps(String id, Map<String, Object?> changes) {
    final root = state.root;
    if (root != null) _commit(tree.updateProps(root, id, changes));
  }

  void delete(String id) {
    final root = state.root;
    if (root == null) return;
    final newRoot = id == root.id ? null : tree.removeById(root, id);
    emit(
      state.copyWith(
        root: newRoot,
        past: [...state.past, root],
        future: const [],
        selectedId: state.selectedId == id ? null : state.selectedId,
      ),
    );
  }

  void undo() {
    if (!state.canUndo) return;
    emit(
      state.copyWith(
        root: state.past.last,
        past: state.past.sublist(0, state.past.length - 1),
        future: [state.root, ...state.future],
        selectedId: _keepSelection(state.past.last),
      ),
    );
  }

  void redo() {
    if (!state.canRedo) return;
    emit(
      state.copyWith(
        root: state.future.first,
        past: [...state.past, state.root],
        future: state.future.sublist(1),
        selectedId: _keepSelection(state.future.first),
      ),
    );
  }

  /// Marks the current tree as the saved baseline (clears the dirty flag).
  void markSaved() => emit(state.copyWith(savedRoot: state.root));

  Slot? _slot(String type, String name) {
    for (final slot in _source.defFor(type)?.slots ?? const <Slot>[]) {
      if (slot.name == name) return slot;
    }
    return null;
  }

  void _commit(WidgetNode? newRoot) => emit(
    state.copyWith(
      root: newRoot,
      past: [...state.past, state.root],
      future: const [],
    ),
  );

  String? _keepSelection(WidgetNode? root) {
    final id = state.selectedId;
    if (root == null || id == null) return null;
    return tree.findById(root, id) != null ? id : null;
  }
}
