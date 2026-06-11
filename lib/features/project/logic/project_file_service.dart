import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A component file on disk: the [folder] it's in and its raw JSON [contents].
typedef RawComponentFile = ({String folder, String contents});

/// A project read from disk: its [folders] and component [files].
typedef RawProject = ({List<String> folders, List<RawComponentFile> files});

/// The filesystem layer. Owns the on-disk layout — a directory per project,
/// sub-directories for folders, one `.json` per component — and knows nothing
/// about the model. Repositories sit on top and map to and from this.
class ProjectFileService {
  static const _ext = '.json';

  Future<String> _root() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'fludget', 'projects'))
      ..createSync(recursive: true);
    return dir.path;
  }

  Future<String> _projectPath(String name) async => p.join(await _root(), name);

  String _dirPath(String projectPath, String folder) => folder.isEmpty
      ? projectPath
      : p.joinAll([projectPath, ...folder.split('/')]);

  String _toFolder(String osRelative) =>
      osRelative == '.' ? '' : p.split(osRelative).join('/');

  Future<List<String>> listProjectNames() async {
    final root = Directory(await _root());
    return [
      for (final e in root.listSync())
        if (e is Directory) p.basename(e.path),
    ]..sort();
  }

  Future<void> createProject(String name) async =>
      Directory(await _projectPath(name)).create(recursive: true);

  Future<void> renameProject(String oldName, String newName) async => Directory(
    await _projectPath(oldName),
  ).rename(await _projectPath(newName));

  Future<void> deleteProject(String name) async {
    final dir = Directory(await _projectPath(name));
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  Future<RawProject> readProject(String name) async {
    final base = await _projectPath(name);
    final dir = Directory(base);
    final folders = <String>[];
    final files = <RawComponentFile>[];
    if (!dir.existsSync()) return (folders: folders, files: files);
    for (final e in dir.listSync(recursive: true)) {
      final rel = p.relative(e.path, from: base);
      if (e is Directory) {
        folders.add(_toFolder(rel));
      } else if (e is File && p.extension(e.path) == _ext) {
        files.add((
          folder: _toFolder(p.dirname(rel)),
          contents: e.readAsStringSync(),
        ));
      }
    }
    return (folders: folders, files: files);
  }

  Future<void> writeComponent(
    String project,
    String folder,
    String fileName,
    String contents,
  ) async {
    final dir = Directory(_dirPath(await _projectPath(project), folder))
      ..createSync(recursive: true);
    File(p.join(dir.path, fileName)).writeAsStringSync(contents);
  }

  Future<void> deleteComponent(
    String project,
    String folder,
    String fileName,
  ) async {
    final file = File(
      p.join(_dirPath(await _projectPath(project), folder), fileName),
    );
    if (file.existsSync()) file.deleteSync();
  }

  Future<void> createFolder(String project, String path) async => Directory(
    _dirPath(await _projectPath(project), path),
  ).create(recursive: true);

  Future<void> moveFolder(String project, String from, String to) async {
    final base = await _projectPath(project);
    await Directory(_dirPath(base, from)).rename(_dirPath(base, to));
  }

  Future<void> deleteFolder(String project, String path) async {
    final dir = Directory(_dirPath(await _projectPath(project), path));
    if (dir.existsSync()) await dir.delete(recursive: true);
  }
}
