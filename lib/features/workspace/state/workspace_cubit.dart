import 'dart:async';

import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/project/state/project_state.dart';
import 'package:fludget/features/workspace/state/reconcile_tabs.dart';
import 'package:fludget/features/workspace/state/workspace_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Owns the open tabs. Listens to the project and reconciles tabs against it
/// (via the pure `reconcileTabs`), creating and disposing the per-tab editors
/// and orchestrating saves. The hard logic lives in that pure function; this
/// class is the wiring around it.
class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit(this._project, this._source) : super(const WorkspaceState()) {
    _subscription = _project.stream.listen(_onProject);
  }

  final ProjectCubit _project;
  final WidgetSource _source;
  late final StreamSubscription<ProjectState> _subscription;

  void openComponent(String id) {
    final existing = state.tabs.indexWhere((t) => t.componentId == id);
    if (existing != -1) {
      emit(state.copyWith(activeIndex: existing));
      return;
    }
    final component = _project.state.project?.components[id];
    if (component == null) return;
    emit(
      state.copyWith(
        tabs: [
          ...state.tabs,
          (
            componentId: id,
            editor: ComponentEditorCubit(_source, component.root),
          ),
        ],
        activeIndex: state.tabs.length,
      ),
    );
  }

  void switchTo(int index) => emit(state.copyWith(activeIndex: index));

  Future<void> closeTab(int index) async {
    await state.tabs[index].editor.close();
    final tabs = [...state.tabs]..removeAt(index);
    final maxIndex = tabs.isEmpty ? 0 : tabs.length - 1;
    var active = state.activeIndex > index
        ? state.activeIndex - 1
        : state.activeIndex;
    if (active > maxIndex) active = maxIndex;
    emit(WorkspaceState(tabs: tabs, activeIndex: active));
  }

  void reorderTab(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final tabs = [...state.tabs];
    tabs.insert(newIndex, tabs.removeAt(oldIndex));
    emit(state.copyWith(tabs: tabs, activeIndex: newIndex));
  }

  Future<void> saveActive() async {
    final tab = state.active;
    if (tab != null) await _save(tab);
  }

  Future<void> saveTab(int index) => _save(state.tabs[index]);

  Future<void> saveAll() async {
    for (final tab in state.tabs) {
      await _save(tab);
    }
  }

  Future<void> _save(OpenTab tab) async {
    final component = _project.state.project?.components[tab.componentId];
    if (component == null) return;
    await _project.saveComponent(
      tab.componentId,
      component.copyWith(root: tab.editor.state.root),
    );
    tab.editor.markSaved();
  }

  Future<void> _onProject(ProjectState projectState) async {
    final project = projectState.project;
    if (project == null) return;
    final reconciled = reconcileTabs(state, project);
    for (final tab in state.tabs) {
      if (!reconciled.tabs.contains(tab)) await tab.editor.close();
    }
    emit(reconciled);
    if (reconciled.tabs.isEmpty && project.components.isNotEmpty) {
      openComponent(_firstComponentId(project));
    }
  }

  String _firstComponentId(LoadedProject project) {
    final sorted = project.components.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted.first.id;
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    for (final tab in state.tabs) {
      await tab.editor.close();
    }
    return super.close();
  }
}
