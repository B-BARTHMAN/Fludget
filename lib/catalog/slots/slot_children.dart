import 'package:fludget/catalog/slots/slot.dart';

/// Reads resolved slot children by [Slot] rather than by raw string. `T` is
/// `Widget` inside a def's `build` and `String` inside its `toCode`, so one
/// extension serves both. The slot's name is dereferenced in exactly one
/// place — here — so a widget def never writes a slot-name literal.
extension SlotChildren<T> on Map<String, List<T>> {
  /// The single child of [slot], or null. Use for [SlotArity.single].
  T? one(Slot slot) {
    final list = this[slot.name];
    return (list == null || list.isEmpty) ? null : list.first;
  }

  /// All children of [slot], or empty. Use for [SlotArity.multi].
  List<T> many(Slot slot) => this[slot.name] ?? const [];
}
