import 'package:flutter/material.dart';

/// Translates one property between its three forms: the stored JSON value, the
/// typed value used to build a live preview, and the Dart source used for code
/// export. A codec is pure type vocabulary — it carries no name and no default
/// (those live on [Prop]), so a single instance can be shared across every
/// prop of the same type.
abstract interface class PropCodec<T> {
  const PropCodec();

  /// Stored JSON -> typed value, or null when absent or unparseable.
  /// [Prop] supplies the fallback, so a codec needs no default of its own.
  T? decode(Object? json);

  /// Stored JSON -> Dart source for export, e.g. `'16.0'` or `'Colors.red'`.
  String toCode(Object? json);

  /// An editor for the current [value], reporting each edit as a new JSON
  /// value via [onChanged].
  Widget editor(Object? value, ValueChanged<Object?> onChanged);
}
