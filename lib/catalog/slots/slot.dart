import 'package:fludget/catalog/model/widget_node.dart';

/// Whether a slot holds at most one child or a list of them.
enum SlotArity { single, multi }

/// A named child parameter of a widget — the peer of `Prop`. A `Column` has a
/// `children` slot (multi); a `Scaffold` has `appBar`, `body`, and more (each
/// single). Declared once as a constant and referenced by object, so the slot
/// name lives in exactly one place.
class Slot {
  const Slot(
    this.name, {
    this.arity = SlotArity.single,
    this.label,
    this.required = false,
  });

  final String name;
  final SlotArity arity;

  /// Shown in the widget tree; falls back to [name] when null.
  final String? label;

  /// Whether the widget is incomplete without a child here — advisory, for
  /// surfacing empty required slots in the UI. Not enforced.
  final bool required;

  /// The child nodes in this slot of [node], empty when unset. Works for both
  /// arities; a single slot simply holds 0 or 1.
  List<WidgetNode> children(WidgetNode node) => node.slots[name] ?? const [];

  /// The sole child of a single slot, or null.
  WidgetNode? child(WidgetNode node) {
    final list = children(node);
    return list.isEmpty ? null : list.first;
  }

  /// Whether another child may be added here: always for [SlotArity.multi],
  /// only when empty for [SlotArity.single]. The editor consults this before
  /// adding a child.
  bool hasRoom(WidgetNode node) =>
      arity == SlotArity.multi || children(node).isEmpty;
}
