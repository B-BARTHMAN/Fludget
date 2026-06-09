import 'package:fludget/editor/document/document_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_state.freezed.dart';

/// One open component as a top-bar tab. Keyed on component id; the display name
/// is looked up from the project, so renames reflect for free.
typedef DocumentTab = ({String componentId, DocumentCubit cubit});

@freezed
abstract class WorkspaceState with _$WorkspaceState {
  const factory WorkspaceState({
    @Default(<DocumentTab>[]) List<DocumentTab> tabs,
    @Default(0) int activeIndex,
  }) = _WorkspaceState;

  const WorkspaceState._();

  bool get hasTabs => tabs.isNotEmpty;

  bool isOpen(String componentId) =>
      tabs.any((t) => t.componentId == componentId);

  DocumentTab? get activeTab {
    if (tabs.isEmpty) return null;
    final i = activeIndex < 0
        ? 0
        : (activeIndex >= tabs.length ? tabs.length - 1 : activeIndex);
    return tabs[i];
  }

  DocumentCubit? get activeDocument => activeTab?.cubit;
  bool get anyDirty => tabs.any((t) => t.cubit.state.isDirty);
}
