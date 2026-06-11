import 'package:fludget/features/project/logic/component.dart';
import 'package:flutter/material.dart';

/// A project loaded into memory — the source of truth for what exists while
/// editing. The repository builds it from disk; `ProjectCubit` holds it.
@immutable
class LoadedProject {
  const LoadedProject({
    required this.name,
    required this.components,
    required this.folderOf,
    required this.folders,
  });

  final String name;

  /// Every component, by id.
  final Map<String, Component> components;

  /// The folder each component lives in, by component id (`''` = root).
  final Map<String, String> folderOf;

  /// Every (non-root) folder path in the project, e.g. `Buttons/Outlined`.
  final Set<String> folders;

  /// The components directly inside [folder], unordered.
  Iterable<Component> componentsIn(String folder) =>
      components.values.where((c) => folderOf[c.id] == folder);
}
