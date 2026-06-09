import 'dart:async';

import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/project/project_cubit.dart';
import 'package:fludget/editor/project/project_state.dart';
import 'package:fludget/editor/workspace/workspace_state.dart';
import 'package:fludget/project/loaded_project.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Owns the open components (top-bar tabs) and the active one. Seeds a
/// [DocumentCubit] per open component from [ProjectCubit]; roots and
/// persistence live in [ProjectCubit].
class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit({required ProjectCubit project})
    : _project = project,
      super(const WorkspaceState()) {
    _projectSub = _project.stream.listen(_onProject);
    _onProject(_project.state);
  }

  final ProjectCubit _project;
  late final StreamSubscription<ProjectState> _projectSub;
  bool _opened = false;

  void openComponent(String id) {
    final existing = state.tabs.indexWhere((t) => t.componentId == id);
    if (existing != -1) {
      emit(state.copyWith(activeIndex: existing));
      return;
    }
    final project = _project.state.project;
    if (project == null || project.component(id) == null) return;
    final tab = (componentId: id, cubit: DocumentCubit(project.rootOf(id)));
    emit(
      state.copyWith(
        tabs: [...state.tabs, tab],
        activeIndex: state.tabs.length,
      ),
    );
  }

  Future<void> saveActive() => saveTabAt(state.activeIndex);

  Future<void> saveTabAt(int index) async {
    if (index < 0 || index >= state.tabs.length) return;
    final tab = state.tabs[index];
    final saved = tab.cubit.state.root;
    await _project.saveComponent(tab.componentId, saved);
    tab.cubit.markSaved(saved);
  }

  Future<void> saveAll() async {
    for (final tab in state.tabs) {
      if (!tab.cubit.state.isDirty) continue;
      final saved = tab.cubit.state.root;
      await _project.saveComponent(tab.componentId, saved);
      tab.cubit.markSaved(saved);
    }
  }

  void switchTo(int index) {
    if (index < 0 || index >= state.tabs.length) return;
    emit(state.copyWith(activeIndex: index));
  }

  Future<void> closeTab(int index) async {
    if (index < 0 || index >= state.tabs.length) return;
    final closing = state.tabs[index];
    final tabs = [...state.tabs]..removeAt(index);

    var active = state.activeIndex;
    if (index < active || active >= tabs.length) {
      active = active > 0 ? active - 1 : 0;
    }

    emit(state.copyWith(tabs: tabs, activeIndex: active));
    await closing.cubit.close();
  }

  void _onProject(ProjectState projectState) {
    final loaded = projectState.project;
    if (loaded == null) return;
    _pruneClosedComponents(loaded);
    if (!_opened) {
      final first = loaded.firstComponentId;
      if (first != null) {
        _opened = true;
        openComponent(first);
      }
    }
  }

  /// Closes tabs whose component no longer exists — deleted directly, or via a
  /// deleted folder.
  void _pruneClosedComponents(LoadedProject loaded) {
    final surviving = state.tabs
        .where((t) => loaded.components.containsKey(t.componentId))
        .toList();
    if (surviving.length == state.tabs.length) return;

    for (final t in state.tabs) {
      if (!loaded.components.containsKey(t.componentId)) t.cubit.close();
    }

    var active = state.activeIndex;
    if (surviving.isEmpty) {
      active = 0;
    } else if (active >= surviving.length) {
      active = surviving.length - 1;
    } else if (active < 0) {
      active = 0;
    }

    emit(state.copyWith(tabs: surviving, activeIndex: active));
  }

  @override
  Future<void> close() async {
    await _projectSub.cancel();
    for (final tab in state.tabs) {
      await tab.cubit.close();
    }
    return super.close();
  }
}
