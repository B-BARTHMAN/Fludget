/// A single node in a widget tree: a widget [type] together with its
/// configured [props] (scalar values) and [slots] (named child widgets).
///
/// Pure, immutable, JSON-safe data with no Flutter or app dependencies. The
/// node knows nothing about how it is built, rendered, or generated — the
/// catalog engine interprets it against a definition.
class WidgetNode {
  const WidgetNode({
    required this.id,
    required this.type,
    this.props = const {},
    this.slots = const {},
  });

  factory WidgetNode.fromJson(Map<String, dynamic> json) {
    return WidgetNode(
      id: json['id'] as String,
      type: json['type'] as String,
      props: Map<String, Object?>.from(json['props'] as Map? ?? const {}),
      slots: {
        for (final entry in (json['slots'] as Map? ?? const {}).entries)
          entry.key as String: [
            for (final child in entry.value as List)
              WidgetNode.fromJson(child as Map<String, dynamic>),
          ],
      },
    );
  }

  /// Stable identity. Never changes once assigned, so it survives edits.
  final String id;

  /// The widget kind, e.g. `'Container'`. Resolved against the built-in
  /// registry or, for composition, the project's components.
  final String type;

  /// Scalar parameters, keyed by prop name. Values are JSON primitives.
  final Map<String, dynamic> props;

  /// Child widgets, keyed by slot name. Single-child slots simply hold a
  /// list of length <= 1; arity is owned by the slot definition, not here.
  final Map<String, List<WidgetNode>> slots;

  WidgetNode copyWith({
    String? type,
    Map<String, dynamic>? props,
    Map<String, List<WidgetNode>>? slots,
  }) => WidgetNode(
    id: id,
    type: type ?? this.type,
    props: props ?? this.props,
    slots: slots ?? this.slots,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      if (props.isNotEmpty) 'props': props,
      if (slots.isNotEmpty)
        'slots': {
          for (final entry in slots.entries)
            entry.key: [for (final child in entry.value) child.toJson()],
        },
    };
  }
}
