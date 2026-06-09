import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/editor/project/project_state.dart';
import 'package:fludget/project/component.dart';
import 'package:fludget/project/loaded_project.dart';
import 'package:fludget/project/project_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/// Owns the loaded project: the live components (id -> Component, the single
/// source of truth for roots), the folder layout, and persistence + CRUD.
///
/// Every mutation is a filesystem op followed by a reload, so the in-memory
/// index always mirrors disk.
class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit({required ProjectRepository repository})
    : _repository = repository,
      super(const ProjectState());

  final ProjectRepository _repository;
  static const _uuid = Uuid();

  /// Loads the first project on disk, creating a default one if none exists.
  Future<void> bootstrap() async {
    final names = await _repository.listProjects();
    final name = names.isEmpty ? await _createDefaultProject() : names.first;
    final loaded = await _repository.loadProject(name);
    emit(ProjectState(project: loaded));
  }

  /// Persists component [id] with [root] and updates the in-memory copy.
  Future<void> saveComponent(String id, WidgetNode? root) async {
    final loaded = state.project;
    final current = loaded?.components[id];
    if (loaded == null || current == null) return;

    final updated = current.copyWith(root: root);
    final folder = loaded.folderOf[id] ?? '';
    await _repository.saveComponent(loaded.name, updated, folder);

    emit(
      ProjectState(
        project: loaded.copyWith(
          components: {...loaded.components, id: updated},
        ),
      ),
    );
  }

  /// Creates an empty component in [folder] and returns its id.
  Future<String?> createComponent({
    String folder = '',
    String name = 'Untitled',
  }) async {
    final loaded = state.project;
    if (loaded == null) return null;
    final unique = _uniqueComponentName(loaded, folder, name);
    final component = Component(id: _uuid.v4(), name: unique);
    await _repository.saveComponent(loaded.name, component, folder);
    await _reload();
    return component.id;
  }

  Future<void> renameComponent(String id, String newName) async {
    final loaded = state.project;
    final current = loaded?.components[id];
    if (loaded == null || current == null) return;
    final folder = loaded.folderOf[id] ?? '';
    final unique = _uniqueComponentName(loaded, folder, newName, excludeId: id);
    if (unique == current.name) return;
    // write the new file, then drop the old one
    await _repository.saveComponent(
      loaded.name,
      current.copyWith(name: unique),
      folder,
    );
    if (unique.toLowerCase() != current.name.toLowerCase()) {
      await _repository.deleteComponent(loaded.name, folder, current.name);
    }
    await _reload();
  }

  Future<void> moveComponent(String id, String toFolder) async {
    final loaded = state.project;
    final current = loaded?.components[id];
    if (loaded == null || current == null) return;
    final fromFolder = loaded.folderOf[id] ?? '';
    if (fromFolder == toFolder) return;
    final unique = _uniqueComponentName(
      loaded,
      toFolder,
      current.name,
      excludeId: id,
    );
    await _repository.saveComponent(
      loaded.name,
      current.copyWith(name: unique),
      toFolder,
    );
    if (unique.toLowerCase() != current.name.toLowerCase()) {
      await _repository.deleteComponent(loaded.name, toFolder, current.name);
    }
    await _reload();
  }

  Future<void> deleteComponent(String id) async {
    final loaded = state.project;
    final current = loaded?.components[id];
    if (loaded == null || current == null) return;
    final folder = loaded.folderOf[id] ?? '';
    await _repository.deleteComponent(loaded.name, folder, current.name);
    await _reload();
  }

  Future<void> createFolder({required String name, String parent = ''}) async {
    final loaded = state.project;
    if (loaded == null) return;
    final unique = _uniqueFolderName(loaded, parent, name);
    final path = parent.isEmpty ? unique : '$parent/$unique';
    await _repository.createFolder(loaded.name, path);
    await _reload();
  }

  Future<void> renameFolder(String path, String newName) async {
    final loaded = state.project;
    if (loaded == null || path.isEmpty) return;
    final parent = _parentOf(path);
    final unique = _uniqueFolderName(loaded, parent, newName);
    final newPath = parent.isEmpty ? unique : '$parent/$unique';
    if (newPath == path) return;
    await _repository.moveFolder(loaded.name, path, newPath);
    await _reload();
  }

  Future<void> moveFolder(String path, String toParent) async {
    final loaded = state.project;
    if (loaded == null || path.isEmpty) return;
    if (toParent == path || toParent.startsWith('$path/')) return;
    final segment = path.split('/').last;
    final unique = _uniqueFolderName(loaded, toParent, segment);
    final newPath = toParent.isEmpty ? unique : '$toParent/$unique';
    if (newPath == path) return;
    await _repository.moveFolder(loaded.name, path, newPath);
    await _reload();
  }

  Future<void> deleteFolder(String path) async {
    final loaded = state.project;
    if (loaded == null || path.isEmpty) return;
    await _repository.deleteFolder(loaded.name, path);
    await _reload();
  }

  Future<void> _reload() async {
    final name = state.project?.name;
    if (name == null) return;
    emit(ProjectState(project: await _repository.loadProject(name)));
  }

  Future<String> _createDefaultProject() async {
    const name = 'Untitled Project';
    await _repository.createProject(name);
    await _repository.saveComponent(name, _defaultComponent(), '');
    return name;
  }

  Component _defaultComponent() => Component(id: _uuid.v4(), name: 'Untitled');

  String _uniqueComponentName(
    LoadedProject loaded,
    String folder,
    String base, {
    String? excludeId,
  }) {
    final taken = <String>{};
    for (final entry in loaded.folderOf.entries) {
      if (entry.value != folder || entry.key == excludeId) continue;
      final name = loaded.components[entry.key]?.name;
      if (name != null) taken.add(name);
    }
    return _disambiguate(base, taken);
  }

  String _uniqueFolderName(LoadedProject loaded, String parent, String base) {
    final taken = <String>{
      for (final f in loaded.folders)
        if (_parentOf(f) == parent) f.split('/').last,
    };
    return _disambiguate(base, taken);
  }

  String _disambiguate(String base, Set<String> taken) {
    if (!taken.contains(base)) return base;
    var i = 2;
    while (taken.contains('$base $i')) {
      i++;
    }
    return '$base $i';
  }

  String _parentOf(String path) {
    final i = path.lastIndexOf('/');
    return i == -1 ? '' : path.substring(0, i);
  }
}
