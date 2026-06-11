import 'package:fludget/catalog/widget_def.dart';

/// Resolves a widget [type] to its definition. The engine depends on this seam
/// rather than a global registry map, so widget composition can later add a
/// second source — the project's own components — behind the same interface,
/// without the engine changing.
abstract interface class WidgetSource {
  /// The definition for [type], or null if this source doesn't know it.
  WidgetDef? defFor(String type);
}
