import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:flutter/material.dart';

/// One open tab: the component being edited and its editor. The display name
/// isn't stored — it's read from the project by id, so a rename can't leave a
/// stale tab label.
typedef OpenTab = ({String componentId, ComponentEditorCubit editor});

/// The open tabs and which one is active.
@immutable
class WorkspaceState {
  const WorkspaceState({this.tabs = const [], this.activeIndex = 0});

  final List<OpenTab> tabs;
  final int activeIndex;

  /// The active tab, or null when there are none.
  OpenTab? get active =>
      activeIndex >= 0 && activeIndex < tabs.length ? tabs[activeIndex] : null;

  /// Whether any open editor has unsaved changes — queried on demand, e.g.
  /// before switching or closing a project.
  bool get anyDirty => tabs.any((t) => t.editor.state.isDirty);

  WorkspaceState copyWith({List<OpenTab>? tabs, int? activeIndex}) =>
      WorkspaceState(
        tabs: tabs ?? this.tabs,
        activeIndex: activeIndex ?? this.activeIndex,
      );
}
