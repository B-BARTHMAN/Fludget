import 'package:fludget/catalog/slots/slot.dart';

/// Shared slots that recur across many widgets. Declared once here and reused
/// in defs, so common slot names live in a single place. Slots unique to one
/// widget (e.g. Scaffold's `appBar` / `body`) belong in that widget's def file.
abstract final class Slots {
  /// A single optional child — `Container`, `Center`, `Padding`, `SizedBox`…
  static const child = Slot('child');

  /// A list of children — `Column`, `Row`, `Stack`, `ListView`…
  static const children = Slot('children', arity: SlotArity.multi);
}
