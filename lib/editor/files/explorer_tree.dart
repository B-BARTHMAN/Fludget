import 'package:fludget/project/component.dart';
import 'package:fludget/project/loaded_project.dart';

/// A folder in the project explorer: its sub-folders and the components that
/// live directly inside it. Derived purely from a [LoadedProject].
class ExplorerFolder {
  const ExplorerFolder({
    required this.path,
    required this.name,
    this.folders = const [],
    this.components = const [],
  });

  /// `''` for the project root, else e.g. `Buttons` / `Buttons/Outlined`.
  final String path;

  /// Display name — the last path segment (the project name for the root).
  final String name;

  final List<ExplorerFolder> folders;
  final List<Component> components;
}

/// Builds the explorer tree for [project], sorting by name and filling in any
/// folders implied by a path but not listed directly.
ExplorerFolder buildExplorerTree(LoadedProject project) {
  final allFolders = <String>{''};
  for (final folder in project.folders) {
    _addWithAncestors(allFolders, folder);
  }
  for (final folder in project.folderOf.values) {
    _addWithAncestors(allFolders, folder);
  }

  final componentsByFolder = <String, List<Component>>{};
  for (final entry in project.folderOf.entries) {
    final component = project.components[entry.key];
    if (component != null) {
      (componentsByFolder[entry.value] ??= []).add(component);
    }
  }

  ExplorerFolder build(String path) {
    final childPaths =
        allFolders.where((f) => f.isNotEmpty && _parentOf(f) == path).toList()
          ..sort(_bySegment);
    final components = (componentsByFolder[path] ?? <Component>[])
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return ExplorerFolder(
      path: path,
      name: path.isEmpty ? project.name : path.split('/').last,
      folders: [for (final child in childPaths) build(child)],
      components: components,
    );
  }

  return build('');
}

void _addWithAncestors(Set<String> into, String path) {
  if (path.isEmpty) return;
  final parts = path.split('/');
  for (var i = 1; i <= parts.length; i++) {
    into.add(parts.sublist(0, i).join('/'));
  }
}

int _bySegment(String a, String b) =>
    a.split('/').last.toLowerCase().compareTo(b.split('/').last.toLowerCase());

String _parentOf(String path) {
  final i = path.lastIndexOf('/');
  return i == -1 ? '' : path.substring(0, i);
}
