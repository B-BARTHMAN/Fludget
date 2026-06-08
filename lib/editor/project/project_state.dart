import 'package:fludget/project/loaded_project.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_state.freezed.dart';

@freezed
abstract class ProjectState with _$ProjectState {
  const factory ProjectState({LoadedProject? project}) = _ProjectState;
  const ProjectState._();

  /// True until the project has finished loading from disk.
  bool get isLoading => project == null;
}
