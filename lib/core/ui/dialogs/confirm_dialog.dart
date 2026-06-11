import 'package:flutter/material.dart';

/// A yes/no confirmation. Returns true only if the user confirms. [destructive]
/// styles the confirm button as a warning (delete, discard, …).
Future<bool> confirm(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'OK',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: destructive
                ? FilledButton.styleFrom(backgroundColor: colors.error)
                : null,
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
