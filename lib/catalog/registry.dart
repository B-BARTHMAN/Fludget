import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:fludget/catalog/widgets/registry/layout_defs.dart';

/// All built-in widget defs by type, composed from the per-category lists so
/// no single file grows without bound.
final Map<String, WidgetDef> widgetRegistry = {
  for (final def in [
    ...layoutDefs,
    // ...displayDefs, ...inputDefs  as those categories are added
  ])
    def.type: def,
};

/// A [WidgetSource] backed by the built-in registry. The engine runs against
/// this; composition later wraps it in a composite that also resolves the
/// project's components.
class RegistryWidgetSource implements WidgetSource {
  const RegistryWidgetSource();

  @override
  WidgetDef? defFor(String type) => widgetRegistry[type];
}
