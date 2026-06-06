/// Drives which editor widget the property panel shows.
enum PropertyType {
  doubleValue,
  string,
  boolean,
  color,
  edgeInsets,
  alignment,
  enumValue,
  textStyle,
}

/// Static metadata describing one editable property of a widget type.
/// Plain const class — no state, no JSON, so freezed would be overkill.
class PropertySpec {
  const PropertySpec({
    required this.name,
    required this.type,
    this.defaultValue,
    this.options,
  });

  final String name;
  final PropertyType type;
  final Object? defaultValue;
  final List<Object>? options; // only for PropertyType.enumValue
}
