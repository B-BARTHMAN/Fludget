import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/editor/document/document_cubit.dart';
import 'package:fludget/editor/workspace/workspace_state.dart';
import 'package:fludget/project/project.dart';
import 'package:fludget/project/project_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit({required ProjectRepository repository})
    : _repository = repository,
      super(const WorkspaceState());

  final ProjectRepository _repository;
  static final _uuid = Uuid();

  void newDocument({String name = 'Untitled'}) {
    final tab = (name: _uniqueName(name), cubit: DocumentCubit(_defaultRoot()));
    emit(
      state.copyWith(
        tabs: [...state.tabs, tab],
        activeIndex: state.tabs.length,
      ),
    );
  }

  Future<void> openProject(String name) async {
    final existing = state.tabs.indexWhere((t) => t.name == name);
    if (existing != -1) {
      emit(state.copyWith(activeIndex: existing));
      return;
    }
    final project = await _repository.load(name);
    final tab = (name: project.name, cubit: DocumentCubit(project.root));
    emit(
      state.copyWith(
        tabs: [...state.tabs, tab],
        activeIndex: state.tabs.length,
      ),
    );
  }

  Future<void> saveActive() async {
    final tab = state.activeTab;
    if (tab == null) return;
    await _repository.save(Project(name: tab.name, root: tab.cubit.state.root));
  }

  void switchTo(int index) {
    if (index < 0 || index >= state.tabs.length) return;
    emit(state.copyWith(activeIndex: index));
  }

  void closeTab(int index) {
    if (index < 0 || index >= state.tabs.length) return;
    final closing = state.tabs[index];
    final tabs = [...state.tabs]..removeAt(index);

    var active = state.activeIndex;
    if (index < active || active >= tabs.length) {
      active = active > 0 ? active - 1 : 0;
    }

    emit(state.copyWith(tabs: tabs, activeIndex: active));
    closing.cubit.close();
  }

  @override
  Future<void> close() {
    for (final tab in state.tabs) {
      tab.cubit.close();
    }
    return super.close();
  }

  String _uniqueName(String base) {
    final taken = state.tabs.map((t) => t.name).toSet();
    if (!taken.contains(base)) return base;
    var i = 2;
    while (taken.contains('$base $i')) {
      i++;
    }
    return '$base $i';
  }

  WidgetNode _defaultRoot() => WidgetNode(id: _uuid.v4(), type: 'Column');
}
