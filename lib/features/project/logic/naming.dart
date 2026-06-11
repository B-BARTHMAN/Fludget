import 'package:fludget/core/util/path.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';

/// Pure helpers that turn a desired name into a free one — extracted from
/// ProjectCubit so they're testable and the cubit stays thin.

/// [base] if free, else `'$base 2'`, `'$base 3'`, … until not in [taken].
String disambiguate(String base, Set<String> taken) {
  if (!taken.contains(base)) return base;
  for (var n = 2; ; n++) {
    final candidate = '$base $n';
    if (!taken.contains(candidate)) return candidate;
  }
}

/// A component name unique among the components already in [folder].
String uniqueComponentName(LoadedProject project, String folder, String base) =>
    disambiguate(base, {for (final c in project.componentsIn(folder)) c.name});

/// A folder name unique among the sub-folders directly under [parent].
String uniqueFolderName(LoadedProject project, String parent, String base) {
  final siblings = {
    for (final f in project.folders)
      if (parentOf(f) == parent) lastSegment(f),
  };
  return disambiguate(base, siblings);
}
