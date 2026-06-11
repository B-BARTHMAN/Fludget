import 'package:flutter/material.dart';

/// One choice in a [pickOption] dialog: the [value] returned when tapped, its
/// [label], an optional [icon], and whether it's the [current] selection.
class PickerOption<T> {
  const PickerOption(this.value, this.label, {this.icon, this.current = false});

  final T value;
  final String label;
  final IconData? icon;
  final bool current;
}

/// Shows [options] in a list and returns the chosen value, or null if
/// dismissed. Backs both "move to folder" and "open project".
Future<T?> pickOption<T>(
  BuildContext context, {
  required String title,
  required List<PickerOption<T>> options,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(title),
      children: [
        for (final option in options)
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(option.value),
            child: Row(
              children: [
                if (option.icon != null) ...[
                  Icon(option.icon, size: 20),
                  const SizedBox(width: 12),
                ],
                Expanded(child: Text(option.label)),
                if (option.current) const Icon(Icons.check, size: 18),
              ],
            ),
          ),
      ],
    ),
  );
}
