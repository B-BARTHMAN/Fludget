import 'package:flutter/material.dart';

/// The app's light and dark themes — a single seed color, Material 3.
abstract final class AppTheme {
  static const _seed = Color.fromARGB(255, 115, 7, 108);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
    visualDensity: VisualDensity.compact,
  );
}
