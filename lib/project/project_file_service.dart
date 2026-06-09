import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A raw component file read from disk, before JSON parsing.
typedef RawComponentFile = ({String folder, String name, String contents});

/// The raw contents of a project directory: its folders (including empty ones)
/// and its component files.
typedef RawProject = ({List<String> folders, List<RawComponentFile> files});

/// Low-level filesystem IO for projects. A project is a directory; folders are
/// subdirectories; components are `<name>.json` files. Deals in paths and
/// strings — it knows nothing about the component model or JSON.
class ProjectFileService {
  ProjectFileService({this.rootFolderName = 'projects'});

  final String rootFolderName;

  static const _extension = '.json';

  Future<List<String>> listProjectNames() async {
    final root = await _root();
    final entries = await root.list().toList();
    return [
      for (final e in entries)
        if (e is Directory) p.basename(e.path),
    ];
  }

  Future<void> createProject(String name) async {
    final dir = Directory(await _dirPath(name, ''));
    if (!dir.existsSync()) await dir.create(recursive: true);
  }

  Future<RawProject> readProject(String name) async {
    final dir = Directory(await _dirPath(name, ''));
    final folders = <String>[];
    final files = <RawComponentFile>[];
    if (!dir.existsSync()) return (folders: folders, files: files);

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      final relative = p.relative(entity.path, from: dir.path);
      if (entity is Directory) {
        folders.add(_normalize(relative));
      } else if (entity is File && p.extension(entity.path) == _extension) {
        files.add((
          folder: _folderOf(relative),
          name: p.basenameWithoutExtension(entity.path),
          contents: await entity.readAsString(),
        ));
      }
    }
    return (folders: folders, files: files);
  }

  Future<void> writeComponent(
    String projectName,
    String folder,
    String fileName,
    String contents,
  ) async {
    final dir = Directory(await _dirPath(projectName, folder));
    if (!dir.existsSync()) await dir.create(recursive: true);
    final target = File(p.join(dir.path, fileName));
    final tmp = File('${target.path}.tmp');
    await tmp.writeAsString(contents, flush: true);
    await tmp.rename(
      target.path,
    );
  }

  Future<void> deleteComponent(
    String projectName,
    String folder,
    String fileName,
  ) async {
    final file = File(p.join(await _dirPath(projectName, folder), fileName));
    if (file.existsSync()) await file.delete();
  }

  Future<void> createFolder(String projectName, String path) async {
    final dir = Directory(await _dirPath(projectName, path));
    if (!dir.existsSync()) await dir.create(recursive: true);
  }

  Future<void> moveFolder(
    String projectName,
    String fromPath,
    String toPath,
  ) async {
    final from = Directory(await _dirPath(projectName, fromPath));
    if (!from.existsSync()) return;
    final toFull = await _dirPath(projectName, toPath);
    final parent = Directory(p.dirname(toFull));
    if (!parent.existsSync()) await parent.create(recursive: true);
    await from.rename(toFull);
  }

  Future<void> deleteFolder(String projectName, String path) async {
    final dir = Directory(await _dirPath(projectName, path));
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  Future<Directory> _root() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'fludget', rootFolderName));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  /// Absolute path to a folder inside a project (`folder` is `''` for the
  /// project root).
  Future<String> _dirPath(String projectName, String folder) async =>
      p.joinAll([
        (await _root()).path,
        projectName,
        if (folder.isNotEmpty) ...folder.split('/'),
      ]);

  Future<void> renameProject(String oldName, String newName) async {
    final from = Directory(await _dirPath(oldName, ''));
    if (!from.existsSync()) return;
    await from.rename(await _dirPath(newName, ''));
  }

  /// A relative path in `/`-separated form, so folder keys match in memory
  /// regardless of the host platform's separator.
  String _normalize(String relative) => p.split(relative).join('/');

  /// The containing folder of a relative file path, `''` for the project root.
  String _folderOf(String relative) {
    final dir = p.dirname(relative);
    return dir == '.' ? '' : _normalize(dir);
  }
}
