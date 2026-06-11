import 'package:fludget/core/util/path.dart';
import 'package:fludget/features/project/logic/component.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';

/// A folder in the project explorer: its sub-folders and the components
/// directly inside it. Derived purely from a [LoadedProject].
class ExplorerFolder {
  const ExplorerFolder({
    required this.path,
    required this.name,
    this.folders = const [],
    this.components = const [],
  });

  /// `''` for the root, else e.g. `Buttons` / `Buttons/Outlined`.
  final String path;

  /// Display name — the last path segment, or the project name at the root.
  final String name;

  final List<ExplorerFolder> folders;
  final List<Component> components;
}

/// Builds the explorer tree for [project], sorted by name, filling in any
/// folder implied by a path but not listed on its own.
ExplorerFolder buildExplorerTree(LoadedProject project) {
  final allFolders = <String>{''};
  for (final folder in project.folders) {
    allFolders.addAll(ancestorsOf(folder));
  }
  for (final folder in project.folderOf.values) {
    allFolders.addAll(ancestorsOf(folder));
  }

  ExplorerFolder build(String path) {
    final childPaths =
        allFolders.where((f) => f.isNotEmpty && parentOf(f) == path).toList()
          ..sort(
            (a, b) => lastSegment(
              a,
            ).toLowerCase().compareTo(lastSegment(b).toLowerCase()),
          );
    final components = project.componentsIn(path).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return ExplorerFolder(
      path: path,
      name: path.isEmpty ? project.name : lastSegment(path),
      folders: [for (final child in childPaths) build(child)],
      components: components,
    );
  }

  return build('');
}
