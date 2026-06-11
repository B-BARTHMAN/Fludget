import 'package:flutter/material.dart';

/// What the user chose when prompted about unsaved changes.
enum SaveChoice { save, discard, cancel }

/// Asks what to do with unsaved changes — when closing a dirty tab or switching
/// away from a project with unsaved work. Returns [SaveChoice.cancel] if
/// dismissed.
Future<SaveChoice> askSaveChanges(
  BuildContext context, {
  String message = 'Save your changes?',
  String saveLabel = 'Save',
}) async {
  final choice = await showDialog<SaveChoice>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Unsaved changes'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(SaveChoice.cancel),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(SaveChoice.discard),
          child: const Text('Discard'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(SaveChoice.save),
          child: Text(saveLabel),
        ),
      ],
    ),
  );
  return choice ?? SaveChoice.cancel;
}
