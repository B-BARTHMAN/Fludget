import 'package:fludget/core/ui/tokens.dart';
import 'package:fludget/features/editor/state/component_editor_cubit.dart';
import 'package:fludget/features/editor/ui/widgets/tree/widget_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shown on the canvas before a component has a root: a prompt plus a picker
/// that sets the first widget.
class EmptyCanvas extends StatelessWidget {
  const EmptyCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_to_photos_outlined,
              size: 48,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: Insets.md),
            Text(
              'This component is empty',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Insets.xs),
            Text(
              'Pick the first widget to start building.',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            WidgetPicker(
              onSelected: (type) =>
                  context.read<ComponentEditorCubit>().setRoot(type),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: Insets.md,
                ),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18, color: colors.onPrimary),
                    const SizedBox(width: Insets.sm),
                    Text(
                      'Add a widget',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
