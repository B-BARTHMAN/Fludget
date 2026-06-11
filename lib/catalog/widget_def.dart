import 'package:fludget/catalog/model/widget_node.dart';
import 'package:fludget/catalog/properties/prop.dart';
import 'package:fludget/catalog/slots/slot.dart';
import 'package:fludget/catalog/widgets/category.dart';
import 'package:flutter/widgets.dart';

/// Everything the catalog knows about one widget type: its editable [props],
/// its named child [slots], where it sits in the picker ([category]), and how
/// to turn a node into a live widget ([build]) and into Dart source ([toCode]).
///
/// Adding a widget = writing one of these in its own file and listing it in
/// its category. Defs compose shared `Props`/`Slots`, so most are a few lines.
class WidgetDef {
  WidgetDef({
    required this.type,
    required this.category,
    required this.build,
    this.toCode,
    this.props = const [],
    this.slots = const [],
  });

  /// The widget kind, e.g. `'Container'`. Unique across the registry.
  final String type;

  /// Where this widget appears in the categorized add-widget menu.
  final Category category;

  /// Editable scalar parameters, in display order.
  final List<Prop> props;

  /// Named child parameters, in display order.
  final List<Slot> slots;

  /// Builds the live preview from [node] and its already-built [children],
  /// keyed by slot name and read via `children.one(slot)` / `.many(slot)`.
  final Widget Function(WidgetNode node, Map<String, List<Widget>> children)
  build;

  /// Generates Dart source from [node] and its already-generated child [code].
  final String Function(WidgetNode node, Map<String, List<String>> code)?
  toCode;
}
