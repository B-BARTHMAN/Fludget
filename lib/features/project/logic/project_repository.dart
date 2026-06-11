import 'dart:convert';

import 'package:fludget/catalog/engine/normalizer.dart';
import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';
import 'package:fludget/features/project/logic/project_file_service.dart';

/// Maps the on-disk layout to and from the model and owns every project
/// mutation, normalizing component roots against the catalog as they cross the
/// boundary. The cubit calls these intent methods and reloads — no JSON or
/// file-name handling leaks upward.
class ProjectRepository {
  ProjectRepository({
    required ProjectFileService files,
    required WidgetSource source,
  }) : _files = files,
       _source = source;

  final ProjectFileService _files;
  final WidgetSource _source;

  static const _ext = '.json';
  String _file(String name) => '$name$_ext';

  // Projects.
  Future<List<String>> listProjects() => _files.listProjectNames();
  Future<void> createProject(String name) => _files.createProject(name);
  Future<void> renameProject(String from, String to) =>
      _files.renameProject(from, to);
  Future<void> deleteProject(String name) => _files.deleteProject(name);

  Future<LoadedProject> loadProject(String name) async {
    final raw = await _files.readProject(name);
    final components = <String, Component>{};
    final folderOf = <String, String>{};
    for (final file in raw.files) {
      final component = Component.fromJson(
        jsonDecode(file.contents) as Map<String, dynamic>,
      );
      final normalized = _normalize(component);
      components[normalized.id] = normalized;
      folderOf[normalized.id] = file.folder;
    }
    return LoadedProject(
      name: name,
      components: components,
      folderOf: folderOf,
      folders: raw.folders.toSet(),
    );
  }

  // Components — each owns its write/delete choreography.
  Future<void> saveComponent(
    String project,
    Component component,
    String folder,
  ) => _files.writeComponent(
    project,
    folder,
    _file(component.name),
    _encode(component),
  );

  Future<void> renameComponent(
    String project,
    String folder,
    String oldName,
    Component renamed,
  ) async {
    await _files.writeComponent(
      project,
      folder,
      _file(renamed.name),
      _encode(renamed),
    );
    if (renamed.name != oldName) {
      await _files.deleteComponent(project, folder, _file(oldName));
    }
  }

  Future<void> moveComponent(
    String project,
    Component component,
    String from,
    String to,
  ) async {
    await _files.writeComponent(
      project,
      to,
      _file(component.name),
      _encode(component),
    );
    if (from != to) {
      await _files.deleteComponent(project, from, _file(component.name));
    }
  }

  Future<void> deleteComponent(String project, String folder, String name) =>
      _files.deleteComponent(project, folder, _file(name));

  // Folders.
  Future<void> createFolder(String project, String path) =>
      _files.createFolder(project, path);
  Future<void> moveFolder(String project, String from, String to) =>
      _files.moveFolder(project, from, to);
  Future<void> deleteFolder(String project, String path) =>
      _files.deleteFolder(project, path);

  Component _normalize(Component c) =>
      c.root == null ? c : c.copyWith(root: normalizeNode(c.root!, _source));

  String _encode(Component c) => jsonEncode(_normalize(c).toJson());
}
