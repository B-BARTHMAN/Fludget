import 'package:fludget/features/project/logic/loaded_project.dart';
import 'package:fludget/features/workspace/state/workspace_state.dart';

/// Reconciles open [state] against the latest [project]: keeps only tabs whose
/// component still exists, and keeps the active tab active (or falls back to
/// the first) when it survived.
///
/// This replaces the rename-vs-switch flags the old code tracked. Renaming a
/// project keeps component ids, so tabs survive; switching projects changes
/// them, so every tab drops and the workspace ends up empty — at which point
/// the cubit opens the new project's first component.
WorkspaceState reconcileTabs(WorkspaceState state, LoadedProject project) {
  final survivors = [
    for (final tab in state.tabs)
      if (project.components.containsKey(tab.componentId)) tab,
  ];
  final activeId = state.active?.componentId;
  final index = survivors.indexWhere((t) => t.componentId == activeId);
  return WorkspaceState(tabs: survivors, activeIndex: index == -1 ? 0 : index);
}
