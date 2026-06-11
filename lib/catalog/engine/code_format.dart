/// Pure formatting for generated Dart: turns a constructor name, its argument
/// map, and child lists into 2-space-indented source.
///
/// Correct nesting comes from one rule: every value is produced at column 0,
/// and whoever embeds it shifts its continuation lines right by one level. So
/// indentation composes automatically no matter how deep the tree goes.
library;

/// `Name(arg: value, ...)` over multiple lines, or `Name()` when empty.
String emitConstructor(String name, Map<String, String> args) {
  if (args.isEmpty) return '$name()';
  final buffer = StringBuffer('$name(\n');
  for (final entry in args.entries) {
    buffer.write('  ${entry.key}: ${_nest(entry.value)},\n');
  }
  buffer.write(')');
  return buffer.toString();
}

/// `[item, ...]` over multiple lines, or `[]` when empty.
String emitList(List<String> items) {
  if (items.isEmpty) return '[]';
  final buffer = StringBuffer('[\n');
  for (final item in items) {
    buffer.write('  ${_nest(item)},\n');
  }
  buffer.write(']');
  return buffer.toString();
}

/// Shifts every line of [code] after the first right by one 2-space level, so
/// a multi-line value stays nested under the line that introduces it.
String _nest(String code) => code.replaceAll('\n', '\n  ');
