import 'dart:convert';

import 'package:fludget/catalog/normalizer.dart';
import 'package:fludget/project/component.dart';
import 'package:fludget/project/loaded_project.dart';
import 'package:fludget/project/project_file_service.dart';

/// Maps between the on-disk directory layout and [LoadedProject], normalizing
/// component roots against the registry on the way in and out.
class ProjectRepository {
  ProjectRepository({required ProjectFileService fileService})
    : _fileService = fileService;

  final ProjectFileService _fileService;

  static const _extension = '.json';

  Future<List<String>> listProjects() => _fileService.listProjectNames();

  Future<void> createProject(String name) => _fileService.createProject(name);

  Future<LoadedProject> loadProject(String name) async {
    final raw = await _fileService.readProject(name);

    final components = <String, Component>{};
    final folderOf = <String, String>{};
    for (final file in raw.files) {
      final json = jsonDecode(file.contents) as Map<String, dynamic>;
      final component = Component.fromJson(json);
      final clean = component.copyWith(root: normalizeNode(component.root));
      components[clean.id] = clean;
      folderOf[clean.id] = file.folder;
    }

    return LoadedProject(
      name: name,
      components: components,
      folderOf: folderOf,
      folders: raw.folders.toSet(),
    );
  }

  Future<void> saveComponent(
    String projectName,
    Component component,
    String folder,
  ) async {
    final clean = component.copyWith(root: normalizeNode(component.root));
    await _fileService.writeComponent(
      projectName,
      folder,
      '${component.name}$_extension',
      jsonEncode(clean.toJson()),
    );
  }

  Future<void> deleteComponent(
    String projectName,
    String folder,
    String name,
  ) => _fileService.deleteComponent(projectName, folder, '$name$_extension');

  Future<void> createFolder(String projectName, String path) =>
      _fileService.createFolder(projectName, path);

  Future<void> moveFolder(String projectName, String fromPath, String toPath) =>
      _fileService.moveFolder(projectName, fromPath, toPath);

  Future<void> deleteFolder(String projectName, String path) =>
      _fileService.deleteFolder(projectName, path);
}
