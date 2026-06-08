import 'package:flutter/material.dart';

/// Prompts for a name. Returns the trimmed value, or null if cancelled/empty.
Future<String?> promptName(
  BuildContext context, {
  required String title,
  String initial = '',
  String confirmLabel = 'OK',
}) async {
  final controller = TextEditingController(text: initial);
  try {
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onSubmitted: (_) => Navigator.of(context).pop(controller.text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return (value == null || value.isEmpty) ? null : value;
  } finally {
    controller.dispose();
  }
}

/// Lets the user pick a destination folder. Returns the chosen path (`''` =
/// project root), or null if cancelled.
Future<String?> pickFolder(
  BuildContext context, {
  required String projectName,
  required List<String> folders,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Move to'),
      children: [
        for (final folder in folders)
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(folder),
            child: Row(
              children: [
                Icon(
                  folder.isEmpty ? Icons.home_outlined : Icons.folder_outlined,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(folder.isEmpty ? projectName : folder)),
              ],
            ),
          ),
      ],
    ),
  );
}

/// Asks the user to confirm deleting [label]. Returns true if confirmed.
Future<bool> confirmDelete(
  BuildContext context, {
  required String label,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete "$label"?'),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}
