import 'package:flutter/material.dart';

/// Prompts for a name. Returns the trimmed value, or null if cancelled/empty.
Future<String?> promptName(
  BuildContext context, {
  required String title,
  String initial = '',
  String confirmLabel = 'OK',
}) async {
  final value = await showDialog<String>(
    context: context,
    builder: (context) => _NameDialog(
      title: title,
      initial: initial,
      confirmLabel: confirmLabel,
    ),
  );
  return (value == null || value.isEmpty) ? null : value;
}

/// Owns its own controller so it lives exactly as long as the dialog is
/// mounted — disposed on unmount (after the close animation), never by hand.
class _NameDialog extends StatefulWidget {
  const _NameDialog({
    required this.title,
    required this.initial,
    required this.confirmLabel,
  });

  final String title;
  final String initial;
  final String confirmLabel;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
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

Future<String?> pickProject(
  BuildContext context, {
  required List<String> projects,
  required String current,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Open project'),
      children: [
        for (final name in projects)
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(name),
            child: Row(
              children: [
                Icon(
                  name == current ? Icons.folder_open : Icons.folder_outlined,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(name)),
                if (name == current) const Icon(Icons.check, size: 18),
              ],
            ),
          ),
      ],
    ),
  );
}
