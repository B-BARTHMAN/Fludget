import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/ui/widgets/tree/widget_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The "+" affordance shown for a slot with room: picks a widget type and adds
/// it as a child of [parentId] in [slotName].
class AddChildButton extends StatelessWidget {
  const AddChildButton({
    required this.parentId,
    required this.slotName,
    super.key,
  });

  final String parentId;
  final String slotName;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return WidgetPicker(
      onSelected: (type) => context.read<ComponentEditorCubit>().addChild(
        parentId,
        slotName,
        type,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(Icons.add, size: 16, color: colors.primary),
            const SizedBox(width: 4),
            Text('Add', style: TextStyle(color: colors.primary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
