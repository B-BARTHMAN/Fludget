import 'package:fludget/catalog/model/widget_node.dart';
import 'package:flutter/material.dart';

/// The editing state of one open component: its current [root], the
/// [selectedId], the undo/redo history (whole-tree snapshots), and the
/// [savedRoot] baseline that tells whether there are unsaved changes.
@immutable
class ComponentEditorState {
  const ComponentEditorState({
    this.root,
    this.savedRoot,
    this.selectedId,
    this.past = const [],
    this.future = const [],
  });

  final WidgetNode? root;
  final WidgetNode? savedRoot;
  final String? selectedId;
  final List<WidgetNode?> past;
  final List<WidgetNode?> future;

  bool get canUndo => past.isNotEmpty;
  bool get canRedo => future.isNotEmpty;

  /// Identity is enough: saving sets [savedRoot] to the exact current root, and
  /// undo restores the actual snapshot instances, so equal content is the same
  /// instance.
  bool get isDirty => !identical(root, savedRoot);

  // Sentinel so `copyWith` can set nullable fields *to* null (deselect, or undo
  // back to an empty root) rather than only leaving them unchanged.
  static const _unset = Object();

  ComponentEditorState copyWith({
    Object? root = _unset,
    Object? savedRoot = _unset,
    Object? selectedId = _unset,
    List<WidgetNode?>? past,
    List<WidgetNode?>? future,
  }) {
    return ComponentEditorState(
      root: root == _unset ? this.root : root as WidgetNode?,
      savedRoot: savedRoot == _unset
          ? this.savedRoot
          : savedRoot as WidgetNode?,
      selectedId: selectedId == _unset
          ? this.selectedId
          : selectedId as String?,
      past: past ?? this.past,
      future: future ?? this.future,
    );
  }
}
