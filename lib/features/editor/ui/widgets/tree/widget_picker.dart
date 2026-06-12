import 'package:fludget/catalog/registry.dart';
import 'package:fludget/catalog/widgets/catalog_picker.dart';
import 'package:fludget/catalog/widgets/picker_node.dart';
import 'package:fludget/features/composition/logic/custom_picker.dart';
import 'package:fludget/features/editor/ui/widgets/tree/picker/picker_dialog.dart';
import 'package:fludget/features/project/state/project_cubit.dart';
import 'package:fludget/features/workspace/state/workspace_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A trigger that opens the drill-down widget picker. On selection it reports
/// the chosen type (a built-in name or a component id) via [onSelected]. Shared
/// by the empty canvas and the tree's add-child button.
class WidgetPicker extends StatelessWidget {
  const WidgetPicker({
    required this.onSelected,
    required this.child,
    super.key,
  });

  final ValueChanged<String> onSelected;
  final Widget child;

  Future<void> _open(BuildContext context) async {
    final roots = [
      ...buildCatalogNodes(widgetRegistry.values),
      ...?_customRoots(context),
    ];
    final type = await showWidgetPicker(context, roots);
    if (type != null) onSelected(type);
  }

  List<PickerNode>? _customRoots(BuildContext context) {
    final project = context.read<ProjectCubit>().state.project;
    if (project == null) return null;
    final editingId = context.read<WorkspaceCubit>().state.active?.componentId;
    final custom = buildCustomNode(project, editingId);
    return custom == null ? null : [custom];
  }

  @override
  Widget build(BuildContext context) =>
      GestureDetector(onTap: () => _open(context), child: child);
}
