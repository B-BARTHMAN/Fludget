import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/project/component.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'loaded_project.freezed.dart';

/// An in-memory snapshot of a project loaded from disk. The directory tree is
/// the source of truth for organization; this just indexes it for lookup.
///
/// References resolve through [components] by id, so they're independent of
/// where a component's file lives.
@freezed
abstract class LoadedProject with _$LoadedProject {
  const factory LoadedProject({
    required String name,
    @Default(<String, Component>{}) Map<String, Component> components,
    @Default(<String, String>{}) Map<String, String> folderOf,
    @Default(<String>{}) Set<String> folders,
  }) = _LoadedProject;
  const LoadedProject._();

  /// The component with [id], or null if there's no such component.
  Component? component(String id) => components[id];

  /// The current root of component [id] — the basis for reference resolution.
  WidgetNode? rootOf(String id) => components[id]?.root;

  /// The first component in load order, or null if the project is empty.
  String? get firstComponentId =>
      components.isEmpty ? null : components.keys.first;
}
