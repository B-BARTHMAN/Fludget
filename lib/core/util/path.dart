/// Pure helpers for the `/`-separated folder paths used across a project.
/// `''` is the project root; otherwise e.g. `Buttons` or `Buttons/Outlined`.
library;

/// The parent of [path], or `''` (the root) when [path] is top-level.
String parentOf(String path) {
  final i = path.lastIndexOf('/');
  return i == -1 ? '' : path.substring(0, i);
}

/// The last segment of [path] — its display name.
String lastSegment(String path) {
  final i = path.lastIndexOf('/');
  return i == -1 ? path : path.substring(i + 1);
}

/// Joins [parent] and [name] into a path, handling the root (`''`) cleanly.
String joinPath(String parent, String name) =>
    parent.isEmpty ? name : '$parent/$name';

/// Every ancestor path of [path], top segment down to [path] itself:
/// `'a/b/c'` -> `['a', 'a/b', 'a/b/c']`. Empty for the root.
List<String> ancestorsOf(String path) {
  if (path.isEmpty) return const [];
  final parts = path.split('/');
  return [
    for (var i = 1; i <= parts.length; i++) parts.sublist(0, i).join('/'),
  ];
}
