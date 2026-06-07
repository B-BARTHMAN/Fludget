import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProjectFileService {
  ProjectFileService({this.folderName = 'projects'});

  final String folderName;

  Future<String> read(String fileName) async =>
      _file(await _projectsDir(), fileName).readAsString();

  Future<void> write(String fileName, String contents) async =>
      _file(await _projectsDir(), fileName).writeAsString(contents);

  Future<void> delete(String fileName) async {
    final file = _file(await _projectsDir(), fileName);
    if (file.existsSync()) await file.delete();
  }

  Future<List<String>> listFileNames() async {
    final dir = await _projectsDir();
    final entries = await dir.list().toList();
    return [
      for (final e in entries)
        if (e is File) e.uri.pathSegments.last,
    ];
  }

  Future<Directory> _projectsDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/fludget/$folderName');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  File _file(Directory dir, String fileName) => File('${dir.path}/$fileName');
}
