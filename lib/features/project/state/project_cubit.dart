import 'package:fludget/core/util/path.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';
import 'package:fludget/features/project/logic/naming.dart';
import 'package:fludget/features/project/logic/project_repository.dart';
import 'package:fludget/features/project/state/project_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/// Owns the loaded project. Every mutation has the same shape: ask the
/// repository to do it, then reload and emit. Naming uses the pure helpers,
/// the repository owns the disk choreography — so this stays thin.
class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this._repo) : super(const ProjectState());

  final ProjectRepository _repo;
  static const _uuid = Uuid();

  LoadedProject get _project => state.project!;
  String get _name => _project.name;

  Future<void> bootstrap() async {
    final names = await _repo.listProjects();
    names.isEmpty
        ? await createNewProject('Untitled Project')
        : await openProject(names.first);
  }

  Future<void> openProject(String name) => _loadAndEmit(name);

  Future<void> createNewProject(String name) async {
    await _repo.createProject(name);
    await _repo.saveComponent(
      name,
      Component(id: _uuid.v4(), name: 'Untitled'),
      '',
    );
    await _loadAndEmit(name);
  }

  Future<void> renameProject(String name) async {
    await _repo.renameProject(_name, name);
    await _loadAndEmit(name);
  }

  Future<void> deleteProject(String name) async {
    await _repo.deleteProject(name);
    final names = await _repo.listProjects();
    names.isEmpty
        ? await createNewProject('Untitled Project')
        : await openProject(names.first);
  }

  Future<String> createComponent({
    required String folder,
    required String name,
  }) async {
    final component = Component(
      id: _uuid.v4(),
      name: uniqueComponentName(_project, folder, name),
    );
    await _repo.saveComponent(_name, component, folder);
    await _reload();
    return component.id;
  }

  Future<void> saveComponent(String id, Component component) async {
    await _repo.saveComponent(_name, component, _project.folderOf[id] ?? '');
    await _reload();
  }

  Future<void> renameComponent(String id, String name) async {
    final component = _project.components[id];
    if (component == null) return;
    final folder = _project.folderOf[id] ?? '';
    final unique = uniqueComponentName(
      _project,
      folder,
      name,
      //except: component.name,
    );
    await _repo.renameComponent(
      _name,
      folder,
      component.name,
      component.copyWith(name: unique),
    );
    await _reload();
  }

  Future<void> moveComponent(String id, String toFolder) async {
    final component = _project.components[id];
    if (component == null) return;
    await _repo.moveComponent(
      _name,
      component,
      _project.folderOf[id] ?? '',
      toFolder,
    );
    await _reload();
  }

  Future<void> deleteComponent(String id) async {
    final component = _project.components[id];
    if (component == null) return;
    await _repo.deleteComponent(
      _name,
      _project.folderOf[id] ?? '',
      component.name,
    );
    await _reload();
  }

  Future<void> createFolder({
    required String parent,
    required String name,
  }) async {
    await _repo.createFolder(
      _name,
      joinPath(parent, uniqueFolderName(_project, parent, name)),
    );
    await _reload();
  }

  Future<void> renameFolder(String path, String name) async {
    final unique = uniqueFolderName(
      _project,
      parentOf(path),
      name,
      //except: lastSegment(path),
    );
    await _repo.moveFolder(_name, path, joinPath(parentOf(path), unique));
    await _reload();
  }

  Future<void> moveFolder(String path, String dest) async {
    await _repo.moveFolder(_name, path, joinPath(dest, lastSegment(path)));
    await _reload();
  }

  Future<void> deleteFolder(String path) async {
    await _repo.deleteFolder(_name, path);
    await _reload();
  }

  Future<List<String>> availableProjects() => _repo.listProjects();

  Future<void> _loadAndEmit(String name) async =>
      emit(ProjectState(project: await _repo.loadProject(name)));

  Future<void> _reload() => _loadAndEmit(_name);
}
