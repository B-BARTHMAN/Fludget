import 'package:fludget/features/project/logic/loaded_project.dart';
import 'package:flutter/material.dart';

/// What the UI sees about the current project. [project] is null before the
/// first load completes.
@immutable
class ProjectState {
  const ProjectState({this.project});

  final LoadedProject? project;

  ProjectState copyWith({LoadedProject? project}) =>
      ProjectState(project: project ?? this.project);
}
