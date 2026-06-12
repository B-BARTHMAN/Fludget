/// Turns a free-form name into a Dart class identifier: `'My button'` ->
/// `'MyButton'`. Used for generated component class names.
library;

String pascalCase(String name) {
  final words = name.split(RegExp('[^A-Za-z0-9]+')).where((w) => w.isNotEmpty);
  final joined = words
      .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
      .join();
  return joined.isEmpty ? 'Component' : joined;
}
