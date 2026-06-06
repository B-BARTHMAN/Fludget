import 'package:fludget/features/document/cubit/document_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_state.freezed.dart';

typedef DocumentTab = ({String name, DocumentCubit cubit});

@freezed
abstract class WorkspaceState with _$WorkspaceState {
  const WorkspaceState._();

  const factory WorkspaceState({
    @Default(<DocumentTab>[]) List<DocumentTab> tabs,
    @Default(0) int activeIndex,
  }) = _WorkspaceState;

  bool get hasTabs => tabs.isNotEmpty;

  DocumentTab? get activeTab {
    if (tabs.isEmpty) return null;
    final i = activeIndex < 0
        ? 0
        : (activeIndex >= tabs.length ? tabs.length - 1 : activeIndex);
    return tabs[i];
  }

  DocumentCubit? get activeDocument => activeTab?.cubit;
}
