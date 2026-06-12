import 'package:fludget/catalog/engine/widget_source.dart';
import 'package:fludget/catalog/widget_def.dart';
import 'package:fludget/features/composition/logic/component_def.dart';
import 'package:fludget/features/composition/logic/component_library.dart';
import 'package:fludget/features/project/logic/loaded_project.dart';

/// Resolves types against the built-in registry first, then the project's own
/// components — so a component can be used as a widget. Reads the current
/// project lazily via [_project], so it always reflects the latest load.
class ComponentWidgetSource implements WidgetSource {
  ComponentWidgetSource(this._builtins, this._project);

  final WidgetSource _builtins;
  final LoadedProject? Function() _project;

  @override
  WidgetDef? defFor(String type) {
    final builtin = _builtins.defFor(type);
    if (builtin != null) return builtin;
    final project = _project();
    if (project == null) return null;
    final component = ComponentLibrary(project).byId(type);
    return component == null ? null : componentDef(component, this);
  }
}
