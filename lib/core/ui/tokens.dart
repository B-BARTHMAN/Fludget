/// Named dimensions used across the editor UI, so widgets read intent instead
/// of bare numbers. Grouped by what they describe.
library;

abstract final class Insets {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}

abstract final class Sizes {
  /// Height of a row in the widget tree and the files explorer.
  static const treeRow = 36.0;

  /// Height of the workspace tab bar.
  static const tabBar = 44.0;

  /// Horizontal indent added per level of tree depth.
  static const indentUnit = 16.0;

  /// Tab width bounds.
  static const tabMinWidth = 96.0;
  static const tabMaxWidth = 200.0;

  /// Resizable left-panel bounds.
  static const panelMin = 220.0;
  static const panelDefault = 300.0;
  static const panelMax = 480.0;

  /// Selection outline thickness on the canvas.
  static const selectionBorder = 2.0;
}

/// The phone-shaped preview frame on the canvas.
abstract final class DeviceFrame {
  static const width = 360.0;
  static const height = 640.0;
  static const radius = 12.0;
}
