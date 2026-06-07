import 'dart:convert';

import 'package:fludget/catalog/normalizer.dart';
import 'package:fludget/project/project.dart';
import 'package:fludget/project/project_file_service.dart';

class ProjectRepository {
  ProjectRepository({required ProjectFileService fileService})
    : _fileService = fileService;

  final ProjectFileService _fileService;

  static const _extension = '.json';

  Future<List<String>> listProjectNames() async {
    final names = await _fileService.listFileNames();
    return [
      for (final n in names)
        if (n.endsWith(_extension))
          n.substring(0, n.length - _extension.length),
    ];
  }

  Future<Project> load(String projectName) async {
    final raw = await _fileService.read(_fileName(projectName));
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final project = Project.fromJson(json);
    return project.copyWith(root: normalizeNode(project.root));
  }

  Future<void> save(Project project) async {
    final clean = project.copyWith(root: normalizeNode(project.root));
    await _fileService.write(
      _fileName(project.name),
      jsonEncode(clean.toJson()),
    );
  }

  Future<void> delete(String projectName) =>
      _fileService.delete(_fileName(projectName));

  String _fileName(String projectName) => '$projectName$_extension';
}
