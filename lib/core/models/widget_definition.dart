import 'package:fludget/core/models/child_rule.dart';
import 'package:fludget/core/models/property_spec.dart';

/// One supported widget type — the registry unit. Holds function fields
/// (build/toCode), so it stays a plain class. Adding a widget type = appending
/// one of these to the registry and nothing else.
class WidgetDefinition {
  const WidgetDefinition({
    required this.type,
    required this.childRule,
    required this.properties,
  });

  final String type;
  final ChildRule childRule;
  final List<PropertySpec> properties;
}
